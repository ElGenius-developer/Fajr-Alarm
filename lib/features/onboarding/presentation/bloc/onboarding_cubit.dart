import 'package:fajr_alarm/core/error/failures.dart';
import 'package:fajr_alarm/features/onboarding/domain/entities/onboarding_state_entity.dart';
import 'package:fajr_alarm/features/onboarding/domain/repositories/onboarding_repository.dart';
import 'package:fajr_alarm/features/onboarding/domain/usecases/check_permissions_gate_usecase.dart';
import 'package:fajr_alarm/features/onboarding/domain/usecases/complete_onboarding_usecase.dart';
import 'package:fajr_alarm/features/onboarding/domain/usecases/register_bathroom_barcode_usecase.dart';
import 'package:fajr_alarm/features/onboarding/domain/usecases/save_location_usecase.dart';
import 'package:fajr_alarm/features/onboarding/domain/usecases/validate_and_save_gemini_key_usecase.dart';
import 'package:fajr_alarm/features/onboarding/presentation/bloc/onboarding_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fpdart/fpdart.dart';

/// Manages the 4-step onboarding flow, mandatory permissions gate, and BYOK consent.
final class OnboardingCubit extends Cubit<OnboardingState> {
  OnboardingCubit({
    required this._repository,
    required this._saveLocationUseCase,
    required this._checkPermissionsGateUseCase,
    required this._validateAndSaveGeminiKeyUseCase,
    required this._registerBathroomBarcodeUseCase,
    required this._completeOnboardingUseCase,
  }) : super(const OnboardingState());

  final OnboardingRepository _repository;
  final SaveLocationUseCase _saveLocationUseCase;
  final CheckPermissionsGateUseCase _checkPermissionsGateUseCase;
  final ValidateAndSaveGeminiKeyUseCase _validateAndSaveGeminiKeyUseCase;
  final RegisterBathroomBarcodeUseCase _registerBathroomBarcodeUseCase;
  final CompleteOnboardingUseCase _completeOnboardingUseCase;

  /// Loads persisted onboarding state and checks current OS permissions.
  Future<void> loadOnboarding() async {
    if (isClosed) return;
    emit(state.copyWith(isLoading: true, error: null));
    final Either<Failure, OnboardingStateEntity> stateResult = await _repository
        .getOnboardingState();
    if (isClosed) return;

    await stateResult.fold(
      (Failure failure) async {
        _safeEmit(state.copyWith(isLoading: false, error: failure));
      },
      (OnboardingStateEntity entity) async {
        final Either<Failure, PermissionsGateStatus> permResult =
            await _checkPermissionsGateUseCase(request: false);
        if (isClosed) return;
        permResult.fold(
          (Failure failure) {
            _safeEmit(
              state.copyWith(entity: entity, isLoading: false, error: failure),
            );
          },
          (PermissionsGateStatus status) {
            _safeEmit(
              state.copyWith(
                entity: entity.copyWith(permissionsGranted: status.allGranted),
                permissionsStatus: status,
                isLoading: false,
              ),
            );
          },
        );
      },
    );
  }

  /// Step 1: Saves location & city and advances to Step 2 on success.
  Future<void> saveLocation({
    required double latitude,
    required double longitude,
    required String cityName,
  }) async {
    if (isClosed) return;
    emit(state.copyWith(isSubmitting: true, error: null));
    final Either<Failure, OnboardingStateEntity> result =
        await _saveLocationUseCase(
          latitude: latitude,
          longitude: longitude,
          cityName: cityName,
        );
    if (isClosed) return;

    await result.fold(
      (Failure failure) async {
        _safeEmit(state.copyWith(isSubmitting: false, error: failure));
      },
      (OnboardingStateEntity updated) async {
        final OnboardingStateEntity next = updated.copyWith(step: 1);
        await _repository.updateStep(1);
        _safeEmit(
          state.copyWith(entity: next, isSubmitting: false, error: null),
        );
      },
    );
  }

