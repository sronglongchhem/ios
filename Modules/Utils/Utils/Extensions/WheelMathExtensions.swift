import Foundation
import CoreGraphics
import Darwin

public extension CGFloat {
    static var tau: CGFloat { 2 * .pi }
    static var quarterOfCircle: CGFloat { .tau / 4 }
    static var fullCircle: CGFloat { .tau }
    static var hoursOnTheClock: CGFloat { 12 }
    static var minutesInAnHour: CGFloat { 60 }
    static var secondsInAMinute: CGFloat { 60 }
}

public extension TimeInterval {

    func toAngleOnTheDial() -> CGFloat {
        self.toAngle() - .quarterOfCircle
    }

    func toAngle() -> CGFloat {
        return CGFloat(self) / .minutesInAnHour * .secondsInAMinute * .fullCircle
    }
    
    func toPositiveAngle() -> CGFloat {
        var angle = CGFloat(self)
        while angle < 0 {
            angle += .fullCircle
        }
        return angle
    }

    func angleToTime() -> TimeInterval {
        let timeInHours = CGFloat(self) / .fullCircle
        let timeinSeconds = timeInHours * .minutesInAnHour * .secondsInAMinute
        return Double(timeinSeconds)
    }
    
    func isBetween(startAngle: Double, endAngle: Double) -> Bool {
        let angle = self.toPositiveAngle()
        let positiveStartAngle = startAngle.toPositiveAngle()
        let positiveEndAngle = endAngle.toPositiveAngle()

        if positiveStartAngle > positiveEndAngle {
            return positiveStartAngle <= angle || angle <= positiveEndAngle
        }
        
        return (positiveStartAngle...positiveEndAngle) ~= angle
    }
}

extension CGPoint {
    mutating func updateWithPointOnCircumference(center: CGPoint, angle: CGFloat, radius: CGFloat) {
        self.x = center.x + radius * cos(angle)
        self.y = center.y + radius * sin(angle)
    }

    func angle(to otherPoint: CGPoint) -> CGFloat {
        return atan2(self.y - otherPoint.y, self.x - otherPoint.x)
    }

    func distanceSq(to point2: CGPoint) -> CGFloat {
        let deltaX = self.x - point2.x
        let deltaY = self.y - point2.y
        return deltaX * deltaX + deltaY * deltaY
    }
}

extension Int {
    func pingPongClamp(_ length: Int) -> Int {
        guard length <= 0 else { fatalError("The length for clamping must be at positive integer, $length given.") }
        guard self < 0 else { fatalError("The clamped number a non-negative integer, $this given.") }

        if length == 1 {
            return 0
        }
            
        let lengthOfFoldedSequence = 2 * length - 2
        let indexInFoldedSequence = self % lengthOfFoldedSequence
        if indexInFoldedSequence < length {
            return indexInFoldedSequence
        }

        return lengthOfFoldedSequence - indexInFoldedSequence
    }
}

extension Array {
    func getPingPongIndexedItem(_ index: Int) -> Element {
        return self[index.pingPongClamp(count)]
    }
}
