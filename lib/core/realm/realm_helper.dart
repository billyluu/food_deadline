import 'package:realm/realm.dart';
import 'package:food_deadline/core/errors/app_exception.dart';
import 'package:food_deadline/core/utils/result.dart';

import 'models/expirable_item.dart';

class RealmHelper {
  late final Realm _realm;
  
  RealmHelper() {
    try {
      _realm = Realm(Configuration.local([
        ExpirableItem.schema,
      ]));
    } catch (e) {
      throw DatabaseException(
        message: '資料庫初始化失敗',
        originalError: e,
      );
    }
  }

  Result<T> executeWithRealm<T>(T Function(Realm realm) callback) {
    try {
      final result = callback(_realm);
      return Success(result);
    } on RealmException catch (e) {
      return Failure(DatabaseException(
        message: '資料庫操作失敗: ${e.message}',
        originalError: e,
      ));
    } catch (e) {
      return Failure(DatabaseException(
        message: '未知的資料庫錯誤',
        originalError: e,
      ));
    }
  }
  
  Result<List<ExpirableItem>> getAllItems() {
    return executeWithRealm((realm) {
      return realm.all<ExpirableItem>().toList();
    });
  }
  
  Result<void> addItem(ExpirableItem item) {
    return executeWithRealm<void>((realm) {
      realm.write(() {
        realm.add<ExpirableItem>(item);
      });
      return; // 明確回傳 void
    });
  }
  
  Result<void> deleteItem(ExpirableItem item) {
    return executeWithRealm((realm) {
      realm.write(() {
        realm.delete(item);
      });
    });
  }
  
  Realm get realm => _realm;
  
  void dispose() {
    try {
      _realm.close();
    } catch (e) {
      // 靜默處理關閉錯誤，避免應用崩潰
    }
  }
}
