import 'package:freezed_annotation/freezed_annotation.dart';

part 'failures.freezed.dart';

/// Domain-level failure union returned via [Either<Failure, T>].
@freezed
sealed class Failure with _$Failure {
  const factory Failure.cache({required String message}) = CacheFailure;
  const factory Failure.network({required String message}) = NetworkFailure;
  const factory Failure.api({required String message, int? statusCode}) =
      ApiFailure;
  const factory Failure.permission({required String message}) =
      PermissionFailure;
  const factory Failure.platform({required String message}) = PlatformFailure;
  const factory Failure.validation({required String message}) =
      ValidationFailure;
  const factory Failure.sensor({required String message}) = SensorFailure;
  const factory Failure.camera({required String message}) = CameraFailure;
  const factory Failure.lockWindow({required String message}) =
      LockWindowFailure;
  const factory Failure.quotaExceeded({required String message}) =
      QuotaExceededFailure;
  const factory Failure.unexpected({required String message}) =
      UnexpectedFailure;
}
