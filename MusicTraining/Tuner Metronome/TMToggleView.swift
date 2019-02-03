import UIKit

class TMToggleView: UIButton, CAAnimationDelegate {
    let knobImageView = UIImageView(image: UIImage(named: "toggle_knob"))
    let knobAspectRatio = CGFloat(1.18)
    let knobHeightProportionToViewHeight = CGFloat(0.65)
    let knobLeadingMarginProportionToViewWidth = CGFloat(0.085)
    
    let slideAnimationDuration = 0.4
    
    var inLeft = true
    
    var leftPosition = CGPoint()
    var rightPosition = CGPoint()
    
    var animating = false
    
    var added = false
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        if animating { return }
        
        animating = true
        knobImageView.layer.add(makeSlideAnimation(), forKey: "position")
        inLeft = !inLeft
        knobImageView.layer.position = inLeft ? leftPosition : rightPosition
        sendActions(for: .valueChanged)
    }
    
    // MARK: Functions.
    func positionSubviews() {
        isUserInteractionEnabled = true
        knobImageView.frame.size.height = frame.height * knobHeightProportionToViewHeight
        knobImageView.frame.size.width = knobImageView.frame.height * knobAspectRatio
        
        let leftFrameOrigin = CGPoint(x: frame.width * knobLeadingMarginProportionToViewWidth, y: (frame.height - knobImageView.frame.height) * 0.5)
        let rightFrameOrigin = CGPoint(x: frame.width * (CGFloat(1) - knobLeadingMarginProportionToViewWidth) - knobImageView.frame.width, y: leftFrameOrigin.y)
        knobImageView.frame.origin = leftFrameOrigin
        
        leftPosition = knobImageView.layer.position
        rightPosition = CGPoint(x: rightFrameOrigin.x + leftPosition.x - leftFrameOrigin.x, y: leftPosition.y)
        
        if !added { addSubview(knobImageView) }
        
        added = true
    }
    
    private func makeSlideAnimation() -> CABasicAnimation {
        let animation = CABasicAnimation(keyPath: "position")
        animation.fromValue = NSValue(cgPoint: (inLeft ? leftPosition : rightPosition))
        animation.toValue = NSValue(cgPoint: (inLeft ? rightPosition : leftPosition))
        animation.duration = slideAnimationDuration
        animation.timingFunction = CAMediaTimingFunction(name: CAMediaTimingFunctionName.easeInEaseOut)
        animation.delegate = self
        return animation
    }
    
    // MARK: CAAnimation Delegate.
    func animationDidStop(_ anim: CAAnimation, finished flag: Bool) {
        animating = false
    }
}
