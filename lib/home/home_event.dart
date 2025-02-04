part of 'home_bloc.dart';


sealed class HomeEvent {}

class HomeInitialEvent extends HomeEvent {}

class HomeLoadEvent extends HomeEvent {}

class HomeAddEvent extends HomeEvent {
  HomeAddEvent({
    required this.stuff,
  });

  Stuff stuff;
}

class HomeDeleteEvent extends HomeEvent {
  HomeDeleteEvent({
    required this.stuff,
  });

  Stuff stuff;
}


