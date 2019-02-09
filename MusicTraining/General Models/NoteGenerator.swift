import UIKit

enum NoteType: Int { case treble = 0, bass, mixed }

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
    static func getRandomNoteImage(type: NoteType = .mixed) -> (Note, UIImage) {
        let noteIndex = Int.random(in: 0..<noteRange)
        
        // Ranomize if "mixed".
        var newType: NoteType
        if type == .mixed {
            newType = Bool.random() ? .treble : .bass
        } else {
            newType = type
        }

        let resultNote = getNoteBy(index: noteIndex, type: newType)
        let resultImage = getNoteImageBy(index: noteIndex, type: newType)
        
        return (resultNote, resultImage)
    }
    
    // Get two random note-image pair from the same octave.
    static func getTwoRandomNoteImage(avoidSame: Bool, type: NoteType) -> ((Note, UIImage), (Note, UIImage)) {
        let noteIndex1 = Int.random(in: 0..<noteRange)
        var noteIndex2: Int
        
        // If avoidSame is true, loop until the indices are different.
        repeat {
            noteIndex2 = Int.random(in: 0..<noteRange)
        } while avoidSame && noteIndex2 == noteIndex1
        
        // Ranomize if "mixed".
        var newType: NoteType
        if type == .mixed {
            newType = Bool.random() ? .treble : .bass
        } else {
            newType = type
        }
        
        let resultNote1 = getNoteBy(index: noteIndex1, type: newType)
        let resultNote2 = getNoteBy(index: noteIndex2, type: newType)
        let resultImage1 = getNoteImageBy(index: noteIndex1, type: newType)
        let resultImage2 = getNoteImageBy(index: noteIndex2, type: newType)
        
        return ((resultNote1, resultImage1), (resultNote2, resultImage2))
    }
    
    static func getNoteBy(index: Int, type: NoteType) -> Note {
        guard type != .mixed else {
            print("Type cannot be mixed when calling getNoteBy(index:type:).")
            return Note()
        }
        
        var octave = (type == .treble ? trebleStartOctave : bassStartOctave)
        let startKey = (type == .treble ? trebleStartNote : bassStartNote)
        
        // Have to offset the index to the start note (aka. C) of the octave.
        octave = octave + (index + startKey.rawValue) / Note.notesPerOctave
        guard let key = Note.Key(rawValue: (startKey.rawValue + index) % Note.notesPerOctave) else {
            print("Error: The key is out of range.")
            return Note()
        }
        
        return Note(octave: octave, key: key)
    }
    
    static func getNoteImageBy(index: Int, type: NoteType) -> UIImage {
        guard type != .mixed else {
            print("Type cannot be mixed when calling getNoteImageBy(index:type:).")
            return UIImage()
        }
        
        guard let resultImage = UIImage(named: (type == .treble ? treblePrefix : bassPrefix) + String(index)) else {
            print("Error: Cannot get the image from the provided string.")
            return UIImage()
        }
        
        return resultImage
    }
}
