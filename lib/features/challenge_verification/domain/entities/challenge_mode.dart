/// Active verification mode for dismissing the Fajr alarm.
enum ChallengeMode {
  /// Online primary: live POV camera photo verified by Gemini Vision.
  photoVision,

  /// Offline primary: scan a pre-registered bathroom product barcode.
  bathroomBarcode,

  /// Offline secondary: type 120-character Adhkar text while standing.
  standingTyping,
}
