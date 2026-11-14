import 'package:fajr_alarm/core/error/failures.dart';
import 'package:fajr_alarm/core/l10n/generated/app_localizations.dart';
import 'package:fajr_alarm/core/theme/app_theme.dart';
import 'package:fajr_alarm/features/onboarding/presentation/bloc/onboarding_cubit.dart';
import 'package:fajr_alarm/features/onboarding/presentation/bloc/onboarding_state.dart';
import 'package:fajr_alarm/features/onboarding/presentation/widgets/barcode_step_view.dart';
import 'package:fajr_alarm/features/onboarding/presentation/widgets/location_step_view.dart';
import 'package:fajr_alarm/features/onboarding/presentation/widgets/permissions_gate_step_view.dart';
import 'package:fajr_alarm/features/onboarding/presentation/widgets/privacy_key_step_view.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

/// 4-Step Onboarding page coordinating Location, Permissions Gate, BYOK Consent & Key, and Barcode.
class OnboardingPage extends StatelessWidget {
  const OnboardingPage({super.key, this.onCompleted});

  final VoidCallback? onCompleted;

  static const int _totalSteps = 4;

  String _mapFailureMessage(Failure failure, AppLocalizations l10n, int step) {
    return failure.when(
      cache: (_) => l10n.commonErrorGeneric,
      network: (_) => l10n.onboardingApiKeyInvalidError,
      api: (_, _) => l10n.onboardingApiKeyInvalidError,
      permission: (_) => l10n.onboardingPermGateBlocked,
      platform: (_) => l10n.onboardingPermGateBlocked,
      validation: (_) {
        if (step == 0) return l10n.onboardingLocationErrorInvalid;
        if (step == 2) return l10n.onboardingConsentRequiredError;
        return l10n.onboardingIncompleteError;
      },
      sensor: (_) => l10n.commonErrorGeneric,
      camera: (_) => l10n.commonErrorGeneric,
      lockWindow: (_) => l10n.commonErrorGeneric,
      quotaExceeded: (_) => l10n.onboardingApiKeyInvalidError,
      unexpected: (_) => l10n.commonErrorGeneric,
    );
  }

  @override
  Widget build(BuildContext context) {
    final AppLocalizations l10n = AppLocalizations.of(context)!;
    final ThemeData theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(title: Text(l10n.onboardingTitle)),
      body: BlocConsumer<OnboardingCubit, OnboardingState>(
        listenWhen: (OnboardingState prev, OnboardingState curr) =>
            !prev.entity.isCompleted && curr.entity.isCompleted,
        listener: (BuildContext context, OnboardingState state) {
          onCompleted?.call();
        },
        builder: (BuildContext context, OnboardingState state) {
          if (state.isLoading) {
            return const Center(child: CircularProgressIndicator());
          }

          final OnboardingCubit cubit = context.read<OnboardingCubit>();
          final int currentStep = state.entity.step.clamp(0, _totalSteps - 1);

          return SafeArea(
            child: SingleChildScrollView(
              padding: const EdgeInsetsDirectional.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: <Widget>[
                  Text(
                    l10n.onboardingStepOf(currentStep + 1, _totalSteps),
                    style: theme.textTheme.labelLarge?.copyWith(
                      color: FajrDesignTokens.of(context).textSecondary,
                    ),
                  ),
                  const SizedBox(height: 10),
                  Row(
                    children: List<Widget>.generate(_totalSteps, (int index) {
                      final tokens = FajrDesignTokens.of(context);
                      final bool active = index <= currentStep;
                      return Expanded(
                        child: Container(
                          height: 4,
                          margin: EdgeInsetsDirectional.only(
                            end: index < _totalSteps - 1 ? 6 : 0,
                          ),
                          decoration: BoxDecoration(
                            color: active
                                ? tokens.dawnAccent
                                : tokens.surfaceElevated,
                            borderRadius: BorderRadius.circular(2),
                          ),
                        ),
                      );
                    }),
                  ),
                  if (state.error != null) ...<Widget>[
                    const SizedBox(height: 16),
                    MaterialBanner(
                      key: const Key('onboarding_error_banner'),
                      content: Text(
                        _mapFailureMessage(state.error!, l10n, currentStep),
                      ),
                      actions: <Widget>[
                        TextButton(
                          onPressed: () => cubit.goToStep(currentStep),
                          child: Text(l10n.commonDone),
                        ),
                      ],
                    ),
                  ],
                  const SizedBox(height: 20),
                  switch (currentStep) {
                    0 => LocationStepView(
                      initialCity: state.entity.cityName,
                      initialLatitude: state.entity.latitude,
                      initialLongitude: state.entity.longitude,
                      isSubmitting: state.isSubmitting,
                      onSaveLocation: cubit.saveLocation,
                    ),
                    1 => PermissionsGateStepView(
                      status: state.permissionsStatus,
                      isSubmitting: state.isSubmitting,
                      onRequestPermissions: () =>
                          cubit.checkPermissions(request: true),
                      onRefreshStatus: () =>
                          cubit.checkPermissions(request: false),
                      onContinue: cubit.continueFromPermissionsGate,
                      onBack: () => cubit.goToStep(0),
                    ),
                    2 => PrivacyKeyStepView(
                      consentAccepted: state.entity.privacyConsentAccepted,
                      apiKeyValidated: state.entity.apiKeyValidated,
                      isValidating: state.isValidatingKey,
                      onConsentChanged: cubit.setPrivacyConsent,
                      onTestAndSaveKey: cubit.validateAndSaveApiKey,
                      onBack: () => cubit.goToStep(1),
                    ),
                    _ => BarcodeStepView(
                      initialBarcode: state.entity.registeredBarcode,
                      isSubmitting: state.isSubmitting,
                      onRegisterBarcode: (String code) =>
                          cubit.registerBarcodeAndComplete(code),
                      onSkip: () => cubit.registerBarcodeAndComplete(null),
                      onBack: () => cubit.goToStep(2),
                    ),
                  },
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
