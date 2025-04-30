import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:food_deadline/core/realm/models/expirable_item.dart';
import 'package:food_deadline/core/realm/realm_helper.dart';

part 'expirable_event.dart';
part 'expirable_state.dart';

class ExpirableItemBloc extends Bloc<ExpirableItemEvent, ExpirableItemState> {
  final RealmHelper realmHelper;

  ExpirableItemBloc({
    required this.realmHelper,
  }) : super(ExpirableItemLoading()) {
    on<ExpirableItemInitialEvent>((event, emit) => _init(event, emit));
    on<ExpirableItemAddEvent>((event, emit) => _add(event, emit));
    on<ExpirableItemDeleteEvent>((event, emit) => _delete(event, emit));
  }

  void _init(ExpirableItemEvent event, Emitter<ExpirableItemState> emit) {
    RealmHelper.getRealm((realm) {
      final stuffs = realm.all<ExpirableItem>().toList();
      emit(ExpirableItemSuccess(expirableItem: stuffs));
    });
  }

  void _add(ExpirableItemAddEvent event, Emitter<ExpirableItemState> emit) {
    RealmHelper.getRealm((realm) {
      realm.write(() {
        realm.add<ExpirableItem>(event.expirableItem);
      });
      final stuffs = realm.all<ExpirableItem>().toList();
      emit(ExpirableItemSuccess(expirableItem: stuffs));
    });
  }

  void _delete(ExpirableItemDeleteEvent event, Emitter<ExpirableItemState> emit) {
    RealmHelper.getRealm((realm) {
      realm.write(() {
        realm.delete(event.expirableItem);
      });
      final stuffs = realm.all<ExpirableItem>().toList();
      emit(ExpirableItemSuccess(expirableItem: stuffs));
    });
  }
}
