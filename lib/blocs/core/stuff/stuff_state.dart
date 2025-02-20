part of 'stuff_bloc.dart';

@immutable
sealed class StuffState {}

final class StuffLoading extends StuffState {
  StuffLoading({
    this.stuffs,
  });

  final List<Stuff>? stuffs;
}

final class StuffSuccess extends StuffState {
  StuffSuccess({
    required this.stuffs,
  });

  final List<Stuff> stuffs;
}
