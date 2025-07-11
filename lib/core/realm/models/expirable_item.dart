import 'package:realm/realm.dart';

part 'expirable_item.realm.dart';


@RealmModel()
class _ExpirableItem {
  @PrimaryKey()
  late ObjectId id;
  late String name;
  late int deadline;

  bool get isExpired => DateTime.now().millisecondsSinceEpoch > deadline;
}

extension ExpirableItemExtension on SchemaObject {
  ExpirableItem newItem(String name, int deadline) =>
      ExpirableItem(ObjectId(), name, deadline);
}