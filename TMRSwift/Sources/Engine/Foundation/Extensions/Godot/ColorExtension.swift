import SwiftGodot

extension Color : ExpressibleByStringLiteral {
    public init(stringLiteral value: StringLiteralType) {
        self.init(code: value)
    }
}

