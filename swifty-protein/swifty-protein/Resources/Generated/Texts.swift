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
    /// Compare
    internal static let compare = Text.tr("Localizable", "Common.compare")
    /// Confirm
    internal static let confirm = Text.tr("Localizable", "Common.confirm")
    /// Confirmation
    internal static let confirmation = Text.tr("Localizable", "Common.confirmation")
    /// Confirm Save?
    internal static let confirmSave = Text.tr("Localizable", "Common.confirmSave")
    /// Create Password
    internal static let createPassword = Text.tr("Localizable", "Common.createPassword")
    /// Error
    internal static let error = Text.tr("Localizable", "Common.error")
    /// Hello
    internal static let hello = Text.tr("Localizable", "Common.hello")
    /// Input Password
    internal static let inputPassword = Text.tr("Localizable", "Common.inputPassword")
    /// Passwords Not Equal
    internal static let passwordsNotEqual = Text.tr("Localizable", "Common.passwordsNotEqual")
    /// Repeat Password
    internal static let repeatPassword = Text.tr("Localizable", "Common.repeatPassword")
    /// Restore password
    internal static let restorePassword = Text.tr("Localizable", "Common.restorePassword")
    /// Save
    internal static let save = Text.tr("Localizable", "Common.save")
    /// Success
    internal static let success = Text.tr("Localizable", "Common.success")
    /// Input answer
    internal static let typeAnswerPlaceholder = Text.tr("Localizable", "Common.typeAnswerPlaceholder")
  }

  internal enum Descriptions {
    /// Biometry is not avalable
    internal static let biometryUnavalable = Text.tr("Localizable", "Descriptions.biometryUnavalable")
    /// Are you sure? Write answer somewere or you will need to download app again :)
    internal static let confirmAnswer = Text.tr("Localizable", "Descriptions.confirmAnswer")
    /// There MUST be an answer
    internal static let emptyAnswer = Text.tr("Localizable", "Descriptions.emptyAnswer")
    /// Authenticate with Touch ID.
    internal static let loginWithTouchID = Text.tr("Localizable", "Descriptions.loginWithTouchID")
    /// Answer to long. It will be hard to remember.
    internal static let longAnswer = Text.tr("Localizable", "Descriptions.longAnswer")
    /// Password successfully changed.
    internal static let passwordChangd = Text.tr("Localizable", "Descriptions.passwordChangd")
    /// Save error. Try again.
    internal static let saveDataError = Text.tr("Localizable", "Descriptions.saveDataError")
    /// You have successfully registered!
    internal static let successRegistration = Text.tr("Localizable", "Descriptions.successRegistration")
    /// Some unexpected error happened.
    internal static let unexpectedError = Text.tr("Localizable", "Descriptions.unexpectedError")
    /// Wrong answer.
    internal static let wrongAnswer = Text.tr("Localizable", "Descriptions.wrongAnswer")
    /// Incorrect password.
    internal static let wrongPassword = Text.tr("Localizable", "Descriptions.wrongPassword")
  }

  internal enum Questions {
    /// Where were you born?
    internal static let whereWereYouBorn = Text.tr("Localizable", "Questions.whereWereYouBorn")
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
