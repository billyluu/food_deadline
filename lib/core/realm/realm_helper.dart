import 'package:realm/realm.dart';

import 'models/expirable_item.dart';

class RealmHelper {
  static final Realm _realm = Realm(Configuration.local([
    ExpirableItem.schema,
  ]));

  static getRealm(Function(Realm realm) callback) => callback(_realm);
}
