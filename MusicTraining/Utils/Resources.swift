import UIKit

class Resources {
    static let correctTint = UIColor.green
    static let wrongTint = UIColor.red
    static let fixedTint = UIColor.init(red: CGFloat(0.22), green: CGFloat(0.57), blue: CGFloat(0.22), alpha: CGFloat(1.0))
    static let speakerTint = UIColor.blue
    
    static let checkImage = UIImage(named: "Check")
    static let crossImage = UIImage(named: "Cross")
    
    static let correctSound = SoundPlayer(named: "correct")
    static let wrongSound = SoundPlayer(named: "wrong")
    static let nextSound = SoundPlayer(named: "next")
}
