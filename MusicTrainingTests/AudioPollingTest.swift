import XCTest
@testable import MusicTraining

class AudioPollingTest: XCTestCase {

    override func setUp() {
        super.setUp()
    }

    override func tearDown() {
        super.tearDown()
    }

    func testGetNearestNote() {
        XCTAssertEqual(AudioPoller.nearestNote(of: 34.5).key, .C)
        XCTAssertEqual(AudioPoller.nearestNote(of: 51.0).key, .G)
        XCTAssertEqual(AudioPoller.nearestNote(of: 65.5).key, .C)
        XCTAssertEqual(AudioPoller.nearestNote(of: 103.5).key, .G)
        XCTAssertEqual(AudioPoller.nearestNote(of: 185.0).key, .F)
        XCTAssertEqual(AudioPoller.nearestNote(of: 980.5).key, .B)
        XCTAssertEqual(AudioPoller.nearestNote(of: 1244.5).key, .D)
        XCTAssertEqual(AudioPoller.nearestNote(of: 2093.0).key, .C)
        XCTAssertEqual(AudioPoller.nearestNote(of: 7902.5).key, .B)
        XCTAssertEqual(AudioPoller.nearestNote(of: 10500.0).key, .E)
    }
}
