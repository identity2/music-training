import AVFoundation
import UIKit

class SoundPlayer {
    var player: AVAudioPlayer!
    
    init(named soundName: String) {
        guard let soundAsset = NSDataAsset(name: soundName) else {
            fatalError("Error loading sound.")
        }
        
        do {
            try AVAudioSession.sharedInstance().setCategory(AVAudioSession.Category.playback, mode: .default, options: .duckOthers)
            try AVAudioSession.sharedInstance().setActive(true)
            
            player = try AVAudioPlayer(data: soundAsset.data, fileTypeHint: AVFileType.wav.rawValue)
            player.prepareToPlay()
        } catch let error {
            print(error.localizedDescription)
        }
    }
    
    func play() {
        player.play()
    }
}
