// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'expirable_item.dart';

// **************************************************************************
// RealmObjectGenerator
// **************************************************************************

// ignore_for_file: type=lint
class ExpirableItem extends _ExpirableItem
    with RealmEntity, RealmObjectBase, RealmObject {
  ExpirableItem(
    ObjectId id,
    String name,
    int deadline,
  ) {
    RealmObjectBase.set(this, 'id', id);
    RealmObjectBase.set(this, 'name', name);
    RealmObjectBase.set(this, 'deadline', deadline);
  }

  ExpirableItem._();

  @override
  ObjectId get id => RealmObjectBase.get<ObjectId>(this, 'id') as ObjectId;
  @override
  set id(ObjectId value) => RealmObjectBase.set(this, 'id', value);

  @override
  String get name => RealmObjectBase.get<String>(this, 'name') as String;
  @override
  set name(String value) => RealmObjectBase.set(this, 'name', value);

  @override
  int get deadline => RealmObjectBase.get<int>(this, 'deadline') as int;
  @override
  set deadline(int value) => RealmObjectBase.set(this, 'deadline', value);

  @override
  Stream<RealmObjectChanges<ExpirableItem>> get changes =>
      RealmObjectBase.getChanges<ExpirableItem>(this);

  @override
  Stream<RealmObjectChanges<ExpirableItem>> changesFor(
          [List<String>? keyPaths]) =>
      RealmObjectBase.getChangesFor<ExpirableItem>(this, keyPaths);

  @override
  ExpirableItem freeze() => RealmObjectBase.freezeObject<ExpirableItem>(this);

  EJsonValue toEJson() {
    return <String, dynamic>{
      'id': id.toEJson(),
      'name': name.toEJson(),
      'deadline': deadline.toEJson(),
    };
  }

  static EJsonValue _toEJson(ExpirableItem value) => value.toEJson();
  static ExpirableItem _fromEJson(EJsonValue ejson) {
    if (ejson is! Map<String, dynamic>) return raiseInvalidEJson(ejson);
    return switch (ejson) {
      {
        'id': EJsonValue id,
        'name': EJsonValue name,
        'deadline': EJsonValue deadline,
      } =>
        ExpirableItem(
          fromEJson(id),
          fromEJson(name),
          fromEJson(deadline),
        ),
      _ => raiseInvalidEJson(ejson),
    };
  }

  static final schema = () {
    RealmObjectBase.registerFactory(ExpirableItem._);
    register(_toEJson, _fromEJson);
    return const SchemaObject(
        ObjectType.realmObject, ExpirableItem, 'ExpirableItem', [
      SchemaProperty('id', RealmPropertyType.objectid, primaryKey: true),
      SchemaProperty('name', RealmPropertyType.string),
      SchemaProperty('deadline', RealmPropertyType.int),
    ]);
  }();

  @override
  SchemaObject get objectSchema => RealmObjectBase.getSchema(this) ?? schema;
}
