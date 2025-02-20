import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:food_deadline/realm/models/stuff.dart';
import 'package:food_deadline/realm/realm_helper.dart';

part 'stuff_event.dart';
part 'stuff_state.dart';

class StuffBloc extends Bloc<StuffEvent, StuffState> {
  final RealmHelper realmHelper;

  StuffBloc({
    required this.realmHelper,
  }) : super(StuffLoading()) {
    on<StuffInitialEvent>((event, emit) => _init(event, emit));
    on<StuffAddEvent>((event, emit) => _add(event, emit));
    on<StuffDeleteEvent>((event, emit) => _delete(event, emit));
  }

  void _init(StuffEvent event, Emitter<StuffState> emit) {
    RealmHelper.getRealm((realm) {
      final stuffs = realm.all<Stuff>().toList();
      emit(StuffSuccess(stuffs: stuffs));
    });
  }

  void _add(StuffAddEvent event, Emitter<StuffState> emit) {
    RealmHelper.getRealm((realm) {
      realm.write(() {
        realm.add<Stuff>(event.stuff);
      });
      final stuffs = realm.all<Stuff>().toList();
      emit(StuffSuccess(stuffs: stuffs));
    });
  }

  void _delete(StuffDeleteEvent event, Emitter<StuffState> emit) {
    RealmHelper.getRealm((realm) {
      realm.write(() {
        realm.delete(event.stuff);
      });
      final stuffs = realm.all<Stuff>().toList();
      emit(StuffSuccess(stuffs: stuffs));
    });
  }
}
