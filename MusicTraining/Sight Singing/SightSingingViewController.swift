import UIKit

class SightSingingViewController : ViewControllerWithAdMob, AudioPollerDelegate {
    let showAnswerDuration = TimeInterval(0.5)
    let correctRateLabelSuffix = "% Correct Rate"
    let sampleNoteCooldown = TimeInterval(1.0)
    
    var sightSinging = SightSinging()
    var poller = AudioPoller()
    var tintTimer: Timer?
    var sampleNoteTimer: Timer?
    
    @IBOutlet weak var noteImageView: UIImageView!
    @IBOutlet weak var micButton: UIButton!
    @IBOutlet weak var correctRateLabel: UILabel!
    @IBOutlet weak var resultImageView: UIImageView!
    @IBOutlet weak var tapAndSingText: UIImageView!
    @IBOutlet weak var speakerButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        poller.delegate = self
                
        updateCorrectRateLabel()
        setUpNewRound()
        
        if !sightSinging.dontShowPopUp {
            showPopUpTips()
        }
    }
    
    func showPopUpTips() {
        let alert = UIAlertController(title: "Tips", message: "You can sing the note in any octaves.", preferredStyle: .alert)
        let okButton = UIAlertAction(title: "Don't Show this Again", style: .default, handler: { (action) -> Void in
            self.sightSinging.dontShowPopUpAgain()
        })
        let cancelButton = UIAlertAction(title: "Got it", style: .cancel)
        alert.addAction(okButton)
        alert.addAction(cancelButton)
        self.present(alert, animated: true, completion: nil)
    }
    
    func setUpNewRound() {
        noteImageView.image = sightSinging.newRound()
        micButton.isEnabled = true
        resultImageView.image = nil
        tapAndSingText.isHidden = false
        
        Resources.nextSound.play()
    }
    
    func checkAnswer(correct: Bool) {
        if correct {
            resultImageView.tintColor = Resources.correctTint
            resultImageView.image = Resources.checkImage
            
            Resources.correctSound.play()
        } else {
            resultImageView.tintColor = Resources.wrongTint
            resultImageView.image = Resources.crossImage
            
            Resources.wrongSound.play()
        }
        
        updateCorrectRateLabel()
        
        tintTimer = Timer.scheduledTimer(withTimeInterval: showAnswerDuration, repeats: false) { (_) in
            self.setUpNewRound()
        }
    }
    
    func updateCorrectRateLabel() {
        correctRateLabel.text = "\(Int(sightSinging.correctRate))" + correctRateLabelSuffix
    }
    
    // Audio Poller Delegate.
    func audioPolled(note: Note?) {
        micButton.tintColor = UIColor.black
        tapAndSingText.isHidden = true
        
        var correct = false
        
        if let n = note {
            correct = sightSinging.userAnswers(answer: n.key)
        }
        
        checkAnswer(correct: correct)
    }
    
    @IBAction func microphoneTouched(_ sender: UIButton) {
        // If is playing sample.
        if !speakerButton.isEnabled { return }
        
        micButton.isEnabled = false
        micButton.tintColor = Resources.recordingTint
        
        poller.start()
        
        // audioPolled(note:) will be called when the polling is completed.
    }
    
    @IBAction func resetButtonTouched(_ sender: UIButton) {
        let alert = UIAlertController(title: "Reset Data", message: "Sure you want to reset your Correct Rate?", preferredStyle: .alert)
        let okButton = UIAlertAction(title: "Sure", style: .destructive, handler: { (action) -> Void in
            self.sightSinging.resetData()
            self.updateCorrectRateLabel()
        })
        
        let cancelButton = UIAlertAction(title: "Cancel", style: .cancel)
        alert.addAction(okButton)
        alert.addAction(cancelButton)
        self.present(alert, animated: true, completion: nil)
    }
    
    @IBAction func middleASpeakerTouched(_ sender: UIButton) {
        sightSinging.playSampleNote()
        
        speakerButton.isEnabled = false
        sampleNoteTimer = Timer.scheduledTimer(withTimeInterval: sampleNoteCooldown, repeats: false) { (_) in
            self.speakerButton.isEnabled = true
        }
    }
}
