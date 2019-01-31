import UIKit
import AVFoundation

class MenuViewController : ViewControllerWithAdMob {
    override func viewDidLoad() {
        do {
            try AVAudioSession.sharedInstance().setCategory(AVAudioSession.Category.playAndRecord, mode: AVAudioSession.Mode.measurement, options: [])
            try AVAudioSession.sharedInstance().overrideOutputAudioPort(AVAudioSession.PortOverride.speaker)
        } catch let error {
            print(error.localizedDescription)
        }
        
        super.viewDidLoad()
    }
    
    @IBAction func unwindToMenu(unwindSegue: UIStoryboardSegue) {
    }
}
