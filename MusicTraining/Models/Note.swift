class Note: Equatable {
    static let notesPerOctave = 7
    
    enum Key: Int {case C = 0, D, E, F, G, A, B}
    
    var octave: Int   // 4 is the middle octave.
    var key: Key
    
    init(octave: Int = 4, key: Key = Key.A) {
        self.octave = octave
        self.key = key
    }
    
    static func ==(lhs: Note, rhs: Note) -> Bool {
        return lhs.octave == rhs.octave && lhs.octave == rhs.octave
    }
}
