import 'package:fajr_alarm/core/di/injection.dart';
import 'package:fajr_alarm/main.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  testWidgets('FajrAlarmApp renders initial schedule route', (
    WidgetTester tester,
  ) async {
    await sl.reset();
    await initDependencies();

    await tester.pumpWidget(const FajrAlarmApp());
    await tester.pumpAndSettle();

    expect(find.text('Schedule'), findsWidgets);
  });
}
