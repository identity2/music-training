import UIKit

class TMTunerView: UIView, TunerDelegate {
    let tolerance = 7.0
    let arrowLerpSmooth = 3.0
    
    let tuner = TMTuner()
    
    let backgroundImageView = UIImageView(image: UIImage(named: "tuner_background"))
    let arrowImageView = UIImageView(image: UIImage(named: "tuner_arrow"))
    let headImageView = UIImageView()
    let eyesImageView = UIImageView(image: UIImage(named: "tuner_eyes"))
    let noteImageView = UIImageView()
    let markImageView = UIImageView()
    
    let defaultAnchor = CGPoint(x: 0.5, y: 0.5)
    
    let headRegular = UIImage(named: "tuner_head")
    let headCorrect = UIImage(named: "tuner_head_correct")
    let headFlat = UIImage(named: "tuner_head_flat")
    let headSharp = UIImage(named: "tuner_head_sharp")
    
    let headAnchorPoint = CGPoint(x: 0.5, y: 1.0)
    let headHeightProportionalToViewHeight = CGFloat(0.2849)
    let headAspectRatio = CGFloat(1.2017)
    
    let eyesPositionZ = CGFloat(1.0) // Be in the front of the head.
    let eyesPositionXLimitProportionalToWidth = CGFloat(0.015)
    
    let arrowAnchorPoint = CGPoint(x: 0.4956, y: 0.7865)
    let arrowHeightProportionalToViewHeight = CGFloat(0.451)
    let arrowAspectRatio = CGFloat(0.41849)
    let arrowPositionYProportionalToViewHeight = CGFloat(0.7315)
    let arrowPositionZ = CGFloat(-0.1)   // Be in the back of the head.
    
    let noteHeightProportionalToViewHeight = CGFloat(0.27)
    let noteAspectRatio = CGFloat(0.66765)
    let notePositionYProportionalToViewHeight = CGFloat(0.1936)
    let notePositionXProportionalToViewWidth = CGFloat(0.4944)
    
    let markHeightProportionalToViewHeight = CGFloat(0.1498)
    let markAspectRatio = CGFloat(0.66756)
    let markPositionYProportionalToViewHeight = CGFloat(0.1003)
    let markPositionXProportionalToViewWidth = CGFloat(0.6398)
    
    var added = false
    
    func positionSubviews() {
        backgroundImageView.frame.size = frame.size
        
        headImageView.layer.anchorPoint = defaultAnchor
        headImageView.frame.size.height = headHeightProportionalToViewHeight * frame.height
        headImageView.frame.size.width = headImageView.frame.height * headAspectRatio
        headImageView.layer.anchorPoint = headAnchorPoint
        headImageView.layer.position = CGPoint(x: frame.width * CGFloat(0.5), y: frame.height)
        
        eyesImageView.layer.anchorPoint = defaultAnchor
        eyesImageView.frame.size = headImageView.frame.size
        eyesImageView.layer.anchorPoint = headAnchorPoint
        eyesImageView.layer.position = headImageView.layer.position
        eyesImageView.layer.zPosition = eyesPositionZ
        
        arrowImageView.layer.setAffineTransform(.identity)
        arrowImageView.layer.anchorPoint = defaultAnchor
        arrowImageView.frame.size.height = frame.height * arrowHeightProportionalToViewHeight
        arrowImageView.frame.size.width = arrowImageView.frame.height * arrowAspectRatio
        arrowImageView.layer.anchorPoint = arrowAnchorPoint
        arrowImageView.layer.zPosition = arrowPositionZ
        arrowImageView.layer.position = CGPoint(x: frame.width * CGFloat(0.5), y: arrowPositionYProportionalToViewHeight * frame.height)
        
        noteImageView.layer.anchorPoint = defaultAnchor
        noteImageView.frame.size.height = frame.height * noteHeightProportionalToViewHeight
        noteImageView.frame.size.width = noteImageView.frame.height * noteAspectRatio
        noteImageView.layer.position.x = frame.width * notePositionXProportionalToViewWidth
        noteImageView.layer.position.y = frame.height * notePositionYProportionalToViewHeight
        
        markImageView.layer.anchorPoint = defaultAnchor
        markImageView.frame.size.height = frame.height * markHeightProportionalToViewHeight
        markImageView.frame.size.width = markImageView.frame.height * markAspectRatio
        markImageView.layer.position.x = frame.width * markPositionXProportionalToViewWidth
        markImageView.layer.position.y = frame.height * markPositionYProportionalToViewHeight
        
        if !added {
            addSubview(backgroundImageView)
            addSubview(headImageView)
            addSubview(eyesImageView)
            addSubview(arrowImageView)
            addSubview(noteImageView)
            addSubview(markImageView)
            
            added = true
        }
                
        tuner.delegate = self
    }
    
    func startTuner() {
        tuner.start()
        
        eyesImageView.layer.position = headImageView.layer.position
        arrowImageView.layer.setAffineTransform(CGAffineTransform.identity)
        noteImageView.image = TMDigitNoteImages.notes[0]
        markImageView.image = nil
    }
    
    func stopTuner() {
        tuner.stop()
    }
    
    // MARK: Tuner Delegate.
    func tunerDidTick(pitch: TMPitch, delta: Double) {
        noteImageView.image = TMDigitNoteImages.notes[pitch.note.note.rawValue]
        markImageView.image = TMDigitNoteImages.accidental[pitch.note.accidental.rawValue]
        
        var affineTransform = CGAffineTransform.identity
        var eyePositionX = headImageView.layer.position.x
        
        if abs(delta) < tolerance {
            headImageView.image = headCorrect
        } else {
            headImageView.image = delta > 0 ? headSharp : headFlat
            affineTransform = affineTransform.rotated(by: CGFloat(delta * Double.pi) / 180.0)
            eyePositionX += eyesImageView.frame.size.width * eyesPositionXLimitProportionalToWidth * CGFloat(delta) / CGFloat(tuner.totalTickCount)
        }
        
        arrowImageView.layer.setAffineTransform(affineTransform)
        eyesImageView.layer.position.x = eyePositionX
    }
}
