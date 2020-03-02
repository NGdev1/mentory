extension String: StoredAsSelf {
    typealias Primitive = String
}

extension Bool: StoredAsSelf {
    typealias Primitive = Bool
}

extension Float: StoredAsSelf {
    typealias Primitive = Float
}

extension CGFloat: StoredAsSelf {
    typealias Primitive = CGFloat
}

extension Double: StoredAsSelf {
    typealias Primitive = Double
}

extension Int: StoredAsSelf {
    typealias Primitive = Int
}

extension Date: Stored {
    typealias Primitive = TimeInterval

    func toPrimitive() -> Primitive? {
        return timeIntervalSince1970
    }

    static func from(primitive: Primitive) -> Date? {
        return Date(timeIntervalSince1970: primitive)
    }
}

extension AppState: Stored {
    typealias Primitive = String

    func toPrimitive() -> String? {
        return rawValue
    }

    static func from(primitive: String) -> AppState? {
        return AppState(rawValue: primitive)
    }
}
