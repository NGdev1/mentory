/**
 * Тип, выступающий контейнером для значений, хранимых в настройках.
 * Используется как Type Eraser для случаев, когда простой Stored не подходит
 */
struct StoredBox<T>: Stored, ValueBox {
    let value: T

    init(_ value: T) {
        self.value = value
    }

    func toPrimitive() -> T? {
        return value
    }

    static func from(primitive: T) -> StoredBox<T>? {
        return StoredBox(primitive)
    }
}
