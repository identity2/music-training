import UIKit

class TMMetronomeAnimationView: UIView {
    let dotsImageView = UIImageView(image: UIImage(named: "metronome_dots"))
    
    let rodView = UIView()
    let rodImageView = UIImageView(image: UIImage(named: "metronome_rod"))
    let eyesImageView = UIImageView(image: UIImage(named: "metronome_rod_eyes"))
    let mouthImageView = UIImageView()
    
    let mouthOpenImage = UIImage(named: "metronome_rod_mouth_opened")
    let mouthClosedImage = UIImage(named: "metronome_rod_mouth_closed")
    
    let rotationAngle = 27.0 * Double.pi / 180.0
    
    let rodAnchorY = CGFloat(0.945)
    let rodPositionYProportionToViewHeight = CGFloat(0.99)
    let rodHeightProportionToViewHeight = CGFloat(1.0068)
    let rodAspectRatio = CGFloat(0.15941)
    let eyesMovementXProportionToRodWidth = CGFloat(0.03)
    
    var soundPlayer: SoundPlayer!
    
    let rodSoundPlayer = SoundPlayer(named: "metronome_sound")
    let rockSoundPlayer = SoundPlayer(named: "metronome_sound_rock")
    
    let timerTickInterval = 0.01
    let mouthOpenDuration = 0.1
    
    var currBPM = 1
    
    weak var timer: Timer?
    var angularVelocity = 0.0
    var sign = 0.0
    var prevTime = 0.0
    
    var isRodSound = true
    
    var added = false
    var defaultAnchor = CGPoint(x: 0.5, y: 0.5)
    
    weak var mouthOpenTimer: Timer?
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        soundPlayer = rodSoundPlayer
    }
    
    // MARK: Function.
    func startMetronome(bpm: Int) {
        sign = -1.0
        rodView.layer.setAffineTransform(makeAffineTransform(by: rotationAngle))
        
        updateBPM(bpm)
        
        playSoundAndMouthAnimation()
        
        prevTime = Date().timeIntervalSinceReferenceDate
        timer = Timer.scheduledTimer(timeInterval: timerTickInterval, target: self, selector: #selector(TMMetronomeAnimationView.timerTick), userInfo: nil, repeats: true)
    }
    
    func switchSound() {
        soundPlayer = isRodSound ? rockSoundPlayer : rodSoundPlayer
        isRodSound = !isRodSound
    }
    
    func stopMetronome() {
        if let t = timer {
            t.invalidate()
        }
    }
    
    func updateBPM(_ bpm: Int) {
        currBPM = bpm
        angularVelocity = rotationAngle / 30.0 * Double(currBPM)
    }
    
    func positionSubviews() {
        // Dots.
        dotsImageView.frame.size = frame.size
        dotsImageView.frame.origin = CGPoint.zero
        if !added { addSubview(dotsImageView) }
        
        // Rod View.
        let rodHeight = frame.height * rodHeightProportionToViewHeight
        let rodWidth = rodAspectRatio * rodHeight
        
        let currAngle = Double(rodView.layer.affineTransform().rotation())
        rodView.layer.setAffineTransform(.identity)
        rodView.layer.anchorPoint = defaultAnchor
        rodView.frame.size = CGSize(width: rodWidth, height: rodHeight)
        rodView.layer.anchorPoint = CGPoint(x: CGFloat(0.5), y: rodAnchorY)
        rodView.layer.position = CGPoint(x: frame.width * CGFloat(0.5), y: frame.height * rodPositionYProportionToViewHeight)
        if !added {
            addSubview(rodView)
            rodView.layer.setAffineTransform(makeAffineTransform(by: rotationAngle))
        } else {
            rodView.layer.setAffineTransform(makeAffineTransform(by: currAngle))
        }
        
        // Rod Images.
        rodImageView.frame.size = CGSize(width: rodWidth, height: rodHeight)
        eyesImageView.frame.size = CGSize(width: rodWidth, height: rodHeight)
        mouthImageView.frame.size = CGSize(width: rodWidth, height: rodHeight)
        mouthImageView.image = mouthClosedImage
        eyesImageView.layer.position.x = rodImageView.frame.width * CGFloat(0.5)
        
        if !added {
            rodView.addSubview(rodImageView)
            rodView.addSubview(eyesImageView)
            rodView.addSubview(mouthImageView)
            
            added = true
        }
    }
    
    private func makeAffineTransform(by radians: Double) -> CGAffineTransform {
        return CGAffineTransform.identity.rotated(by: -CGFloat(radians))
    }
    
    @objc private func timerTick() {
        let currTime = Date().timeIntervalSinceReferenceDate
        let deltaTime = currTime - prevTime
        prevTime = currTime
        
        let currAngle = Double(rodView.layer.affineTransform().rotation())
        var newAngle = sign * angularVelocity * deltaTime + currAngle
        
        // Check if reaches the edge.
        if abs(newAngle) > rotationAngle {
            newAngle = sign * 2.0 * rotationAngle - newAngle
            sign = -sign
            
            playSoundAndMouthAnimation()
        }
        
        eyesImageView.layer.position.x = rodImageView.frame.width / CGFloat(2) + CGFloat(-newAngle / rotationAngle) * rodView.frame.width * eyesMovementXProportionToRodWidth
        rodView.layer.setAffineTransform(makeAffineTransform(by: newAngle))
    }
    
    private func playSoundAndMouthAnimation() {
        soundPlayer.play()
        
        mouthImageView.image = mouthOpenImage
        
        mouthOpenTimer = Timer.scheduledTimer(timeInterval: mouthOpenDuration, target: self, selector: #selector(TMMetronomeAnimationView.closeMouth), userInfo: nil, repeats: false)
    }
    
    @objc private func closeMouth() {
        mouthImageView.image = mouthClosedImage
    }
}

