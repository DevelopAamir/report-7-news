import 'package:localstorage/localstorage.dart' show LocalStorage;
import '../constants/config.dart' show storageKey;

class LocalStorageService{

  final LocalStorage _storage = LocalStorage(storageKey);

  static final LocalStorageService _singleton = LocalStorageService._internal();
  factory LocalStorageService() => _singleton;
  LocalStorageService._internal();

  Future<void> saveToStorage<T>(String key, T data) async {
    await _storage.ready;
    return _storage.setItem(key, data);
  }

  dynamic getFromStorage(String key) async {
    await _storage.ready;
    return _storage.getItem(key);
  }

  Future<void> remove(String key) async {
    await _storage.ready;
    return _storage.deleteItem(key);
  }

  Future<void> clear() async {
    await _storage.ready;
    return _storage.clear();
  }

}