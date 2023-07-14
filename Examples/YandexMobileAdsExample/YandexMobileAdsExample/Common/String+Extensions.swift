import Foundation

extension String {
    func camelCaseToWords() -> String {
        map { ($0.isUppercase ? " " : "") + String($0) }
            .joined(separator: "")
            .trimmingCharacters(in: .whitespaces)
            .localizedCapitalized
    }
}
