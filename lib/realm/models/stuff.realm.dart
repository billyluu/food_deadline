// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'stuff.dart';

// **************************************************************************
// RealmObjectGenerator
// **************************************************************************

// ignore_for_file: type=lint
class Stuff extends _Stuff with RealmEntity, RealmObjectBase, RealmObject {
  Stuff(
    ObjectId id,
    String name,
    int deadline,
  ) {
    RealmObjectBase.set(this, 'id', id);
    RealmObjectBase.set(this, 'name', name);
    RealmObjectBase.set(this, 'deadline', deadline);
  }

  Stuff._();

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
  Stream<RealmObjectChanges<Stuff>> get changes =>
      RealmObjectBase.getChanges<Stuff>(this);

  @override
  Stream<RealmObjectChanges<Stuff>> changesFor([List<String>? keyPaths]) =>
      RealmObjectBase.getChangesFor<Stuff>(this, keyPaths);

  @override
  Stuff freeze() => RealmObjectBase.freezeObject<Stuff>(this);

  EJsonValue toEJson() {
    return <String, dynamic>{
      'id': id.toEJson(),
      'name': name.toEJson(),
      'deadline': deadline.toEJson(),
    };
  }

  static EJsonValue _toEJson(Stuff value) => value.toEJson();
  static Stuff _fromEJson(EJsonValue ejson) {
    if (ejson is! Map<String, dynamic>) return raiseInvalidEJson(ejson);
    return switch (ejson) {
      {
        'id': EJsonValue id,
        'name': EJsonValue name,
        'deadline': EJsonValue deadline,
      } =>
        Stuff(
          fromEJson(id),
          fromEJson(name),
          fromEJson(deadline),
        ),
      _ => raiseInvalidEJson(ejson),
    };
  }

  static final schema = () {
    RealmObjectBase.registerFactory(Stuff._);
    register(_toEJson, _fromEJson);
    return const SchemaObject(ObjectType.realmObject, Stuff, 'Stuff', [
      SchemaProperty('id', RealmPropertyType.objectid, primaryKey: true),
      SchemaProperty('name', RealmPropertyType.string),
      SchemaProperty('deadline', RealmPropertyType.int),
    ]);
  }();

  @override
  SchemaObject get objectSchema => RealmObjectBase.getSchema(this) ?? schema;
}
