/// Модель текущего пользователя
public final class App {
    /// Реестр ключей
    var keysRegistry: KeysRegistry

    init(keysRegistry: KeysRegistry) {
        self.keysRegistry = keysRegistry
    }

    public var fcmToken: String? {
        get { return keysRegistry.fcmToken.value }
        set { keysRegistry.fcmToken.value = newValue }
    }

    public var appOpenedCount: Int {
        get { return keysRegistry.appOpenedCount.value ?? 0 }
        set { keysRegistry.appOpenedCount.value = newValue }
    }

    public var appState: AppState {
        get {
            if let appStateValue = keysRegistry.appState.value {
                return AppState(rawValue: appStateValue) ?? AppState.free
            } else { return AppState.free }
        }
        set { keysRegistry.appState.value = newValue.rawValue }
    }
}
