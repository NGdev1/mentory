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
    /// Имя пользователя
    var userName: Storable<String, Storages.Defaults> = "com.deltapps.mentory.key.userName"
    /// URL сервера
    var baseURL: Storable<String, Storages.InMemory> = "com.deltapps.mentory.key.baseURL"
    /// URL сервера iTunes
    var itunesURL: Storable<String, Storages.InMemory> = "com.deltapps.mentory.key.itunesUrl"
}
