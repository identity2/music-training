import AudioKit

class AudioPoller {
    static let noteToDetect = Array((0...8).map { octave -> [Note] in
        Note.middleOctave.map { note -> Note in
            Note(octave: octave, key: note.key, sharp: note.sharp)
        }
    }).joined()
    
    let mic: AKMicrophone
    let tracker: AKFrequencyTracker
    let silence: AKBooster
    
    let totalPollingCount = 60     // 60 * 0.0125 = 0.75
    let pollingInterval = 0.0125
    let successRatio = 0.3
    
    let deltaTolerance = 50.0
    
    var noteSungCount: [Note:Int] = [:]
    var delegate: AudioPollerDelegate?
    var pollingCount = 0
    var pollingTimer: Timer?
    
    init() {
        do {
            try AVAudioSession.sharedInstance().setCategory(AVAudioSession.Category.playAndRecord, mode: AVAudioSession.Mode.measurement, options: [])
            try AVAudioSession.sharedInstance().overrideOutputAudioPort(AVAudioSession.PortOverride.speaker)
        } catch let error {
            print(error.localizedDescription)
        }
        
        AKSettings.audioInputEnabled = true
        mic = AKMicrophone()
        tracker = AKFrequencyTracker.init(mic)
        silence = AKBooster(tracker, gain: 0)
        
        AudioKit.output = silence
        
        do {
            try AudioKit.start()
        } catch let error {
            print(error.localizedDescription)
        }
    }
    
    deinit {
        do {
            try AudioKit.stop()
        } catch let error {
            print(error.localizedDescription)
        }
        
        stop()
    }
    
    func start() {
        noteSungCount.removeAll()
        pollingCount = 0
        pollingTimer = Timer.scheduledTimer(withTimeInterval: pollingInterval, repeats: true, block: {_ in
            self.pollingTick()
        })
    }
    
    func stop() {
        if let t = pollingTimer {
            t.invalidate()
        }
    }
    
    static func nearestNote(of frequency: Double) -> Note {
        var minNote = noteToDetect.first!
        for note in noteToDetect {
            if abs(note.frequency - frequency) < abs(minNote.frequency - frequency) {
                minNote = note
            }
        }
        
        return minNote
    }
    
    private func pollingTick() {
        let frequency = tracker.frequency
        let note = AudioPoller.nearestNote(of: frequency)
        let delta = Double(24 * 50) * log(frequency / note.frequency) / log(2.0)
        
        if abs(delta) < deltaTolerance {
            noteSungCount[note] = (noteSungCount[note] ?? 0) + 1
        }
        
        pollingCount += 1
        
        if pollingCount == totalPollingCount {
            stop()
            
            if let d = delegate {
                let maxNote = noteSungCount.max(by: {$0.value < $1.value})
                if maxNote != nil && maxNote!.value >= Int(totalPollingCount * successRatio) {
                    d.audioPolled(note: maxNote!.key)
                } else {
                    d.audioPolled(note: nil)
                }
            }
        }
    }
}

protocol AudioPollerDelegate {
    func audioPolled(note: Note?)
}
