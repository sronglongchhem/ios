import Foundation

public struct Strings {
    
    public static func entriesDeleted(_ numberOfEntriesDeleted: Int) -> String {
        let format = "entriesDeleted".localized
        return String.localizedStringWithFormat(format, numberOfEntriesDeleted)
    }
    
    public static var undo: String { "undo".localized }
    
    public static var billable: String { "billable".localized }
    
    public struct TabBar {
        public static var timer: String { "timer".localized }
        public static var reports: String { "reports".localized }
        public static var calendar: String { "calendar".localized }
    }
}
