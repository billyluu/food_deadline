import 'package:bloc/bloc.dart';
import 'package:food_deadline/realm/models/stuff.dart';
import 'package:food_deadline/realm/realm_helper.dart';

part 'main_event.dart';
part 'main_state.dart';

class MainBloc extends Bloc<MainEvent, MainState> {
  MainBloc() : super(MainLoading()) {
    on<MainInitialEvent>((event, emit) => _init(event, emit));
  }

  void _init(MainInitialEvent event, Emitter<MainState> emit) {
    RealmHelper.getRealm((realm) {
      final stuffs = realm.all<Stuff>().toList();
      emit(MainSuccess(stuffs: stuffs));
    });
  }
}
