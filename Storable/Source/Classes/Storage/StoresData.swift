import KeychainAccess

/// Протокол хранилища, регламентирует операции записи, чтения, удаления
protocol StoresData {
    /// Записать значение по ключу с данной конфигурацией
    mutating func set<T>(_ value: T?, for key: String, config: ConfiguresStorage)

    /// Получить значение по ключу с данной конфигурацией
    func getValue(for key: String, config: ConfiguresStorage) -> Any?

    /// Стереть значение по ключу с данной конфигурацией
    mutating func deleteValue(for key: String, config: ConfiguresStorage)
}

extension Keychain: StoresData {
    func set<T>(_ value: T?, for key: String, config: ConfiguresStorage) {
        if let stringValue = value as? String {
            do {
                try set(stringValue, key: key)
            } catch let error as Status {
                print(error.description)
            } catch { print("Unknown error") }
        } else if let dataValue = value as? Data {
            do {
                try set(dataValue, key: key)
            } catch let error as Status {
                print(error.description)
            } catch { print("Unknown error") }
        } else if value == nil {
            do {
                try remove(key)
            } catch let error as Status {
                print(error.description)
            } catch { print("Unknown error") }
        } else {
            preconditionFailure("Non-string and Non-data value cannot be written to keychain")
        }
    }

    func getValue(for key: String, config _: ConfiguresStorage) -> Any? {
        do {
            return try get(key)
        } catch let error as Status {
            print(error.description)
        } catch { print("Unknown error") }
        return nil
    }

    func deleteValue(for key: String, config _: ConfiguresStorage) {
        do {
            try remove(key)

        } catch let error as Status {
            print(error.description)
        } catch { print("Unknown error") }
    }
}

extension UserDefaults: StoresData {
    func set<T>(_ value: T?, for key: String, config _: ConfiguresStorage) {
        setValue(value, forKey: key)
    }

    func getValue<T>(for key: String, config _: ConfiguresStorage) -> T? {
        return value(forKey: key) as? T
    }

    func deleteValue(for key: String, config _: ConfiguresStorage) {
        removeObject(forKey: key)
    }
}

extension Dictionary: StoresData where Key == String, Value == Any {
    mutating func set<T>(_ value: T?, for key: String, config _: ConfiguresStorage) {
        self[key] = value
    }

    func getValue<T>(for key: String, config _: ConfiguresStorage) -> T? {
        return self[key] as? T
    }

    mutating func deleteValue(for key: String, config _: ConfiguresStorage) {
        removeValue(forKey: key)
    }
}
