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
