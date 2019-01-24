import UIKit

class SightSingingViewController : UIViewController, AudioPollerDelegate {
    @IBOutlet weak var noteImageView: UIImageView!
    @IBOutlet weak var micButton: UIButton!
    
    let micDisableDuration = 1.25
    
    var poller = AudioPoller()
    
    override func viewDidLoad() {
        poller.delegate = self

        super.viewDidLoad()
    }
    
    func audioPolled(note: Note?) {
        if let n = note {
            print(n.key, n.sharp ? "#" : "")
        } else {
            print("Not Polled")
        }
        
        micButton.tintColor = UIColor.black
        micButton.isEnabled = true
    }
    
    @IBAction func microphoneTouched(_ sender: UIButton) {
        micButton.isEnabled = false
        micButton.tintColor = Resources.recordingTint
        poller.start()
    }
    
    @IBAction func resetButtonTouched(_ sender: UIButton) {
    }
    
    @IBAction func middleASpeakerTouched(_ sender: UIButton) {
    }
}
