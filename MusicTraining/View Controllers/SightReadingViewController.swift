import UIKit

class SightReadingViewController : UIViewController {
    // MARK: Constants.
    let showAnswerDuration = TimeInterval(0.7)
    let npsLabelSuffix = " note/sec."
    
    // Mark: Variables.
    var sightReading = SightReading()
    var timestamp = 0.0
    var tintTimer: Timer? = nil
    var buttonsEnabled = false
    
    
    // MARK: Views.
    @IBOutlet var notePickers: Array<UIButton>!
    @IBOutlet weak var noteImageView: UIImageView!
    @IBOutlet weak var notePerSecLabel: UILabel!
    @IBOutlet weak var resultImageView: UIImageView!
    
    
    // MARK: Functions.
    override func viewDidLoad() {
        super.viewDidLoad()
        
        NotificationCenter.default.addObserver(self, selector: #selector(willEnterForeground(_:)), name: UIApplication.willEnterForegroundNotification, object: nil)
        updateNotePerSecLabel()
        setUpNewRound()
    }
    
    // Start a new round when the app is interrupted and resumes.
    @objc func willEnterForeground(_ notification: NSNotification!) {
        setUpNewRound()
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
    
    func setUpNewRound() {
        noteImageView.image = sightReading.newRound()
        timestamp = Date().timeIntervalSince1970
        buttonsEnabled = true
        resultImageView.image = nil
        
        Resources.nextSound.play()
    }
    
    func correctAnswerShow(index: Int) {
        notePickers[index].tintColor = Resources.correctTint
        
        resultImageView.image = Resources.checkImage
        resultImageView.tintColor = Resources.correctTint
        
        Resources.correctSound.play()
    }
    
    func wrongAnswerShow(selected: Int, correct: Int) {
        notePickers[selected].tintColor = Resources.wrongTint
        notePickers[correct].tintColor = Resources.fixedTint
        
        resultImageView.image = Resources.crossImage
        resultImageView.tintColor = Resources.wrongTint
        
        Resources.wrongSound.play()
    }
    
    func resetAllColors() {
        for button in notePickers {
            button.tintColor = UIColor.black
        }
    }
    
    func updateNotePerSecLabel() {
        notePerSecLabel.text = String(format: "%.2f", sightReading.notePerSec) + npsLabelSuffix
    }
    
    @IBAction func answerButtonTouched(_ sender: UIButton) {
        if !buttonsEnabled { return }
        
        buttonsEnabled = false
        
        let notePressed = Note.Key(rawValue: sender.tag)!
        let deltaTime = Date().timeIntervalSince1970 - timestamp
        
        let (correct, answer) = sightReading.userAnswers(answer: notePressed, timeSpent: deltaTime)
        
        // Show the correct answer.
        if correct {
            correctAnswerShow(index: sender.tag)
        } else {
            wrongAnswerShow(selected: sender.tag, correct: answer.rawValue)
        }
        
        updateNotePerSecLabel()
        
        tintTimer = Timer.scheduledTimer(withTimeInterval: showAnswerDuration, repeats: false) { (_) in
            self.resetAllColors()
            self.setUpNewRound()
        }
    }
    
    @IBAction func resetNotesPerSecTouched(_ sender: UIButton) {
        // Show confirmation panel.
        let alert = UIAlertController(title: "Reset Data", message: "Sure you want to reset your (note/sec.) score to zero?", preferredStyle: .alert)
        let okButton = UIAlertAction(title: "Sure", style: .destructive, handler: { (action) -> Void in
            self.sightReading.resetData()
            self.updateNotePerSecLabel()
            self.setUpNewRound()
        })
        let cancelButton = UIAlertAction(title: "Cancel", style: .cancel)
        alert.addAction(okButton)
        alert.addAction(cancelButton)
        self.present(alert, animated: true, completion: nil)
    }
}
