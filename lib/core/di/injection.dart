import 'package:fajr_alarm/core/time/monotonic_clock.dart';
import 'package:get_it/get_it.dart';

/// Global service locator instance.
final GetIt sl = GetIt.instance;

/// Initializes core and feature dependencies.
Future<void> initDependencies() async {
  if (!sl.isRegistered<MonotonicClock>()) {
    sl.registerLazySingleton<MonotonicClock>(SystemMonotonicClock.new);
  }
}
