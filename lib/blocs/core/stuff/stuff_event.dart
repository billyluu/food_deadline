part of 'stuff_bloc.dart';


sealed class StuffEvent {}

class StuffInitialEvent extends StuffEvent {}

class StuffLoadEvent extends StuffEvent {}

class StuffAddEvent extends StuffEvent {
  StuffAddEvent({
    required this.stuff,
  });

  Stuff stuff;
}

class StuffDeleteEvent extends StuffEvent {
  StuffDeleteEvent({
    required this.stuff,
  });

  Stuff stuff;
}


