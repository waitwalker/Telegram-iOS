import Foundation

@propertyWrapper
public struct NGStorage<T: Codable> {
    private let key: String
    private let defaultValue: T

    public init(key: String, defaultValue: T) {
        self.key = "ng:" + key
        self.defaultValue = defaultValue
    }

    public var wrappedValue: T {
        get {
            // Read value from UserDefaults
            guard let data = UserDefaults.standard.object(forKey: key) as? Data else {
                // Return defaultValue when no data in UserDefaults
                return defaultValue
            }

            // Convert data to the desire data type
            let value = try? JSONDecoder().decode(T.self, from: data)
            return value ?? defaultValue
        }
        set {
            // Convert newValue to data
            let data = try? JSONEncoder().encode(newValue)
            
            // Set value to UserDefaults
            UserDefaults.standard.set(data, forKey: key)
        }
    }
}

public struct NGSettings {
    // MARK: Premium
    @NGStorage(key: "premium", defaultValue: false)
    public static var premium: Bool
    
    @NGStorage(key: "oneTapTr", defaultValue: true)
    public static var oneTapTr: Bool
    
    @NGStorage(key: "oneTapTrButtonLowPowerMode", defaultValue: false)
    public static var oneTapTrButtonLowPowerMode: Bool
    
    @NGStorage(key: "ignoreTranslate", defaultValue: [])
    public static var ignoreTranslate: [String]
    
    // MARK: App Settings
    @NGStorage(key: "showContactsTab", defaultValue: true)
    public static var showContactsTab: Bool
    
    @NGStorage(key: "sendWithEnter", defaultValue: false)
    public static var sendWithEnter: Bool
    
    @NGStorage(key: "hidePhoneSettings", defaultValue: false)
    public static var hidePhoneSettings: Bool
    
    @NGStorage(key: "useRearCamTelescopy", defaultValue: false)
    public static var useRearCamTelescopy: Bool
    
    @NGStorage(key: "hideNotifyAccount", defaultValue: false)
    public static var hideNotifyAccount: Bool
    
    @NGStorage(key: "fixNotifications", defaultValue: false)
    public static var fixNotifications: Bool
    
    @NGStorage(key: "showTabNames", defaultValue: true)
    public static var showTabNames: Bool
    
    @NGStorage(key: "classicProfileUI", defaultValue: false)
    public static var classicProfileUI: Bool
    
    @NGStorage(key: "showGmodIcon", defaultValue: true)
    public static var showGmodIcon: Bool
    
    
}

public struct NGWebSettings {
    // MARK: Remote Settings
    @NGStorage(key: "syncPins", defaultValue: false)
    static var syncPins: Bool
    
    @NGStorage(key: "restricted", defaultValue: [])
    static var resticted: [Int64]
    
    @NGStorage(key: "RR", defaultValue: [])
    static var RR: [String]
    
    @NGStorage(key: "allowed", defaultValue: [])
    static var allowed: [Int64]
      
}


public func isPremium() -> Bool {    
    let bb = (Bundle.main.infoDictionary?[kCFBundleVersionKey as String] ?? "") as! String
    if bb.last != "1" {
        return false
    }
    
    return NGSettings.premium
}

public func usetrButton() -> [(Bool, [String])] {
    if isPremium() {
        var ignoredLangs = NGSettings.ignoreTranslate
        if !NGSettings.ignoreTranslate.isEmpty && ProcessInfo.processInfo.isLowPowerModeEnabled && !NGSettings.oneTapTrButtonLowPowerMode {
            ignoredLangs = []
        }
        return [(NGSettings.oneTapTr, ignoredLangs)]
    }
    return [(false, [])]
}
