import UIKit

class SightSinging {
    let answeredKey = "SS_answered_notes"
    let correctKey = "SS_correct_notes"
    let sampleNote = SoundPlayer(named: "A3")
    let avoidNote = Note.Key.A
    
    var totalAnsweredNotes: Int
    var correctNoteCount: Int
    
    var correctRate: Double {
        get {
            return totalAnsweredNotes == 0 ? 0.0 : Double(correctNoteCount) / Double(totalAnsweredNotes) * 100.0
        }
    }
    
    var correctAnswer: Note.Key
    
    init() {
        totalAnsweredNotes = UserDefaults.standard.integer(forKey: answeredKey)
        correctNoteCount = UserDefaults.standard.integer(forKey: correctKey)
        
        // These are given arbitrarily to avoid the use of optionals.
        correctAnswer = .A
    }
    
    func playSampleNote() {
        sampleNote.play()
    }
    
    // Return: The new UIImage for the note.
    func newRound() -> UIImage {
        var newNote: (Note, UIImage)
        
        // Avoid rolling the same image twice in a row, or rolling the sample key.
        repeat {
            newNote = NoteGenerator.getRandomNoteImage(trebleOnly: true)
        } while newNote.0.key == correctAnswer || newNote.0.key == avoidNote
        
        correctAnswer = newNote.0.key
        
        return newNote.1
    }
    
    // Return: isCorrect.
    func userAnswers(answer: Note.Key) -> Bool {
        let correct = (answer == correctAnswer)
        
        totalAnsweredNotes += 1
        if correct {
            correctNoteCount += 1
        }
        
        storeData()
        
        return correct
    }
    
    func resetData() {
        totalAnsweredNotes = 0
        correctNoteCount = 0
        
        storeData()
    }
    
    // Stores stats to UserDefaults.
    func storeData() {
        UserDefaults.standard.set(totalAnsweredNotes, forKey: answeredKey)
        UserDefaults.standard.set(correctNoteCount, forKey: correctKey)
    }
}
