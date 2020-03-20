import Foundation

public struct ErrorType: Equatable, CustomStringConvertible {
    public static func == (lhs: ErrorType, rhs: ErrorType) -> Bool {
        lhs.error.localizedDescription == rhs.error.localizedDescription
    }
    
    let error: Error
    
    public var description: String {
        return error.localizedDescription
    }
}

public extension Error {
    func toErrorType() -> ErrorType {
        return ErrorType(error: self)
    }
}
