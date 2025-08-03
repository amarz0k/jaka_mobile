import 'package:chat_app/domain/entities/user_entity.dart';
import 'package:hive_flutter/hive_flutter.dart';

class HiveService {
  Future<void> init() async {
    await Hive.initFlutter();
    await Hive.openBox<UserEntity>('currentUser');
  }

  Future<void> openBox<T>(String boxName) async {
    if (!isBoxOpen(boxName)) {
      await Hive.openBox<T>(boxName);
    }
  }

  bool isBoxOpen(String boxName) {
    return Hive.isBoxOpen(boxName);
  }

  Box<T> getBox<T>(String boxName) {
    return Hive.box<T>(boxName);
  }

  Future<void> closeBox(String boxName) async {
    if (isBoxOpen(boxName)) {
      await Hive.box(boxName).close();
    }
  }

  Future<void> deleteBox(String boxName) async {
    if (isBoxOpen(boxName)) {
      await Hive.box(boxName).deleteFromDisk();
    }
  }
}
