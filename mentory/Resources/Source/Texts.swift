// swiftlint:disable all
// Generated using SwiftGen — https://github.com/SwiftGen/SwiftGen

import Foundation

// swiftlint:disable superfluous_disable_command
// swiftlint:disable file_length

// MARK: - Strings

// swiftlint:disable explicit_type_interface function_parameter_count identifier_name line_length
// swiftlint:disable nesting type_body_length type_name
public enum Text {

  public enum Alert {
    /// Отмена
    public static let cancel = Text.tr("Localizable", "Alert.Cancel")
    /// Ошибка
    public static let error = Text.tr("Localizable", "Alert.Error")
    /// Нет
    public static let no = Text.tr("Localizable", "Alert.No")
    /// Невозможно
    public static let unreal = Text.tr("Localizable", "Alert.Unreal")
    /// Да
    public static let yes = Text.tr("Localizable", "Alert.Yes")
  }

  public enum Common {
    /// Назад
    public static let back = Text.tr("Localizable", "Common.Back")
    /// Отмена
    public static let cancel = Text.tr("Localizable", "Common.Cancel")
    /// Готово
    public static let done = Text.tr("Localizable", "Common.Done")
    /// Скрыть
    public static let hide = Text.tr("Localizable", "Common.Hide")
    /// Загрузка
    public static let loading = Text.tr("Localizable", "Common.Loading")
    /// Далее
    public static let `return` = Text.tr("Localizable", "Common.Return")
  }

  public enum Errors {
    /// Ошибка сети
    public static let networkError = Text.tr("Localizable", "Errors.NetworkError")
    /// Ошибка сервера
    public static let remoteError = Text.tr("Localizable", "Errors.RemoteError")
    /// Ошибка запроса
    public static let requestError = Text.tr("Localizable", "Errors.RequestError")
    /// Повторить
    public static let tryAgain = Text.tr("Localizable", "Errors.TryAgain")
    /// Неизвестная ошибка
    public static let unknownError = Text.tr("Localizable", "Errors.UnknownError")
  }

  public enum Lesson {
    ///    Начать слушать
    public static let listen = Text.tr("Localizable", "Lesson.Listen")
    /// Следующий урок
    public static let nextLesson = Text.tr("Localizable", "Lesson.NextLesson")
    /// %@ ∙ %d АУДИОЗАПИСИ
    public static func subtitle2to4Tracks(_ p1: String, _ p2: Int) -> String {
      return Text.tr("Localizable", "Lesson.Subtitle2to4Tracks", p1, p2)
    }
    /// %@ ∙ %d АУДИОЗАПИСЕЙ
    public static func subtitleFrom5Tracks(_ p1: String, _ p2: Int) -> String {
      return Text.tr("Localizable", "Lesson.SubtitleFrom5Tracks", p1, p2)
    }
    /// %@ ∙ АУДИОЗАПИСЬ
    public static func subtitleOneTrack(_ p1: String) -> String {
      return Text.tr("Localizable", "Lesson.SubtitleOneTrack", p1)
    }
  }

  public enum MainPage {
    /// Нажми для подробностей
    public static let pressForInfo = Text.tr("Localizable", "MainPage.PressForInfo")
    /// Программы
    public static let programs = Text.tr("Localizable", "MainPage.Programs")
    /// Тринадцать уникальных уроков. Слушайте по одному в день. И вы удивитесь как изменится ваша жизнь. 
    public static let programsDescription = Text.tr("Localizable", "MainPage.ProgramsDescription")
    /// Попробуй PREMIUM бесплатно!
    public static let tryPremium = Text.tr("Localizable", "MainPage.TryPremium")
  }
}
// swiftlint:enable explicit_type_interface function_parameter_count identifier_name line_length
// swiftlint:enable nesting type_body_length type_name

// MARK: - Implementation Details

extension Text {
  private static func tr(_ table: String, _ key: String, _ args: CVarArg...) -> String {
    // swiftlint:disable:next nslocalizedstring_key
    let format = NSLocalizedString(key, tableName: table, bundle: Bundle(for: BundleToken.self), comment: "")
    return String(format: format, locale: Locale.current, arguments: args)
  }
}

private final class BundleToken {}
