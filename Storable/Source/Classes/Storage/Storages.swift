import KeychainAccess
let KeychainAccessGroup = "com.md.nails-ios"
/// Конфигурация хранилища, осуществляющего чтение/запись/удаление, используется при объявлении ключа.
/// Указывает на собственно тип хранилища и используемые им дополнительные параметры
protocol StorageConfiguration {
    /// Хранилище
    static var storage: StoresData { get }

    /// Дополнительные параметры, использумые
    /// при записи / чтении из хранилища
    static var config: ConfiguresStorage { get }
}

/// Перечень хранилищ. Конкретное хранилище указывается при объявлении хранимого ключа в AppKeysRegistry
enum Storages {
    /// Стандартные UserDefaults
    enum Defaults: StorageConfiguration {
        static var userDefaultsType: UserDefaults.Type = UserDefaults.self
        static var storage: StoresData = userDefaultsType.standard
    }

    /// UserDefaults группы "group.com.md.nails"
    enum GroupDefaults: StorageConfiguration {
        static var suiteName: String = KeychainAccessGroup
        static var userDefaultsType: UserDefaults.Type = UserDefaults.self
        static var storage: StoresData = userDefaultsType.init(suiteName: suiteName) ?? userDefaultsType.standard
    }

    /// Кейчейн, закрываемый при блокировке устройства (рекомендуется)
    enum WhenUnlockedKeychain: StorageConfiguration {
        static var storage: StoresData = Keychain(service: "com.md.nails-ios.when_unlocked").accessibility(.whenUnlocked)
    }

    /// Кейчейн, открытый после первой разблокировки устройства
    enum AfterFirstUnlockKeychain: StorageConfiguration {
        static var storage: StoresData = Keychain(service: "com.md.nails-ios.after_first").accessibility(.afterFirstUnlock)
    }

    /// Хранилище, содержащее записи в памяти
    enum InMemory: StorageConfiguration {
        static var storage: StoresData = [String: Any]()
    }
}
