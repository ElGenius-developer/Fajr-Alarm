import 'package:fajr_alarm/features/onboarding/data/models/onboarding_state_model.dart';
import 'package:fajr_alarm/features/onboarding/domain/entities/onboarding_state_entity.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:hive_ce/hive.dart';

/// Local persistence contract for onboarding state (`hive_ce`) and BYOK key (`FlutterSecureStorage`).
abstract interface class OnboardingLocalDataSource {
  Future<OnboardingStateEntity> getOnboardingState();
  Future<OnboardingStateEntity> saveOnboardingState(
    OnboardingStateEntity state,
  );
  Future<void> saveGeminiKey(String apiKey);
  Future<String?> getGeminiKey();
}

/// Default implementation backed by `hive_ce` and `FlutterSecureStorage`.
final class OnboardingLocalDataSourceImpl implements OnboardingLocalDataSource {
  OnboardingLocalDataSourceImpl({
    required this._stateBox,
    required this._secureStorage,
  });

  static const String stateKey = 'onboarding_state';
  static const String geminiApiKeyStorageKey = 'fajr_alarm_gemini_api_key';

  final Box<OnboardingStateModel> _stateBox;
  final FlutterSecureStorage _secureStorage;

  @override
  Future<OnboardingStateEntity> getOnboardingState() async {
    final OnboardingStateModel? model = _stateBox.get(stateKey);
    if (model == null) {
      return const OnboardingStateEntity();
    }
    return model.toEntity();
  }

  @override
  Future<OnboardingStateEntity> saveOnboardingState(
    OnboardingStateEntity state,
  ) async {
    await _stateBox.put(stateKey, OnboardingStateModel.fromEntity(state));
    return state;
  }

  @override
  Future<void> saveGeminiKey(String apiKey) async {
    await _secureStorage.write(key: geminiApiKeyStorageKey, value: apiKey);
  }

  @override
  Future<String?> getGeminiKey() async {
    return _secureStorage.read(key: geminiApiKeyStorageKey);
  }
}
