import Foundation

class ChordProgressionPlayer {
    let chordPlayers = [
        nil,
        SoundPlayer(named: "I_audio"),
        SoundPlayer(named: "II_audio"),
        SoundPlayer(named: "III_audio"),
        SoundPlayer(named: "IV_audio"),
        SoundPlayer(named: "V_audio"),
        SoundPlayer(named: "VI_audio"),
        SoundPlayer(named: "VII_audio")
    ]
    
    let noteDuration = TimeInterval(1)
    
    var delegate: ProgressionPlayerDelegate?
    var timer: Timer?
    var currIndex = 0
    var currPlayer: SoundPlayer?
    var progression = [Int]()
    
    func play(_ progression: [Int]) {
        self.progression = progression
        currIndex = 0
        
        timer = Timer.scheduledTimer(withTimeInterval: noteDuration, repeats: true, block: {_ in
            self.playNote()
        })
    }
    
    func playNote() {
        
        if currIndex < progression.count {
            let index = progression[currIndex]
            currPlayer = chordPlayers[index]
            currPlayer!.play()
        }
        
        currIndex += 1
        // Tick one more time so that the last note have time to finish.
        if currIndex == progression.count + 1 {
            stop()
        }
    }
    
    func stop() {
        if let d = delegate {
            d.progressionFinishedPlaying()
        }
        
        if let t = timer {
            t.invalidate()
        }
        
        if let player = currPlayer {
            player.stop()
            currPlayer = nil
        }
    }
}

protocol ProgressionPlayerDelegate {
    func progressionFinishedPlaying()
}
