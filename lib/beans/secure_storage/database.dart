import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class DatabaseIdentity {
  String serverIp, serverUsername, serverPassword, serverDatabase;

  DatabaseIdentity(
      {required this.serverIp,
      required this.serverUsername,
      required this.serverPassword,
      required this.serverDatabase});

  static const _storage = FlutterSecureStorage();

  static Future<void> saveDatabaseIdentity(
      DatabaseIdentity databaseIdentity) async {
    await _storage.write(key: 'server_ip', value: databaseIdentity.serverIp);
    await _storage.write(
        key: 'server_username', value: databaseIdentity.serverUsername);
    await _storage.write(
        key: 'server_password', value: databaseIdentity.serverPassword);
    await _storage.write(
        key: 'server_database', value: databaseIdentity.serverDatabase);
  }

  static Future<DatabaseIdentity?> getDatabaseIdentity() async {
    String? serverIp = await _storage.read(key: 'server_ip');
    String? serverUsername = await _storage.read(key: 'server_username');
    String? serverPassword = await _storage.read(key: 'server_password');
    String? serverDatabase = await _storage.read(key: 'server_database');

    return DatabaseIdentity(
        serverIp: serverIp ?? '',
        serverUsername: serverUsername ?? '',
        serverPassword: serverPassword ?? '',
        serverDatabase: serverDatabase ?? '');
  }

  @override
  String toString() {
    return 'DatabaseIdentity(serverIp: $serverIp, server_username: $serverUsername, server_password: $serverPassword, server_database: $serverDatabase)';
  }
}
