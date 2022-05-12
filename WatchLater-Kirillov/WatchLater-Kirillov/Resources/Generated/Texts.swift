// swiftlint:disable all
// Generated using SwiftGen — https://github.com/SwiftGen/SwiftGen

import Foundation

// swiftlint:disable superfluous_disable_command file_length implicit_return

// MARK: - Strings

// swiftlint:disable explicit_type_interface function_parameter_count identifier_name line_length
// swiftlint:disable nesting type_body_length type_name vertical_whitespace_opening_braces
internal enum Text {

  internal enum Authorization {
    /// Неверные логин или пароль
    internal static let failed = Text.tr("Localizable", "Authorization.failed")
    /// Пароли не совпадают
    internal static let passwordsNotMatch = Text.tr("Localizable", "Authorization.passwordsNotMatch")
    /// Регистрация
    internal static let registration = Text.tr("Localizable", "Authorization.registration")
    /// Еще не зарегистрированы?
    internal static let registrationQuestion = Text.tr("Localizable", "Authorization.registrationQuestion")
    /// Что-то пошло не так
    internal static let somethingWentWrong = Text.tr("Localizable", "Authorization.somethingWentWrong")
    internal enum Placeholder {
      /// Адрес электронной почты
      internal static let email = Text.tr("Localizable", "Authorization.placeholder.email")
      /// Пароль
      internal static let password = Text.tr("Localizable", "Authorization.placeholder.password")
      /// Повторите пароль
      internal static let repeatPassword = Text.tr("Localizable", "Authorization.placeholder.repeatPassword")
    }
  }

  internal enum Common {
    /// Отмена
    internal static let cancel = Text.tr("Localizable", "Common.cancel")
    /// Закрыть
    internal static let close = Text.tr("Localizable", "Common.close")
    /// Сохранить
    internal static let dave = Text.tr("Localizable", "Common.dave")
    /// Готово
    internal static let done = Text.tr("Localizable", "Common.done")
    /// Войти
    internal static let login = Text.tr("Localizable", "Common.login")
    /// Выйти
    internal static let logout = Text.tr("Localizable", "Common.logout")
    /// Далее
    internal static let next = Text.tr("Localizable", "Common.next")
    /// Нет
    internal static let no = Text.tr("Localizable", "Common.no")
    /// Удалить
    internal static let remove = Text.tr("Localizable", "Common.remove")
    /// Обновить
    internal static let update = Text.tr("Localizable", "Common.update")
    /// Да
    internal static let yes = Text.tr("Localizable", "Common.yes")
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
