import Foundation
import UIKit

 public struct TextStyle {
    let style: UIFont.TextStyle
    let size: Int
    let weight: UIFont.Weight
    let letterSpacing: Int
    let lineHeight: Int
    
    init(style: UIFont.TextStyle,
         size: Int,
         weight: UIFont.Weight,
         letterSpacing: Int,
         lineHeight: Int) {
        self.style = style
        self.size = size
        self.weight = weight
        self.letterSpacing = letterSpacing
        self.lineHeight = lineHeight
    }
    
    func font() -> UIFont {
        return UIFontMetrics(forTextStyle: style)
                .scaledFont(for: UIFont.systemFont(ofSize: CGFloat(size), weight: weight))
    }
    
    func paragraphStyle() -> NSParagraphStyle {
        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.lineSpacing = CGFloat(lineHeight - size)
        return paragraphStyle
    }
    
    func stringAttributes() -> [NSAttributedString.Key: Any] {
        return [.font: font()] // will add the paragraph styles when we get proper line heights
    }
}

public struct TextStyles {
    public static let pageTitle = TextStyle(style: .title1, size: 24, weight: .bold, letterSpacing: 0, lineHeight: 0)
    public static let header = TextStyle(style: .headline, size: 15, weight: .heavy, letterSpacing: 0, lineHeight: 0)
    public static let subheader = TextStyle(style: .subheadline, size: 13, weight: .bold, letterSpacing: 0, lineHeight: 0)
    public static let bodySmall = TextStyle(style: .body, size: 15, weight: .medium, letterSpacing: 0, lineHeight: 0)
    public static let bodyLarge = TextStyle(style: .body, size: 17, weight: .medium, letterSpacing: 0, lineHeight: 0)
    public static let ghostText = TextStyle(style: .body, size: 17, weight: .medium, letterSpacing: 0, lineHeight: 0)
    public static let label = TextStyle(style: .callout, size: 12, weight: .medium, letterSpacing: 0, lineHeight: 0)
    public static let pill = TextStyle(style: .callout, size: 15, weight: .medium, letterSpacing: 0, lineHeight: 0)
    public static let project = TextStyle(style: .body, size: 15, weight: .medium, letterSpacing: 0, lineHeight: 0)
    public static let textButton = TextStyle(style: .body, size: 15, weight: .semibold, letterSpacing: 0, lineHeight: 0)
    
    public enum Calendar {
        public static let disabled = TextStyle(style: .body, size: 15, weight: .regular, letterSpacing: 0, lineHeight: 0)
        public static let today = TextStyle(style: .body, size: 15, weight: .semibold, letterSpacing: 0, lineHeight: 0)
        public static let active = TextStyle(style: .body, size: 15, weight: .medium, letterSpacing: 0, lineHeight: 0)
    }
    
    public enum Reports {
        public static let pieChart = TextStyle(style: .callout, size: 10, weight: .semibold, letterSpacing: 0, lineHeight: 0)
        public static let billable = TextStyle(style: .headline, size: 40, weight: .regular, letterSpacing: 0, lineHeight: 0)
        public static let total = TextStyle(style: .headline, size: 34, weight: .regular, letterSpacing: 0, lineHeight: 0)
        public static let amount = TextStyle(style: .subheadline, size: 28, weight: .regular, letterSpacing: 0, lineHeight: 0)
        public static let percent = TextStyle(style: .subheadline, size: 28, weight: .regular, letterSpacing: 0, lineHeight: 0)
    }
    
    public static func style(for description: TextStyleDescription) -> TextStyle {
        switch description {
        case .pageTitle:
            return pageTitle
        case .header:
            return header
        case .subheader:
            return subheader
        case .bodySmall:
            return bodySmall
        case .bodyLarge:
            return bodyLarge
        case .ghostText:
            return ghostText
        case .label:
            return label
        case .pill:
            return pill
        case .project:
            return project
        case .textButton:
            return textButton
        case .calendarDisabled:
            return Calendar.disabled
        case .calendarToday:
            return Calendar.today
        case .calendarActive:
            return Calendar.active
        case .reportsPieChart:
            return Reports.pieChart
        case .reportsBillable:
            return Reports.billable
        case .reportsTotal:
            return Reports.total
        case .reportsAmount:
            return Reports.amount
        case .reportsPercent:
            return Reports.percent
        }
    }
}

public enum TextStyleDescription: String {
    case pageTitle
    case header
    case subheader
    case bodySmall
    case bodyLarge
    case ghostText
    case label
    case pill
    case project
    case textButton
    
    case calendarDisabled
    case calendarToday
    case calendarActive
    
    case reportsPieChart
    case reportsBillable
    case reportsTotal
    case reportsAmount
    case reportsPercent
}
