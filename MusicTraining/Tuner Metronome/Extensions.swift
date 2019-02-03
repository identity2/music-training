import UIKit

extension CGAffineTransform {
    func rotation() -> CGFloat {
        return atan2(c, a)
    }
}

extension CGSize {
    static func *(lhs: CGSize, rhs: CGFloat) -> CGSize {
        return CGSize(width: lhs.width * rhs, height: lhs.height * rhs)
    }
    
    static func *=(lhs: inout CGSize, rhs: CGFloat) {
        lhs = lhs * rhs
    }
}
