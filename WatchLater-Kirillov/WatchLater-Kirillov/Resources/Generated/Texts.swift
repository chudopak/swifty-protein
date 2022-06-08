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
    /// Поля должны быть заполнены
    internal static let fieldsMustBeFilled = Text.tr("Localizable", "Authorization.fieldsMustBeFilled")
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

  internal enum BaseError {
    /// Bad result.
    internal static let badResult = Text.tr("Localizable", "BaseError.badResult")
    /// Cancel task.
    internal static let cancelled = Text.tr("Localizable", "BaseError.cancelled")
    /// Failed to build request.
    internal static let failedToBuildRequest = Text.tr("Localizable", "BaseError.failedToBuildRequest")
    /// Can not download image.
    internal static let imageLoadingError = Text.tr("Localizable", "BaseError.imageLoadingError")
    /// There is no data in response.
    internal static let noData = Text.tr("Localizable", "BaseError.noData")
    /// No response provided in request.
    internal static let noResponse = Text.tr("Localizable", "BaseError.noResponse")
    /// Response in 400's range.
    internal static let range400Response = Text.tr("Localizable", "BaseError.range400Response")
    /// Can not decode data to needed type.
    internal static let unableToDecodeData = Text.tr("Localizable", "BaseError.unableToDecodeData")
    /// Unowned Response Code.
    internal static let unownedResponseCode = Text.tr("Localizable", "BaseError.unownedResponseCode")
  }

  internal enum Common {
    /// О фильме
    internal static let aboutMovie = Text.tr("Localizable", "Common.aboutMovie")
    /// О себе
    internal static let aboutYourself = Text.tr("Localizable", "Common.aboutYourself")
    /// Отмена
    internal static let cancel = Text.tr("Localizable", "Common.cancel")
    /// Закрыть
    internal static let close = Text.tr("Localizable", "Common.close")
    /// Готово
    internal static let done = Text.tr("Localizable", "Common.done")
    /// Любимые жанры
    internal static let favoriteGenres = Text.tr("Localizable", "Common.favoriteGenres")
    /// Библиотека
    internal static let library = Text.tr("Localizable", "Common.library")
    /// Войти
    internal static let login = Text.tr("Localizable", "Common.login")
    /// Выйти
    internal static let logout = Text.tr("Localizable", "Common.logout")
    /// Имя
    internal static let name = Text.tr("Localizable", "Common.name")
    /// Далее
    internal static let next = Text.tr("Localizable", "Common.next")
    /// Нет
    internal static let no = Text.tr("Localizable", "Common.no")
    /// Нет любимых жанров
    internal static let noFavoriteGenres = Text.tr("Localizable", "Common.noFavoriteGenres")
    /// Фото отсутствует
    internal static let noImage = Text.tr("Localizable", "Common.noImage")
    /// Нет Постера
    internal static let noPoster = Text.tr("Localizable", "Common.noPoster")
    /// Удалить
    internal static let remove = Text.tr("Localizable", "Common.remove")
    /// Сохранить
    internal static let save = Text.tr("Localizable", "Common.save")
    /// Сохранено
    internal static let saved = Text.tr("Localizable", "Common.saved")
    /// Сделать фото
    internal static let takeAPicture = Text.tr("Localizable", "Common.takeAPicture")
    /// Обновить
    internal static let update = Text.tr("Localizable", "Common.update")
    /// Загрузить фото
    internal static let uploadPhoto = Text.tr("Localizable", "Common.uploadPhoto")
    /// Просмотрено
    internal static let viewed = Text.tr("Localizable", "Common.viewed")
    /// Буду смотреть
    internal static let willWatch = Text.tr("Localizable", "Common.willWatch")
    /// Да
    internal static let yes = Text.tr("Localizable", "Common.yes")
  }

  internal enum Fillings {
    /// -
    internal static let noData = Text.tr("Localizable", "Fillings.noData")
    /// unowned
    internal static let `unowned` = Text.tr("Localizable", "Fillings.unowned")
  }

  internal enum SearchScreen {
    /// Коллекция
    internal static let collection = Text.tr("Localizable", "SearchScreen.collection")
    /// Введите Название
    internal static let enterFilm = Text.tr("Localizable", "SearchScreen.enterFilm")
    /// IMDB
    internal static let imdb = Text.tr("Localizable", "SearchScreen.imdb")
    /// Начните вводить название, и здесь появятся варианты фильмов
    internal static let startTypingLabelText = Text.tr("Localizable", "SearchScreen.startTypingLabelText")
  }

  internal enum TabBar {
    /// Добавить
    internal static let add = Text.tr("Localizable", "TabBar.add")
    /// Коллекция
    internal static let collection = Text.tr("Localizable", "TabBar.collection")
    /// Профиль
    internal static let profile = Text.tr("Localizable", "TabBar.profile")
    /// Поиск
    internal static let search = Text.tr("Localizable", "TabBar.search")
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
