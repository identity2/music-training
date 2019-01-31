import Foundation

class ChordProgression {
    let totalKey = "CP_total_count"
    let correctKey = "CP_correct_count"
    
    let sequenceLength = 5
    let chordIndexRange = 1...7
    
    var answeredCount: Int
    var correctCount: Int
    
    var answerSequence = [Int]()
    
    var correctness: Double {
        get {
            return answeredCount == 0 ? 0.0 : Double(correctCount) / Double(answeredCount) * 100.0
        }
    }
    
    init() {
        answeredCount = UserDefaults.standard.integer(forKey: totalKey)
        correctCount = UserDefaults.standard.integer(forKey: correctKey)
    }
    
    func newRound() {
        answerSequence.removeAll()
        
        // Generate random sequence.
        for _ in 0..<sequenceLength {
            answerSequence.append(Int.random(in: chordIndexRange))
        }
    }
    
    // returns: (isCorrect, the wrong slots)
    func userAnswers(answer: [Int]) -> (Bool, Set<Int>) {
        var wrongSlots = Set<Int>()
        
        for index in 0..<answerSequence.count {
            if answerSequence[index] != answer[index] {
                wrongSlots.insert(index)
            }
        }
        
        let correct = wrongSlots.isEmpty
        
        answeredCount += 1
        if correct {
            correctCount += 1
        }
        
        storeData()
        
        return (correct, wrongSlots)
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
