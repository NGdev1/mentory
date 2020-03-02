//  Реестра ключей.
//  Для сохранения обратной совместимости могут использоваться легаси константы
//  вместо обратной доменной нотации
final class KeysRegistry {
    /// Токен FCM
    var fcmToken: Storable<String, Storages.Defaults> = "com.deltapps.mentory.key.fcmToken"
    /// Сколько раз пользователь открывал приложение
    var appOpenedCount: Storable<Int, Storages.Defaults> = "com.deltapps.mentory.key.appOpenedCount"
    /// Премиум аккаунт или обычный
    var appState: Storable<String, Storages.Defaults> = "com.deltapps.mentory.key.appState"
}
