import UIKit

extension UIColor {
    
    public convenience init(hex: String) {
        var cString: String = hex.trimmingCharacters(in: .whitespacesAndNewlines).uppercased()
        
        if cString.hasPrefix("#") {
            cString.remove(at: cString.startIndex)
        }
        
        if (cString.count) != 6 {
            fatalError("Color string must be 6 chars long")
        }
        
        var rgbValue: UInt64 = 0
        Scanner(string: cString).scanHexInt64(&rgbValue)
                
        self.init(
            red: CGFloat((rgbValue & 0xFF0000) >> 16) / 255.0,
            green: CGFloat((rgbValue & 0x00FF00) >> 8) / 255.0,
            blue: CGFloat(rgbValue & 0x0000FF) / 255.0,
            alpha: CGFloat(1.0)
        )
    }
    
    public static var rainbowColors: [UIColor] = [
        UIColor(hex: "F1F2F3"),
        UIColor(hex: "DFC3E6"),
        UIColor(hex: "CA99D7"),
        UIColor(hex: "8799E5"),
        UIColor(hex: "5168C5"),
        UIColor(hex: "55BBDF"),
        UIColor(hex: "95D0E5"),
        UIColor(hex: "BFDBD7"),
        UIColor(hex: "7FC5BC"),
        UIColor(hex: "E5F0BA"),
        UIColor(hex: "F8DAB8"),
        UIColor(hex: "F0D06C"),
        UIColor(hex: "EFBA7A"),
        UIColor(hex: "F1ACAE")
    ]
}
