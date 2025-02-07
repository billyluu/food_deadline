part of 'main_bloc.dart';

sealed class MainState {}

final class MainLoading extends MainState {}

final class MainSuccess extends MainState {
  MainSuccess({
    required this.stuffs,
  });

  List<Stuff> stuffs;
}
