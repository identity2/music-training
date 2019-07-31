import UIKit

class TMSmallScreenView: UIView {
    let digitImageViews = [UIImageView(), UIImageView(), UIImageView()]
    let digitAspectRatio = CGFloat(0.6675)
    let digitHeightProportionToViewHeight = CGFloat(0.75)
    
    let fastChangingStep = 5
    
    let maxTempo = 300
    let minTempo = 30
    
    var currTempo = 80
    
    var added = false
    
    // MARK: Functions.
    func positionSubviews() {
        setUpDigitImageSize()
        recalculateHorizontalPositioning()
        setDigitsToImageViews()
        
        added = true
    }
    
    func changeValue(positive: Bool, fastChanging: Bool = false) {
        let originalTempo = currTempo
        let value = fastChanging ? fastChangingStep : 1
        
        currTempo += positive ? value : -value
        
        currTempo = min(max(currTempo, minTempo), maxTempo)
        
        // 2 digit -> 3 digit or 3 digit -> 2 digit.
        if currTempo >= 100 && originalTempo < 100 || currTempo < 100 && originalTempo >= 100 {
            recalculateHorizontalPositioning()
        }
        
        setDigitsToImageViews()
    }
    
    func setValue(value: Int) {
        let originalTempo = currTempo
        currTempo = value
        
        // 2 digit -> 3 digit or 3 digit -> 2 digit.
        if currTempo >= 100 && originalTempo < 100 || currTempo < 100 && originalTempo >= 100 {
            recalculateHorizontalPositioning()
        }
        
        setDigitsToImageViews()
    }
    
    private func setUpDigitImageSize() {
        let height = frame.height * digitHeightProportionToViewHeight
        let width = height * digitAspectRatio
        
        for imageView in digitImageViews {
            imageView.frame.size = CGSize(width: width, height: height)
            if !added { addSubview(imageView) }
        }
    }
    
    private func recalculateHorizontalPositioning() {
        // Hard code the positions for 2 digit number and 3 digit number. Will be clearer, faster and less brain consuming.
        let digitWidth = digitImageViews[0].frame.width
        let originY = (frame.height - digitImageViews[0].frame.height) / CGFloat(2)
        
        if currTempo < 100 {
            // 2 digits.
            let baseOriginX = frame.width / CGFloat(2) - digitWidth
            for i in 1..<3 {
                digitImageViews[i].frame.origin = CGPoint(x: baseOriginX + digitWidth * CGFloat(i - 1), y: originY)
            }
            digitImageViews[0].isHidden = true
        } else {
            // 3 digits.
            let baseOriginX = frame.width / CGFloat(2) - CGFloat(1.5) * digitWidth
            for i in 0..<3 {
                digitImageViews[i].frame.origin = CGPoint(x: baseOriginX + digitWidth * CGFloat(i), y: originY)
            }
            digitImageViews[0].isHidden = false
        }
    }
    
    private func setDigitsToImageViews() {
        var num = currTempo
        var index = digitImageViews.count - 1
        while num != 0 {
            digitImageViews[index].image = TMDigitNoteImages.digits[num % 10]
            num /= 10
            index -= 1
        }
    }
}

