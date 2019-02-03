class AudioNoteForInterval {
    static let intervalMaxRange = 12
    static let notes = [
        SoundPlayer(named: "C2"), SoundPlayer(named: "C#2"), SoundPlayer(named: "D2"), SoundPlayer(named: "D#2"),
        SoundPlayer(named: "E2"), SoundPlayer(named: "F2"), SoundPlayer(named: "F#2"), SoundPlayer(named: "G2"),
        SoundPlayer(named: "G#2"), SoundPlayer(named: "A2"), SoundPlayer(named: "A#2"), SoundPlayer(named: "B2"),
        SoundPlayer(named: "C3"), SoundPlayer(named: "C#3"), SoundPlayer(named: "D3"), SoundPlayer(named: "D#3"),
        SoundPlayer(named: "E3"), SoundPlayer(named: "F3"), SoundPlayer(named: "F#3"), SoundPlayer(named: "G3"),
        SoundPlayer(named: "G#3"), SoundPlayer(named: "A3"), SoundPlayer(named: "A#3"), SoundPlayer(named: "B3"),
    ]
    
    static func getRandomIntervalPair() -> (Int, Int) {
        let first = Int.random(in: 0..<intervalMaxRange)
        let second = first + Int.random(in: 1...intervalMaxRange)
        return (first, second)
    }
}
