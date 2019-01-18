import UIKit

class IntervalViewController : UIViewController {
    let showAnswerDuration = TimeInterval(1.0)
    let speakerTintDuration = TimeInterval(1.0)
    let correctRateLabelSuffix = "% Correct Rate"
    
    var intervalTraining = IntervalTraining()
    var tintTimer: Timer? = nil
    var speakerTintTimer: Timer? = nil
    var buttonsEnabled = false
    
    @IBOutlet var intervalPickers: Array<UIButton>!
    @IBOutlet weak var speakerButton: UIButton!
    @IBOutlet weak var correctRateLabel: UILabel!
    @IBOutlet weak var resultImageView: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        updateCorrectRateLabel()
        setUpNewRound()
    }
    
    func setUpNewRound() {
        intervalTraining.newRound()
        buttonsEnabled = true
        resultImageView.isHidden = true
        
        intervalTraining.stopSounds()
        intervalTraining.playSounds()
    }
    
    func correctAnswerShow(index: Int) {
        intervalPickers[index].tintColor = Resources.correctTint
        
        resultImageView.image = Resources.checkImage
        resultImageView.tintColor = Resources.correctTint
        resultImageView.isHidden = false
        
        Resources.correctSound.play()
    }
    
    func wrongAnswerShow(selected: Int, correct: Int) {
        intervalPickers[selected].tintColor = Resources.wrongTint
        intervalPickers[correct].tintColor = Resources.fixedTint
        
        resultImageView.image = Resources.crossImage
        resultImageView.tintColor = Resources.wrongTint
        resultImageView.isHidden = false
        
        Resources.wrongSound.play()
    }
    
    func resetAllColors() {
        for button in intervalPickers {
            button.tintColor = UIColor.black
        }
        speakerButton.tintColor = UIColor.black
    }
    
    func updateCorrectRateLabel() {
        correctRateLabel.text = String(Int(intervalTraining.correctness)) + correctRateLabelSuffix
    }
    
    @IBAction func answerButtonTouched(_ sender: UIButton) {
        if !buttonsEnabled { return }
        
        buttonsEnabled = false
        
        let answerChosen = sender.tag
        let (correct, answer) = intervalTraining.userAnswers(answer: answerChosen)
        
        // Have to subtract by 1 because the index starts from 0 while the tag starts from 1.
        if correct {
            correctAnswerShow(index: sender.tag - 1)
        } else {
            wrongAnswerShow(selected: sender.tag - 1, correct: answer - 1)
        }
        
        updateCorrectRateLabel()
        
        tintTimer = Timer.scheduledTimer(withTimeInterval: showAnswerDuration, repeats: false) { (_) in
            self.resetAllColors()
            self.setUpNewRound()
        }
    }
    
    @IBAction func speakerButtonTouched(_ sender: UIButton) {
        if !buttonsEnabled { return }
        
        speakerButton.isEnabled = false
        
        intervalTraining.stopSounds()
        intervalTraining.playSounds()
        
        speakerButton.tintColor = Resources.speakerTint
        
        speakerTintTimer = Timer.scheduledTimer(withTimeInterval: speakerTintDuration, repeats: false) { (_) in
            self.speakerButton.tintColor = UIColor.black
            self.speakerButton.isEnabled = true
        }
    }
    
    @IBAction func resetButtonTouched(_ sender: UIButton) {
        let alert = UIAlertController(title: "Reset Data", message: "Sure you want to reset the Correct Rate?", preferredStyle: .alert)
        let okButton = UIAlertAction(title: "Sure", style: .destructive, handler: {(action) -> Void in
            self.intervalTraining.resetData()
            self.updateCorrectRateLabel()
            self.setUpNewRound()
        })
        let cancelButton = UIAlertAction(title: "Cancel", style: .cancel)
        alert.addAction(okButton)
        alert.addAction(cancelButton)
        self.present(alert, animated: true, completion: nil)
    }
    
}
