/// Протокол сущности, которая может транслироваться в примитив или из примитива
protocol Stored {
    associatedtype Primitive
    func toPrimitive() -> Primitive?
    static func from(primitive: Primitive) -> Self?
}

/// Протокол сущности, которая возвращает примитив после трансляции к нему, либо
/// экземпляр себя после преобразования из примитива
protocol StoredAsSelf: Stored where Primitive == Self {}

// Реализация по-умолчанию, используется для примитивных типов
extension StoredAsSelf {
    func toPrimitive() -> Primitive? {
        return self
    }

    static func from(primitive: Primitive) -> Primitive? {
        return primitive
    }
}
