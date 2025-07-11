part of 'expirable_bloc.dart';

@immutable
sealed class ExpirableItemState {}

final class ExpirableItemLoading extends ExpirableItemState {
  ExpirableItemLoading({
    this.expirableItem,
  });

  final List<ExpirableItem>? expirableItem;
}

final class ExpirableItemSuccess extends ExpirableItemState {
  ExpirableItemSuccess({
    required this.expirableItem,
  });

  final List<ExpirableItem> expirableItem;
}

final class ExpirableItemError extends ExpirableItemState {
  ExpirableItemError({
    required this.exception,
    this.expirableItem,
  });

  final AppException exception;
  final List<ExpirableItem>? expirableItem;
}
