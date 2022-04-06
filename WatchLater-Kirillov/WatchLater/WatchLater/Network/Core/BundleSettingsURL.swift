//
//  BundleSettingsURL.swift
//  StartProject-ios
//
//  Created by Rustam Nurgaliev on 23.05.2021.
//  Copyright © 2021 TEKHNOKRATIYA. All rights reserved.
//

import Foundation

private enum Constants {
    static let emptyURL = URL(fileURLWithPath: "")
}

public protocol BaseURL {
    var url: URL { get }
}

class BundleSettingsURL: BaseURL {

    /// Keys from Root.plist in SettingsBundle
    private enum SettingsKeys {
        static let isManualInputEnabled = "settings_is_manual_input_enabled"
        static let baseURLManual = "settings_base_url_manual"
        static let baseURLFromList = "settings_base_url_from_list"
    }

    private let defaultURL: URL

    init(defaultURL: URL) {
        self.defaultURL = defaultURL
    }

    init(defaultURLString: String) {
        self.defaultURL = URL(string: defaultURLString) ?? Constants.emptyURL
    }

    var url: URL {
        let defaults = UserDefaults.standard
        let isManualInputEnabled = defaults.bool(forKey: SettingsKeys.isManualInputEnabled)
        let baseURLManual = defaults.string(forKey: SettingsKeys.baseURLManual) ?? ""
        let baseURLFromList = defaults.string(forKey: SettingsKeys.baseURLFromList) ?? ""

        if isManualInputEnabled {
            return URL(string: baseURLManual) ?? Constants.emptyURL
        }

        if baseURLFromList.isEmpty == false {
            let urlFromList = NetworkConfiguration.Environment(rawValue: baseURLFromList)?.address ?? Constants.emptyURL.absoluteString
            return URL(string: urlFromList) ?? Constants.emptyURL
        }

        return self.defaultURL
    }
}
