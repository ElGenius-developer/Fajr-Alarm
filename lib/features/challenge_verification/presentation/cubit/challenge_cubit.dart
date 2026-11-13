import 'dart:async';
import 'dart:typed_data';

import 'package:fajr_alarm/core/error/failures.dart';
import 'package:fajr_alarm/features/challenge_verification/domain/entities/challenge_mode.dart';
import 'package:fajr_alarm/features/challenge_verification/domain/entities/challenge_verification_result.dart';
import 'package:fajr_alarm/features/challenge_verification/domain/entities/tilt_angle_reading.dart';
import 'package:fajr_alarm/features/challenge_verification/domain/repositories/challenge_verification_repository.dart';
import 'package:fajr_alarm/features/challenge_verification/domain/usecases/resolve_offline_fallback_usecase.dart';
import 'package:fajr_alarm/features/challenge_verification/domain/usecases/verify_bathroom_barcode_usecase.dart';
import 'package:fajr_alarm/features/challenge_verification/domain/usecases/verify_prayer_rug_photo_usecase.dart';
import 'package:fajr_alarm/features/challenge_verification/domain/usecases/verify_standing_typing_usecase.dart';
import 'package:fajr_alarm/features/challenge_verification/presentation/cubit/challenge_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fpdart/fpdart.dart';

/// Coordinates Proof-of-Action challenge verification, tilt monitoring,
/// and automatic offline fallback transitions.
class ChallengeCubit extends Cubit<ChallengeState> {
  ChallengeCubit({
    required this._verifyPrayerRugPhoto,
    required this._verifyBathroomBarcode,
    required this._verifyStandingTyping,
    required this._resolveOfflineFallback,
    required this._repository,
  }) : super(const ChallengeState());

  final VerifyPrayerRugPhotoUseCase _verifyPrayerRugPhoto;
  final VerifyBathroomBarcodeUseCase _verifyBathroomBarcode;
  final VerifyStandingTypingUseCase _verifyStandingTyping;
  final ResolveOfflineFallbackUseCase _resolveOfflineFallback;
  final ChallengeVerificationRepository _repository;

  StreamSubscription<Either<Failure, TiltAngleReading>>? _tiltSubscription;

  /// Begins listening to live accelerometer tilt readings.
  void startTiltMonitoring() {
    _tiltSubscription?.cancel();
    _tiltSubscription = _repository.watchTiltAngle().listen((
      Either<Failure, TiltAngleReading> result,
    ) {
      result.fold(
        (Failure failure) => emit(state.copyWith(failure: failure)),
        (TiltAngleReading reading) =>
            emit(state.copyWith(tiltReading: reading)),
      );
    });
  }

  /// Toggles the camera torch state.
  void toggleTorch() {
    emit(state.copyWith(isTorchOn: !state.isTorchOn));
  }

  /// Sets the localized 120-character Adhkar prompt for Standing Typing mode.
  void setTypingPrompt(String prompt) {
    if (state.typingPrompt == prompt) {
      return;
    }
    emit(state.copyWith(typingPrompt: prompt));
  }

  /// Updates the user's typed text in Standing Typing Challenge.
  void updateTypedText(String text) {
    emit(
      state.copyWith(
        typedText: text,
        status: state.status == ChallengeStatus.rejected
            ? ChallengeStatus.initial
            : state.status,
        rejectionMessage: null,
      ),
    );
  }

  /// Submits a live camera photo for Gemini Vision verification.
  Future<void> submitPhoto({
    required Uint8List imageBytes,
    required String localeCode,
  }) async {
    emit(
      state.copyWith(
        status: ChallengeStatus.verifying,
        rejectionMessage: null,
        failure: null,
      ),
    );

    final Either<Failure, ChallengeVerificationResult> result =
        await _verifyPrayerRugPhoto(
          imageBytes: imageBytes,
          localeCode: localeCode,
        );

    await result.fold(
      (Failure failure) async {
        if (_shouldTriggerOfflineFallback(failure)) {
          await _switchToOfflineFallback(failure: failure);
        } else {
          emit(
            state.copyWith(
              status: ChallengeStatus.rejected,
              failure: failure,
              rejectionMessage: failure.message,
            ),
          );
        }
      },
      (ChallengeVerificationResult verification) async {
        if (verification.verified) {
          emit(
            state.copyWith(
              status: ChallengeStatus.verified,
              verificationResult: verification,
              rejectionMessage: null,
            ),
          );
        } else {
          emit(
            state.copyWith(
              status: ChallengeStatus.rejected,
              verificationResult: verification,
              rejectionMessage: verification.rejectionReason,
            ),
          );
        }
      },
    );
  }

  /// Submits a scanned barcode for Bathroom Barcode Challenge.
  Future<void> submitBarcode(String scannedBarcode) async {
    if (state.status == ChallengeStatus.verifying ||
        state.status == ChallengeStatus.verified) {
      return;
    }

    emit(
      state.copyWith(
        status: ChallengeStatus.verifying,
        rejectionMessage: null,
        failure: null,
      ),
    );

    final Either<Failure, bool> result = await _verifyBathroomBarcode(
      scannedBarcode: scannedBarcode,
    );

    result.fold(
      (Failure failure) => emit(
        state.copyWith(
          status: ChallengeStatus.rejected,
          failure: failure,
          rejectionMessage: failure.message,
        ),
      ),
      (bool matched) => emit(
        state.copyWith(
          status: matched ? ChallengeStatus.verified : ChallengeStatus.rejected,
        ),
      ),
    );
  }

  /// Submits the typed 120-character Adhkar text for Standing Typing Challenge.
  Future<void> submitStandingTyping() async {
    emit(
      state.copyWith(
        status: ChallengeStatus.verifying,
        rejectionMessage: null,
        failure: null,
      ),
    );

    final Either<Failure, bool> result = await _verifyStandingTyping(
      typedText: state.typedText,
      expectedText: state.typingPrompt,
    );

    result.fold(
      (Failure failure) => emit(
        state.copyWith(
          status: ChallengeStatus.rejected,
          failure: failure,
          rejectionMessage: failure.message,
        ),
      ),
      (bool matched) => emit(
        state.copyWith(
          status: matched ? ChallengeStatus.verified : ChallengeStatus.rejected,
        ),
      ),
    );
  }

  /// Marks the camera as unavailable and switches directly to Standing Typing.
  Future<void> reportCameraUnavailable() async {
    emit(state.copyWith(isCameraAvailable: false));
    await _switchToOfflineFallback(
      failure: const Failure.camera(message: 'Camera unavailable'),
    );
  }

  Future<void> _switchToOfflineFallback({Failure? failure}) async {
    final Either<Failure, ChallengeMode> fallback =
        await _resolveOfflineFallback(
          isCameraAvailable: state.isCameraAvailable,
        );

    fallback.fold(
      (_) => emit(
        state.copyWith(
          mode: ChallengeMode.standingTyping,
          status: ChallengeStatus.fallbackTriggered,
          failure: failure,
        ),
      ),
      (ChallengeMode mode) => emit(
        state.copyWith(
          mode: mode,
          status: ChallengeStatus.fallbackTriggered,
          failure: failure,
        ),
      ),
    );
  }

  bool _shouldTriggerOfflineFallback(Failure failure) {
    return switch (failure) {
      NetworkFailure() => true,
      QuotaExceededFailure() => true,
      ApiFailure(:final int? statusCode) =>
        statusCode == 429 ||
            statusCode == 403 ||
            (statusCode != null && statusCode >= 500),
      _ => false,
    };
  }

  @override
  Future<void> close() async {
    await _tiltSubscription?.cancel();
    return super.close();
  }
}
