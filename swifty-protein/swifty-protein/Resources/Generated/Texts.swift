// swiftlint:disable all
// Generated using SwiftGen — https://github.com/SwiftGen/SwiftGen

import Foundation

// swiftlint:disable superfluous_disable_command file_length implicit_return

// MARK: - Strings

// swiftlint:disable explicit_type_interface function_parameter_count identifier_name line_length
// swiftlint:disable nesting type_body_length type_name vertical_whitespace_opening_braces
internal enum Text {
  /// Swifty Protein
  internal static let appTitle = Text.tr("Localizable", "AppTitle")

  internal enum Common {
    /// Backward
    internal static let backward = Text.tr("Localizable", "Common.backward")
    /// Cancel
    internal static let cancel = Text.tr("Localizable", "Common.cancel")
    /// Confirm
    internal static let confirm = Text.tr("Localizable", "Common.confirm")
    /// Confirm Save?
    internal static let confirmSave = Text.tr("Localizable", "Common.confirmSave")
    /// Create Password
    internal static let createPassword = Text.tr("Localizable", "Common.createPassword")
    /// Hello
    internal static let hello = Text.tr("Localizable", "Common.hello")
    /// Passwords Not Equal
    internal static let passwordsNotEqual = Text.tr("Localizable", "Common.passwordsNotEqual")
    /// Repeat Password
    internal static let repeatPassword = Text.tr("Localizable", "Common.repeatPassword")
    /// Save
    internal static let save = Text.tr("Localizable", "Common.save")
    /// Input answer
    internal static let typeAnswerPlaceholder = Text.tr("Localizable", "Common.typeAnswerPlaceholder")
    /// Where were you born?
    internal static let whereWereYouBorn = Text.tr("Localizable", "Common.whereWereYouBorn")
  }
}
// swiftlint:enable explicit_type_interface function_parameter_count identifier_name line_length
// swiftlint:enable nesting type_body_length type_name vertical_whitespace_opening_braces

// MARK: - Implementation Details

extension Text {
  private static func tr(_ table: String, _ key: String, _ args: CVarArg...) -> String {
    let format = BundleToken.bundle.localizedString(forKey: key, value: nil, table: table)
    return String(format: format, locale: Locale.current, arguments: args)
  }
}

// swiftlint:disable convenience_type
private final class BundleToken {
  static let bundle: Bundle = {
    #if SWIFT_PACKAGE
    return Bundle.module
    #else
    return Bundle(for: BundleToken.self)
    #endif
  }()
}
// swiftlint:enable convenience_type
