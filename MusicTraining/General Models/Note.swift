import Foundation

class Note: Equatable, Hashable {
    static let notesPerOctave = 7
    
    enum Key: Int {case C = 0, D, E, F, G, A, B}
    
    static let middleOctave: [Note] = [
        Note(octave: 3, key: .C, sharp: false),
        Note(octave: 3, key: .C, sharp: true),
        Note(octave: 3, key: .D, sharp: false),
        Note(octave: 3, key: .D, sharp: true),
        Note(octave: 3, key: .E, sharp: false),
        Note(octave: 3, key: .F, sharp: false),
        Note(octave: 3, key: .F, sharp: true),
        Note(octave: 3, key: .G, sharp: false),
        Note(octave: 3, key: .G, sharp: true),
        Note(octave: 3, key: .A, sharp: false),
        Note(octave: 3, key: .A, sharp: true),
        Note(octave: 3, key: .B, sharp: false)
    ]
    
    var octave: Int   // 4 is the middle octave.
    var key: Key
    var sharp: Bool
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(key)
        hasher.combine(sharp)
        hasher.combine(octave)
    }
    
    var frequency: Double {
        let multiplier = self.octave - 3
        let index = Note.middleOctave.firstIndex(of: Note(octave: 3, key: self.key, sharp: self.sharp))! - Note.middleOctave.firstIndex(of: Note(octave: 3, key: .A, sharp: false))!
        return 440.0 * pow(2.0, Double(index) / 12.0) * pow(2.0, Double(multiplier))
    }
    
    init(octave: Int = 4, key: Key = Key.A, sharp: Bool = false) {
        self.octave = octave
        self.key = key
        self.sharp = sharp
    }
    
    static func ==(lhs: Note, rhs: Note) -> Bool {
        return lhs.octave == rhs.octave && lhs.key == rhs.key && lhs.sharp == rhs.sharp
    }
}
