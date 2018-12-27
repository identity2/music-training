import XCTest
import UIKit
@testable import MusicTraining

class NoteGeneratorTests: XCTestCase {

    override func setUp() {
        super.setUp()
    }

    override func tearDown() {
        super.tearDown()
    }

    func testGetNoteBy() {
        // Given When Then
        XCTAssertEqual(NoteGenerator.getNoteBy(index: 0, isTreble: false), Note(octave: 2, key: .D))
        XCTAssertEqual(NoteGenerator.getNoteBy(index: 4, isTreble: false), Note(octave: 2, key: .A))
        XCTAssertEqual(NoteGenerator.getNoteBy(index: 5, isTreble: false), Note(octave: 2, key: .B))
        XCTAssertEqual(NoteGenerator.getNoteBy(index: 12, isTreble: false), Note(octave: 3, key: .B))
        XCTAssertEqual(NoteGenerator.getNoteBy(index: 14, isTreble: false), Note(octave: 4, key: .D))
        
        XCTAssertEqual(NoteGenerator.getNoteBy(index: 0, isTreble: true), Note(octave: 3, key: .D))
        XCTAssertEqual(NoteGenerator.getNoteBy(index: 7, isTreble: true), Note(octave: 4, key: .B))
        XCTAssertEqual(NoteGenerator.getNoteBy(index: 8, isTreble: true), Note(octave: 5, key: .C))
        XCTAssertEqual(NoteGenerator.getNoteBy(index: 12, isTreble: true), Note(octave: 5, key: .G))
        XCTAssertEqual(NoteGenerator.getNoteBy(index: 14, isTreble: true), Note(octave: 5, key: .B))
    }

    func testGetNoteImageBy() {
        // Given When Then
        XCTAssert(NoteGenerator.getNoteImageBy(index: 0, isTreble: false).isEqual(UIImage(named: "bass_0")))
        XCTAssert(NoteGenerator.getNoteImageBy(index: 9, isTreble: false).isEqual(UIImage(named: "bass_9")))
        XCTAssert(NoteGenerator.getNoteImageBy(index: 13, isTreble: false).isEqual(UIImage(named: "bass_13")))
        
        XCTAssert(NoteGenerator.getNoteImageBy(index: 2, isTreble: true).isEqual(UIImage(named: "treble_2")))
        XCTAssert(NoteGenerator.getNoteImageBy(index: 7, isTreble: true).isEqual(UIImage(named: "treble_7")))
        XCTAssert(NoteGenerator.getNoteImageBy(index: 14, isTreble: true).isEqual(UIImage(named: "treble_14")))
    }
}
