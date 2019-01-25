import UIKit

// Generate note or note pairs in different ways.
class NoteGenerator {
    // MARK: Constants.
    static let noteRange = 15
    static let trebleStartOctave = 3
    static let bassStartOctave = 2
    static let trebleStartNote = Note.Key.B
    static let bassStartNote = Note.Key.D
    static let treblePrefix = "treble_"
    static let bassPrefix = "bass_"
    
    // Get a uniformly random note-image pair from the available images.
    static func getRandomNoteImage(trebleOnly: Bool = false) -> (Note, UIImage) {
        let noteIndex = Int.random(in: 0..<noteRange)
        let isTreble = trebleOnly ? true : Bool.random()
        
        let resultNote = getNoteBy(index: noteIndex, isTreble: isTreble)
        let resultImage = getNoteImageBy(index: noteIndex, isTreble: isTreble)
        
        return (resultNote, resultImage)
    }
    
    // Get two random note-image pair from the same octave.
    static func getTwoRandomNoteImage(avoidSame: Bool, trebleOnly: Bool) -> ((Note, UIImage), (Note, UIImage)) {
        let noteIndex1 = Int.random(in: 0..<noteRange)
        var noteIndex2: Int
        
        // If avoidSame is true, loop until the indices are different.
        repeat {
            noteIndex2 = Int.random(in: 0..<noteRange)
        } while avoidSame && noteIndex2 == noteIndex1
        
        let isTreble = trebleOnly ? true : Bool.random()
        
        let resultNote1 = getNoteBy(index: noteIndex1, isTreble: isTreble)
        let resultNote2 = getNoteBy(index: noteIndex2, isTreble: isTreble)
        let resultImage1 = getNoteImageBy(index: noteIndex1, isTreble: isTreble)
        let resultImage2 = getNoteImageBy(index: noteIndex2, isTreble: isTreble)
        
        return ((resultNote1, resultImage1), (resultNote2, resultImage2))
    }
    
    static func getNoteBy(index: Int, isTreble: Bool) -> Note {
        var octave = isTreble ? trebleStartOctave : bassStartOctave
        let startKey = isTreble ? trebleStartNote : bassStartNote
        
        // Have to offset the index to the start note (aka. C) of the octave.
        octave = octave + (index + startKey.rawValue) / Note.notesPerOctave
        guard let key = Note.Key(rawValue: (startKey.rawValue + index) % Note.notesPerOctave) else {
            print("Error: The key is out of range.")
            return Note()
        }
        
        return Note(octave: octave, key: key)
    }
    
    static func getNoteImageBy(index: Int, isTreble: Bool) -> UIImage {
        guard let resultImage = UIImage(named: (isTreble ? treblePrefix : bassPrefix) + String(index)) else {
            print("Error: Cannot get the image from the provided string.")
            return UIImage()
        }
        
        return resultImage
    }
}
