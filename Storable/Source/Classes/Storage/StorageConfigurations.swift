import KeychainAccess

/// Протокол дополнительных параметров, используемых данным типом хранилища
protocol ConfiguresStorage {}

/// Дополнительные параметры по-умолчанию (пустые)
struct DefaultConfig: ConfiguresStorage {}

// Расширение, инициализирующее конфигурацию по-умолчанию
extension StorageConfiguration {
    static var config: ConfiguresStorage { return DefaultConfig() }
}