  /// Step 2: Checks or requests mandatory OS permissions.
  Future<void> checkPermissions({bool request = false}) async {
    if (isClosed) return;
    emit(state.copyWith(isSubmitting: true, error: null));
    final Either<Failure, PermissionsGateStatus> result =
        await _checkPermissionsGateUseCase(request: request);
    if (isClosed) return;

    result.fold(
      (Failure failure) {
        _safeEmit(state.copyWith(isSubmitting: false, error: failure));
      },
      (PermissionsGateStatus status) {
        _safeEmit(
          state.copyWith(
            entity: state.entity.copyWith(
              permissionsGranted: status.allGranted,
            ),
            permissionsStatus: status,
            isSubmitting: false,
            error: null,
          ),
        );
      },
    );
  }

  /// Advances from Step 2 to Step 3 only when all mandatory permissions are granted.
  Future<void> continueFromPermissionsGate() async {
    if (isClosed) return;
    if (!state.permissionsStatus.allGranted) {
      emit(
        state.copyWith(
          error: const Failure.permission(
            message: 'All mandatory permissions must be granted.',
          ),
        ),
      );
      return;
    }
    await goToStep(2);
  }

  /// Step 3: Updates explicit Google Free Tier privacy consent checkbox.
  Future<void> setPrivacyConsent(bool accepted) async {
    if (isClosed) return;
    emit(
      state.copyWith(
        entity: state.entity.copyWith(privacyConsentAccepted: accepted),
        error: null,
      ),
    );
    await _repository.setPrivacyConsentAccepted(accepted);
  }

  /// Step 3: Validates Gemini key live and saves it only if explicit consent is true.
  Future<void> validateAndSaveApiKey(String apiKey) async {
    if (isClosed) return;
    emit(state.copyWith(isValidatingKey: true, error: null));
    final Either<Failure, bool> result = await _validateAndSaveGeminiKeyUseCase(
      apiKey: apiKey,
      privacyConsentAccepted: state.entity.privacyConsentAccepted,
    );
    if (isClosed) return;

    await result.fold(
      (Failure failure) async {
        _safeEmit(
          state.copyWith(
            isValidatingKey: false,
            entity: state.entity.copyWith(apiKeyValidated: false),
            error: failure,
          ),
        );
      },
      (bool valid) async {
        final OnboardingStateEntity updated = state.entity.copyWith(
          apiKeyValidated: valid,
          step: valid ? 3 : state.entity.step,
        );
        if (valid) {
          await _repository.updateStep(3);
        }
        _safeEmit(
          state.copyWith(entity: updated, isValidatingKey: false, error: null),
        );
      },
    );
  }

  /// Step 4: Registers a bathroom barcode (or skips with `null`) and completes onboarding.
  Future<void> registerBarcodeAndComplete(String? barcode) async {
    if (isClosed) return;
    emit(state.copyWith(isSubmitting: true, error: null));
    final Either<Failure, Unit> barcodeResult =
        await _registerBathroomBarcodeUseCase(barcode: barcode);
    if (isClosed) return;

    await barcodeResult.fold(
      (Failure failure) async {
        _safeEmit(state.copyWith(isSubmitting: false, error: failure));
      },
      (_) async {
        final Either<Failure, OnboardingStateEntity> completeResult =
            await _completeOnboardingUseCase();
        if (isClosed) return;
        completeResult.fold(
          (Failure failure) {
            _safeEmit(state.copyWith(isSubmitting: false, error: failure));
          },
          (OnboardingStateEntity completed) {
            _safeEmit(
              state.copyWith(
                entity: completed,
                isSubmitting: false,
                error: null,
              ),
            );
          },
        );
      },
    );
  }

  /// Navigates to a specific step index (0..3).
  Future<void> goToStep(int step) async {
    final int clamped = step.clamp(0, 3);
    await _repository.updateStep(clamped);
    _safeEmit(
      state.copyWith(entity: state.entity.copyWith(step: clamped), error: null),
    );
  }

  void _safeEmit(OnboardingState nextState) {
    if (!isClosed) {
      emit(nextState);
    }
  }
}
