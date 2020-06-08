/// Структура записи в хранилище. Инициализируется при помощи ключа, а также дженериков —
/// типа объекта записи и конфигурации хранилища
struct Storable<Object: Stored, Storage: StorageConfiguration>: ExpressibleByStringLiteral, StringLiteralBoilerplate {
    let key: String
    var store: StoresData = Storage.storage

    init(stringLiteral key: String) {
        self.key = key
    }

    var value: Object? {
        set {
            store.set(newValue?.toPrimitive(), for: key, config: Storage.config)
        }
        get {
            guard let primitive = store.getValue(for: key, config: Storage.config) as? Object.Primitive
            else { return nil }
            return Object.from(primitive: primitive)
        }
    }
}

/// Протокол, описывающий контейнер для хранимых значений
protocol ValueBox {
    associatedtype Value
    init(_ value: Value)
    var value: Value { get }
}

extension Storable where Object: ValueBox {
    var boxedValue: Object.Value? {
        get { return value?.value }
        set { value = newValue.map { Object($0) } }
    }
}

/// Протокол для удобства инициализации структуры при помощи ключа
protocol StringLiteralBoilerplate {
    init(stringLiteral value: String)
}

// Обязательные соответствия для протокола ExpressibleBystringLiteral
extension StringLiteralBoilerplate {
    typealias StringLiteralType = String

    init(unicodeScalarLiteral value: String) {
        self.init(stringLiteral: value)
    }

    init(extendedGraphemeClusterLiteral value: String) {
        self.init(stringLiteral: value)
    }
}
