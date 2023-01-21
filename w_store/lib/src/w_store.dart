import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:sp_util/sp_util.dart';
import 'package:w_utils/w_utils.dart';

enum WStoreListenerType {
  // getItem,
  setItem,
  removeItem,
  clear,
}

typedef WStoreListener = void Function(
  WStoreListenerType type, {
  String? key,
  dynamic value,
});

abstract class WStore {
  Future<void> clear();
  dynamic getItem(String key, {dynamic defaultVal});
  Future<void> setItem<T>(String key, T value);
  Future<void> removeItem(String key);
  void addListener(WStoreListener listener);
  void removeListener(WStoreListener listener);
}

class WSpStore implements WStore {
  static WSpStore? _instance;
  static const String _key = 'w_sp_store_key';
  static Map<String, dynamic> _store = {};
  static final _listeners = <WStoreListener>[];

  static void _print(Object msg, [String type = 'log']) {
    if (kDebugMode) {
      print('[$_key][${type.toUpperCase()}]: ${msg.toString()}');
    }
  }

  static Future<WSpStore> init([bool restore = true]) async {
    if (_instance == null) {
      await SpUtil.getInstance();
      _instance = WSpStore._();

      if (restore == false) {
        return _instance!;
      }

      final jsonDataStr = SpUtil.getString(_key);
      if (WStringUtils.isNotEmpty(jsonDataStr)) {
        try {
          final data = json.decode(jsonDataStr!);
          _store = data;
        } catch (e) {
          _print('failed to restore: ${e.toString()}', 'ERROR');
        }
      }
    }

    return _instance!;
  }

  static String get key => _key;
  static Map<String, dynamic> get store => _store;

  static WSpStore getInstance() {
    return _instance!;
  }

  WSpStore._();

  Future<void> _update() async {
    await SpUtil.putString(_key, json.encode(_store));
  }

  void _notifyListeners(
    WStoreListenerType type, {
    String? key,
    dynamic value,
  }) {
    for (var listener in _listeners) {
      try {
        listener(type, value: value, key: key);
      } catch (err) {
        _print(
            'execute listener(${listener.toString()}) error: ${err.toString()}');
      }
    }
  }

  @override
  Future<void> clear() async {
    _store.clear();
    _notifyListeners(
      WStoreListenerType.clear,
    );
    await SpUtil.remove(_key);
  }

  @override
  dynamic getItem(String key, {dynamic defaultVal}) {
    final res = _store[key] ?? defaultVal;
    return res;
  }

  @override
  Future<void> removeItem(String key) async {
    _store.remove(key);
    _notifyListeners(WStoreListenerType.removeItem, key: key);
    await _update();
  }

  @override
  Future<void> setItem<T>(String key, T value) async {
    _store[key] = value;
    _notifyListeners(WStoreListenerType.setItem, key: key, value: value);
    await _update();
  }

  @override
  void addListener(WStoreListener listener) {
    _listeners.add(listener);
  }

  @override
  void removeListener(WStoreListener listener) {
    _listeners.remove(listener);
  }
}
