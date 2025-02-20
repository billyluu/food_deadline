part of 'stuff_bloc.dart';

@immutable
abstract class StuffEvent {}

class StuffInitialEvent extends StuffEvent {}

class StuffLoadEvent extends StuffEvent {}

class StuffAddEvent extends StuffEvent {
  final Stuff stuff;

  StuffAddEvent({
    required this.stuff,
  });
}

class StuffDeleteEvent extends StuffEvent {
  final Stuff stuff;

  StuffDeleteEvent({
    required this.stuff,
  });
}
