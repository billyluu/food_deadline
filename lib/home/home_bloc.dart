import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:food_deadline/realm/models/stuff.dart';
import 'package:food_deadline/realm/realm_helper.dart';

part 'home_event.dart';

part 'home_state.dart';

class HomeBloc extends Bloc<HomeEvent, HomeState> {
  HomeBloc() : super(HomeLoading()) {
    on<HomeInitialEvent>((event, emit) => _init(event, emit));
    on<HomeAddEvent>(
      (event, emit) => _add(event, emit),
    );
    on<HomeDeleteEvent>((event, emit) => _delete(event, emit));
  }

  void _init(HomeEvent event, Emitter<HomeState> emit) {
    RealmHelper.getRealm((realm) {
      final stuffs = realm.all<Stuff>().toList();
      emit(HomeSuccess(stuffs: stuffs));
    });
  }

  void _add(HomeAddEvent event, Emitter<HomeState> emit) {
    RealmHelper.getRealm((realm) {
      realm.write(() {
        realm.add<Stuff>(event.stuff);
      });
      final stuffs = realm.all<Stuff>().toList();
      emit(HomeSuccess(stuffs: stuffs));
    });
  }

  void _delete(HomeDeleteEvent event, Emitter<HomeState> emit) {
    RealmHelper.getRealm((realm) {
      realm.write(() {
        realm.delete(event.stuff);
      });
      final stuffs = realm.all<Stuff>().toList();
      emit(HomeSuccess(stuffs: stuffs));
    });
  }
}
