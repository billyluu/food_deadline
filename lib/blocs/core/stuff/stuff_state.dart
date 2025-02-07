part of 'stuff_bloc.dart';

sealed class StuffState {}

final class StuffLoading extends StuffState {
  StuffLoading({
    this.stuffs,
  });

  List<Stuff>? stuffs;
}

final class StuffSuccess extends StuffState {
  StuffSuccess({
    required this.stuffs,
  });

  List<Stuff> stuffs;
}
