import 'package:fajr_alarm/core/l10n/generated/app_localizations.dart';
import 'package:fajr_alarm/core/theme/app_theme.dart';
import 'package:flutter/material.dart';

/// Step 3: Explicit Google Free Tier privacy consent + BYOK Gemini API key validation.
class PrivacyKeyStepView extends StatefulWidget {
  const PrivacyKeyStepView({
    super.key,
    required this.consentAccepted,
    required this.apiKeyValidated,
    required this.isValidating,
    required this.onConsentChanged,
    required this.onTestAndSaveKey,
    required this.onBack,
  });

  final bool consentAccepted;
  final bool apiKeyValidated;
  final bool isValidating;
  final ValueChanged<bool> onConsentChanged;
  final ValueChanged<String> onTestAndSaveKey;
  final VoidCallback onBack;

  @override
  State<PrivacyKeyStepView> createState() => _PrivacyKeyStepViewState();
}

class _PrivacyKeyStepViewState extends State<PrivacyKeyStepView> {
  final TextEditingController _apiKeyController = TextEditingController();
  bool _obscureKey = true;

  @override
  void dispose() {
    _apiKeyController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final AppLocalizations l10n = AppLocalizations.of(context)!;
    final ThemeData theme = Theme.of(context);
    final FajrDesignTokens tokens = FajrDesignTokens.of(context);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: <Widget>[
        Text(
          l10n.onboardingStep3Title,
          style: theme.textTheme.headlineSmall?.copyWith(
            color: tokens.textPrimary,
            fontWeight: FontWeight.w600,
          ),
        ),
        const SizedBox(height: 8),
        Text(
          l10n.onboardingStep3Subtitle,
          style: theme.textTheme.bodyMedium?.copyWith(
            color: tokens.textSecondary,
          ),
        ),
        const SizedBox(height: 16),
        Card(
          child: Padding(
            padding: const EdgeInsetsDirectional.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Container(
                  padding: const EdgeInsetsDirectional.symmetric(
                    horizontal: 10,
                    vertical: 5,
                  ),
                  decoration: BoxDecoration(
                    color: tokens.surfaceElevated,
                    borderRadius: BorderRadius.circular(999),
                    border: Border.all(
                      color: tokens.emeraldSignal.withValues(alpha: 0.4),
                    ),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: <Widget>[
                      Icon(
                        Icons.verified_user_outlined,
                        size: 14,
                        color: tokens.emeraldSignal,
                      ),
                      const SizedBox(width: 6),
                      Text(
                        l10n.challengeRamOnlyBadge,
                        style: theme.textTheme.labelSmall?.copyWith(
                          color: tokens.textSecondary,
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 12),
                Text(
                  l10n.onboardingPrivacyNoticeTitle,
                  style: theme.textTheme.titleMedium?.copyWith(
                    color: tokens.textPrimary,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  l10n.onboardingPrivacyNoticeBody,
                  style: theme.textTheme.bodySmall?.copyWith(
                    color: tokens.textSecondary,
                  ),
                ),
              ],
            ),
          ),
        ),
        const SizedBox(height: 12),
        Card(
          child: CheckboxListTile(
            key: const Key('onboarding_privacy_consent_checkbox'),
            value: widget.consentAccepted,
            onChanged: (bool? value) => widget.onConsentChanged(value ?? false),
            title: Text(
              l10n.onboardingPrivacyConsentCheckbox,
              style: theme.textTheme.bodyMedium?.copyWith(
                color: tokens.textPrimary,
              ),
            ),
            controlAffinity: ListTileControlAffinity.leading,
          ),
        ),
        const SizedBox(height: 12),
        TextField(
          key: const Key('onboarding_api_key_field'),
          controller: _apiKeyController,
          obscureText: _obscureKey,
          decoration: InputDecoration(
            labelText: l10n.onboardingApiKeyLabel,
            hintText: l10n.onboardingApiKeyHint,
            suffixIcon: IconButton(
              onPressed: () => setState(() => _obscureKey = !_obscureKey),
              icon: Icon(_obscureKey ? Icons.visibility : Icons.visibility_off),
            ),
          ),
        ),
        if (widget.apiKeyValidated) ...<Widget>[
          const SizedBox(height: 12),
          Row(
            children: <Widget>[
              Icon(Icons.check_circle, color: tokens.emeraldSignal),
              const SizedBox(width: 8),
              Expanded(
                child: Text(
                  l10n.onboardingKeyValidated,
                  style: theme.textTheme.bodyMedium?.copyWith(
                    color: tokens.emeraldSignal,
                  ),
                ),
              ),
            ],
          ),
        ],
        const SizedBox(height: 24),
        Row(
          children: <Widget>[
            OutlinedButton(
              onPressed: widget.onBack,
              child: Text(l10n.commonBack),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: FilledButton(
                key: const Key('onboarding_test_key_button'),
                onPressed: widget.isValidating
                    ? null
                    : () => widget.onTestAndSaveKey(_apiKeyController.text),
                child: Text(
                  widget.isValidating
                      ? l10n.onboardingTestingKey
                      : l10n.onboardingTestKeyButton,
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }
}
