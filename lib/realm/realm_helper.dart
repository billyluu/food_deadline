import 'package:realm/realm.dart';

import 'models/stuff.dart';

class RealmHelper {
  static final Realm _realm = Realm(Configuration.local([
    Stuff.schema,
  ]));

  static getRealm(Function(Realm realm) callback) => callback(_realm);
}
