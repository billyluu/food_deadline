part of 'home_bloc.dart';

sealed class HomeState {}

final class HomeLoading extends HomeState {
  HomeLoading({
    this.stuffs,
  });

  List<Stuff>? stuffs;
}

final class HomeSuccess extends HomeState {
  HomeSuccess({
    required this.stuffs,
  });

  List<Stuff> stuffs;
}
