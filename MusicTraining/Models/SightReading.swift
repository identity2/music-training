import Foundation
import UIKit

class SightReading {
    let answeredNotesKey = "SR_answered_notes"
    let timeSpentKey = "SR_time_spent"
    
    var currNoteImage: UIImage   // Avoid getting the same image twice a row.
    var totalAnsweredNotes: Int
    var totalTimeSpent: Double
    var notePerSec: Double {
        get {
            return totalTimeSpent == 0.0 ? 0.0 : Double(totalAnsweredNotes) / totalTimeSpent
        }
    }
    
    var correctAnswer: Note.Key
    
    init() {
        totalAnsweredNotes = UserDefaults.standard.integer(forKey: answeredNotesKey)
        totalTimeSpent = UserDefaults.standard.double(forKey: timeSpentKey)
        
        // These two are given arbitrarily to avoid the use of optionals.
        currNoteImage = NoteGenerator.getRandomNoteImage().1
        correctAnswer = .A
    }
    
    // Return: The new UIImage for the note.
    func newRound() -> UIImage {
        var newNote: (Note, UIImage)
        
        // Avoid rolling the same image twice a row.
        repeat {
            newNote = NoteGenerator.getRandomNoteImage()
        } while newNote.1 == currNoteImage
        
        correctAnswer = newNote.0.key
        currNoteImage = newNote.1
        
        return currNoteImage
    }
    
    // Return: (isCorrect, The correct answer).
    func userAnswers(answer: Note.Key, timeSpent: TimeInterval) -> (Bool, Note.Key) {
        let correct = (answer == correctAnswer)
        
        totalAnsweredNotes = max(0, totalAnsweredNotes + (correct ? 1 : -1))
        totalTimeSpent += timeSpent
        
        storeData()
        
        return (correct, correctAnswer)
    }
    
    func resetData() {
        totalAnsweredNotes = 0
        totalTimeSpent = 0.0
        
        storeData()
    }
    
    // Stores stats to UserDefaults.
    private func storeData() {
        UserDefaults.standard.set(totalAnsweredNotes, forKey: answeredNotesKey)
        UserDefaults.standard.set(totalTimeSpent, forKey: timeSpentKey)
    }
}
