enum StateUtils {
    static func loaded() -> String {
        "Loaded"
    }
    
    static func prepared() -> String {
        "Prepared"
    }
    
    static let loadErrorPrefix = "Load error"
    
    static func loadError(_ error: String) -> String {
        "\(loadErrorPrefix): \(error)"
    }
    
    static func loadError(_ error: Error) -> String {
        loadError("\(error)")
    }
}
