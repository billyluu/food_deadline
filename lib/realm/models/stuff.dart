import 'package:realm/realm.dart';

part 'stuff.realm.dart';


@RealmModel()
class _Stuff {
  @PrimaryKey()
  late ObjectId id;
  late String name;
  late int deadline;

  bool get isExpired => DateTime.now().millisecondsSinceEpoch > deadline;
}

extension StuffExtension on SchemaObject {
  Stuff newStuff(String name, int deadline) =>
      Stuff(ObjectId(), name, deadline);
}