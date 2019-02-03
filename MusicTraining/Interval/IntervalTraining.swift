import Foundation

class IntervalTraining {
    let totalKey = "I_total_count"
    let correctKey = "I_correct_count"
    
    var answeredCount: Int
    var correctCount: Int
    
    var answerIndexPair: (Int, Int)
    var correctness: Double {
        get {
            return answeredCount == 0 ? 0.0 : Double(correctCount) / Double(answeredCount) * 100.0
        }
    }
    
    init() {
        answeredCount = UserDefaults.standard.integer(forKey: totalKey)
        correctCount = UserDefaults.standard.integer(forKey: correctKey)
        
        // Given arbitrarily to avoid the use of optionals.
        answerIndexPair = (0, 1)
    }
    
    func newRound() {
        var newPair: (Int, Int)
        
        // Avoid rolling the same pair twice.
        repeat {
            newPair = AudioNoteForInterval.getRandomIntervalPair()
        } while newPair == answerIndexPair
        
        answerIndexPair = newPair
    }
    
    func playSounds() {
        AudioNoteForInterval.notes[answerIndexPair.0].play()
        AudioNoteForInterval.notes[answerIndexPair.1].play()
    }
    
    func stopSounds() {
        AudioNoteForInterval.notes[answerIndexPair.0].stop()
        AudioNoteForInterval.notes[answerIndexPair.1].stop()
    }
    
    // returns: (isCorrect, the correct answer)
    func userAnswers(answer: Int) -> (Bool, Int) {
        let correctAnswer = answerIndexPair.1 - answerIndexPair.0
        let correct = (correctAnswer == answer)
        
        answeredCount += 1
        if correct {
            correctCount += 1
        }
        
        storeData()
        
        return (correct, correctAnswer)
    }
    
    func resetData() {
        answeredCount = 0
        correctCount = 0
        
        storeData()
    }
    
    func storeData() {
        UserDefaults.standard.set(answeredCount, forKey: totalKey)
        UserDefaults.standard.set(correctCount, forKey: correctKey)
    }
}
