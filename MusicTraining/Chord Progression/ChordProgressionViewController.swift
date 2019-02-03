import UIKit

class ChordProgressionViewController : ViewControllerWithAdMob, ProgressionPlayerDelegate {
    let showAnswerDuration = TimeInterval(1.5)
    let correctRateLabelSuffix = "% Correct Rate"
    
    let blankImages = [
        UIImage(named: "blank"),
        UIImage(named: "I_blank"),
        UIImage(named: "II_blank"),
        UIImage(named: "III_blank"),
        UIImage(named: "IV_blank"),
        UIImage(named: "V_blank"),
        UIImage(named: "VI_blank"),
        UIImage(named: "VII_blank")
    ]
    
    var chordProgression = ChordProgression()
    var progressionPlayer = ChordProgressionPlayer()
    var answerSequence = [Int]()
    var tintTimer: Timer? = nil
    var speakerTintTimer: Timer? = nil
    var buttonsEnabled = false
    
    @IBOutlet var answerButtons: Array<UIButton>!
    @IBOutlet var blanks: Array<UIImageView>!
    @IBOutlet weak var speakerButton: UIButton!
    @IBOutlet weak var correctRateLabel: UILabel!
    @IBOutlet weak var resultImageView: UIImageView!
    @IBOutlet weak var enterButton: UIButton!
    @IBOutlet weak var deleteButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        progressionPlayer.delegate = self
        
        setUpNewRound()
    }
    
    func setUpNewRound() {
        enterButton.isEnabled = false
        deleteButton.isEnabled = false
        
        resetAllColors()
        
        setAnswerButtonsEnabled(true)
        answerSequence.removeAll()
        updateBlanks()
        
        chordProgression.newRound()
        buttonsEnabled = true
        resultImageView.isHidden = true
        
        playChordProgression()
    }
    
    func playChordProgression() {
        speakerButton.tintColor = Resources.speakerTint
        speakerButton.isEnabled = false
        progressionPlayer.play(chordProgression.answerSequence)
    }
    
    func answeredCorrectly() {
        for blank in blanks {
            blank.tintColor = Resources.correctTint
        }
        
        resultImageView.image = Resources.checkImage
        resultImageView.tintColor = Resources.correctTint
        resultImageView.isHidden = false
        
        Resources.correctSound.play()
    }
    
    func showWrongAnswer(wrongSlots: Set<Int>) {
        for index in 0..<blanks.count {
            if wrongSlots.contains(index) {
                blanks[index].tintColor = Resources.wrongTint
            } else {
                blanks[index].tintColor = Resources.correctTint
            }
        }
        
        resultImageView.image = Resources.crossImage
        resultImageView.tintColor = Resources.wrongTint
        resultImageView.isHidden = false
        
        Resources.wrongSound.play()
    }
    
    func updateBlanks() {
        let length = answerSequence.count
        for index in 0..<length {
            blanks[index].image = blankImages[answerSequence[index]]
        }
        
        // Set the others to blank.
        for index in length..<blanks.count {
            blanks[index].image = blankImages[0]
        }
    }
    
    func setAnswerButtonsEnabled(_ enabled: Bool) {
        for button in answerButtons {
            button.isEnabled = enabled
        }
    }
    
    func resetAllColors() {
        for blank in blanks {
            blank.tintColor = UIColor.black
        }
    }
    
    func updateCorrectRateLabel() {
        correctRateLabel.text = String(Int(chordProgression.correctness)) + correctRateLabelSuffix
    }
    
    // This will be called by progression player using delegation.
    func progressionFinishedPlaying() {
        speakerButton.tintColor = UIColor.black
        speakerButton.isEnabled = true
    }
    
    @IBAction func answerButtonTouched(_ sender: UIButton) {
        if !buttonsEnabled { return }
        
        let index = sender.tag
        
        answerSequence.append(index)
        updateBlanks()

        deleteButton.isEnabled = true
        
        if answerSequence.count == blanks.count {
            setAnswerButtonsEnabled(false)
            enterButton.isEnabled = true
        }
    }
    
    @IBAction func deleteButtonTouched(_ sender: UIButton) {
        if !buttonsEnabled { return }
        
        answerSequence.removeLast()
        updateBlanks()
        
        setAnswerButtonsEnabled(true)
        enterButton.isEnabled = false
        
        if answerSequence.isEmpty {
            deleteButton.isEnabled = false
        }
    }
    
    @IBAction func enterButtonTouched(_ sender: UIButton) {
        if !buttonsEnabled { return }
        
        enterButton.isEnabled = false
        deleteButton.isEnabled = false
        buttonsEnabled = false
        
        progressionPlayer.stop()
        
        let (correct, wrongSlots) = chordProgression.userAnswers(answer: answerSequence)
        
        if correct {
            answeredCorrectly()
        } else {
            showWrongAnswer(wrongSlots: wrongSlots)
        }
        
        updateCorrectRateLabel()
        
        tintTimer = Timer.scheduledTimer(withTimeInterval: showAnswerDuration, repeats: false) { (_) in
            self.resetAllColors()
            self.setUpNewRound()
        }
    }
    
    @IBAction func speakerButtonTouched(_ sender: UIButton) {
        if !buttonsEnabled { return }
        
        playChordProgression()
    }
    
    @IBAction func resetButtonTouched(_ sender: UIButton) {
        let alert = UIAlertController(title: "Reset Data", message: "Sure you want to reset the Correct Rate?", preferredStyle: .alert)
        let okButton = UIAlertAction(title: "Sure", style: .destructive, handler: {(action) -> Void in
            self.chordProgression.resetData()
            self.updateCorrectRateLabel()
            self.setUpNewRound()
        })
        let cancelButton = UIAlertAction(title: "Cancel", style: .cancel)
        alert.addAction(okButton)
        alert.addAction(cancelButton)
        self.present(alert, animated: true, completion: nil)
    }
    
    @IBAction func backButtonTouched(_ sender: UIButton) {
        progressionPlayer.stop()
    }
}
