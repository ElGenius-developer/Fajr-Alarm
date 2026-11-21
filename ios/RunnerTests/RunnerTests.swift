import XCTest

@testable import Runner

final class FajrCascadePolicyTests: XCTestCase {
  private let fajr = Date(timeIntervalSince1970: 1_800_000_000)

  private func cascade(start: Date, isDryRun: Bool = false, offsets: [TimeInterval]) -> [FajrAlarmRecord] {
    offsets.map {
      FajrAlarmRecord(id: UUID(), fireAt: start.addingTimeInterval($0), cascadeStart: start, isDryRun: isDryRun)
    }
  }

  func testOpeningAppAfterFajrDoesNotReplaceTodaysRingingCascade() {
    let today = cascade(start: fajr, offsets: [0, 300, 360, 420])
    let now = fajr.addingTimeInterval(120)

    let replaced = FajrCascadePolicy.recordsToReplace(today, isDryRun: false, now: now)

    XCTAssertTrue(replaced.isEmpty)
  }

  func testReschedulingBeforeFajrReplacesTheNotYetStartedCascade() {
    let upcoming = cascade(start: fajr, offsets: [0, 300])
    let now = fajr.addingTimeInterval(-600)

    let replaced = FajrCascadePolicy.recordsToReplace(upcoming, isDryRun: false, now: now)

    XCTAssertEqual(replaced, upcoming)
  }

  func testRealRescheduleLeavesAPendingDryRunAlone() {
    let dryRun = cascade(start: fajr, isDryRun: true, offsets: [0])
    let now = fajr.addingTimeInterval(-5)

    let replaced = FajrCascadePolicy.recordsToReplace(dryRun, isDryRun: false, now: now)

    XCTAssertTrue(replaced.isEmpty)
  }

  func testStopAfterCascadeEndsRearmsOneMinuteLater() {
    let today = cascade(start: fajr, offsets: [0, 300, 900])
    let now = fajr.addingTimeInterval(1_200)

    let rearm = FajrCascadePolicy.rearmRecord(today, now: now)

    XCTAssertEqual(rearm?.fireAt, now.addingTimeInterval(60))
    XCTAssertEqual(rearm?.cascadeStart, fajr)
  }

  func testStopDuringCascadeDoesNotStackAnExtraAlarm() {
    let today = cascade(start: fajr, offsets: [0, 300, 360])
    let now = fajr.addingTimeInterval(310)

    XCTAssertNil(FajrCascadePolicy.rearmRecord(today, now: now))
  }

  func testStopWithNoStartedCascadeDoesNotRearm() {
    let tomorrow = cascade(start: fajr, offsets: [0])
    let now = fajr.addingTimeInterval(-3_600)

    XCTAssertNil(FajrCascadePolicy.rearmRecord(tomorrow, now: now))
  }

  func testDryRunRingingAfterARealRescheduleIsStillReportedAsDryRun() {
    let dryRunStart = fajr.addingTimeInterval(-86_400)
    let records =
      cascade(start: dryRunStart, isDryRun: true, offsets: [0])
      + cascade(start: fajr, offsets: [0, 300])
    let now = dryRunStart.addingTimeInterval(5)

    XCTAssertEqual(FajrCascadePolicy.ringingIsDryRun(records, now: now), true)
  }
}
