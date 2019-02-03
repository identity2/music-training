import Foundation

class TMPitch {
    let note: TMNote
    let octave: Int
    let frequency: Double
    
    static let all = Array((0...8).map { octave -> [TMPitch] in
        TMNote.all.map { note -> TMPitch in
            TMPitch(note: note, octave: octave)
        }
    }).joined()
    
    static func makePitchByFrequency(_ frequency: Double) -> TMPitch {
        var results = all.map { pitch -> (pitch: TMPitch, distance: Double) in
            (pitch: pitch, distance: abs(pitch.frequency - frequency))
        }
        
        results.sort { $0.distance < $1.distance }
        
        return results.first!.pitch
    }
    
    private init(note: TMNote, octave: Int) {
        self.note = note
        self.octave = octave
        self.frequency = note.frequency * pow(2.0, Double(octave) - 4.0)
    }
}
