part of 'expirable_bloc.dart';

@immutable
abstract class ExpirableItemEvent {}

class ExpirableItemInitialEvent extends ExpirableItemEvent {}

class ExpirableItemLoadEvent extends ExpirableItemEvent {}

class ExpirableItemAddEvent extends ExpirableItemEvent {
  final ExpirableItem expirableItem;

  ExpirableItemAddEvent({
    required this.expirableItem,
  });
}

class ExpirableItemDeleteEvent extends ExpirableItemEvent {
  final ExpirableItem expirableItem;

  ExpirableItemDeleteEvent({
    required this.expirableItem,
  });
}
