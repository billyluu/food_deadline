import 'package:realm/realm.dart';
import 'package:food_deadline/core/utils/date_time_helper.dart';

part 'expirable_item.realm.dart';


@RealmModel()
class _ExpirableItem {
  @PrimaryKey()
  late ObjectId id;
  late String name;
  late int expiryDate;

  bool get isExpired => DateTimeHelper.isExpired(expiryDate);
}

extension ExpirableItemExtension on SchemaObject {
  ExpirableItem newItem(String name, int expiryDate) =>
      ExpirableItem(ObjectId(), name, expiryDate);
}