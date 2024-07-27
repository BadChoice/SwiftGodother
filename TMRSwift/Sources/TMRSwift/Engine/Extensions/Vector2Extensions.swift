import SwiftGodot

extension Vector2 {
    init(stringLiteral value: StringLiteralType) {
        let values = value.replacingOccurrences(of: ",", with: "").components(separatedBy: " ")
        let x = Float(Double(values[0].trimmingCharacters(in: .whitespacesAndNewlines)) ?? 0)
        let y = Float(Double(values[1].trimmingCharacters(in: .whitespacesAndNewlines)) ?? 0)
        self.init(x:x, y:y)
    }
}
