import Foundation

enum Accidental: Int {
    case natural = 0
    case sharp = 1
    case flat = 2
}

class TMNote: Equatable {
    enum Accidental: Int { case natural = 0, sharp, flat }
    enum Name: Int { case a = 0, b, c, d, e, f, g }
    
    static let all: [TMNote] = [
        TMNote(.c, .natural), TMNote(.c, .sharp),
        TMNote(.d, .natural),
        TMNote(.e, .flat), TMNote(.e, .natural),
        TMNote(.f, .natural), TMNote(.f, .sharp),
        TMNote(.g, .natural),
        TMNote(.a, .flat), TMNote(.a, .natural),
        TMNote(.b, .flat), TMNote(.b, .natural)
    ]
    
    var note: Name
    var accidental: Accidental
    
    var frequency: Double {
        let index = TMNote.all.firstIndex(of: self)! - TMNote.all.firstIndex(of: TMNote(.a, .natural))!
        return 440.0 * pow(2.0, Double(index) / 12.0)
    }
    
    init(_ note: Name, _ accidental: Accidental) {
        self.note = note
        self.accidental = accidental
    }
    
    static func ==(lhs: TMNote, rhs: TMNote) -> Bool {
        return lhs.note == rhs.note && lhs.accidental == rhs.accidental
    }
    
    static func !=(lhs: TMNote, rhs: TMNote) -> Bool {
        return !(lhs == rhs)
    }
}
