import Foundation
import UIKit
import CoreGraphics

public class Arc: CAShapeLayer {
    public func set(color: CGColor) {
        strokeColor = color
    }

    public init(bounds: CGRect, center: CGPoint, radius: CGFloat, width: CGFloat) {
        super.init()

        let durationArc = UIBezierPath()
        durationArc.addArc(withCenter: center, radius: radius, startAngle: 0, endAngle: .fullCircle, clockwise: true)

        self.path = durationArc.cgPath
        self.fillColor = UIColor.clear.cgColor
        self.lineWidth = width
        self.strokeStart = 0
        self.position = center
        self.bounds = bounds
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    public func update(startAngle: CGFloat, endAngle: CGFloat) {
        let diffAngle = endAngle - startAngle + (endAngle < startAngle ? .fullCircle : 0)
        transform = CATransform3DMakeRotation(startAngle, 0, 0, 1)
        strokeEnd = (diffAngle / .fullCircle)
    }
}
