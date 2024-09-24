import Foundation

extension Date {
    var display: String {
        DateFormatter.localizedString(from: self, dateStyle: .short,timeStyle: .medium)
    }
}
