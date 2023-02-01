//
//  AppService.swift
//  Storable
//
//  Created by Andreichev Michael on 07/04/2019.
//

import Foundation

public final class AppService {
    public static let shared = AppService()
    /// Инстанс хранилища
    static let store = KeysRegistry()

    /// Текущая модель приложения
    public var app: App = .init(keysRegistry: store)
}
