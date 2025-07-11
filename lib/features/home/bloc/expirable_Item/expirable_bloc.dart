import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:food_deadline/core/realm/models/expirable_item.dart';
import 'package:food_deadline/core/realm/realm_helper.dart';
import 'package:food_deadline/core/errors/app_exception.dart';
import 'package:food_deadline/core/utils/result.dart';
import 'package:food_deadline/core/utils/notification_service.dart';

part 'expirable_event.dart';
part 'expirable_state.dart';

class ExpirableItemBloc extends Bloc<ExpirableItemEvent, ExpirableItemState> {
  final RealmHelper realmHelper;
  final NotificationService notificationService;

  ExpirableItemBloc({
    required this.realmHelper,
    required this.notificationService,
  }) : super(ExpirableItemLoading()) {
    on<ExpirableItemInitialEvent>((event, emit) => _init(event, emit));
    on<ExpirableItemAddEvent>((event, emit) => _add(event, emit));
    on<ExpirableItemDeleteEvent>((event, emit) => _delete(event, emit));
  }

  void _init(ExpirableItemEvent event, Emitter<ExpirableItemState> emit) {
    final result = realmHelper.getAllItems();
    
    switch (result) {
      case Success(data: final items):
        emit(ExpirableItemSuccess(expirableItem: items));
      case Failure(exception: final exception):
        emit(ExpirableItemError(exception: exception));
    }
  }

  void _add(ExpirableItemAddEvent event, Emitter<ExpirableItemState> emit) async {
    final addResult = realmHelper.addItem(event.expirableItem);
    
    switch (addResult) {
      case Success():
        // 排程通知
        await notificationService.scheduleExpiryNotifications(event.expirableItem);
        
        final getResult = realmHelper.getAllItems();
        switch (getResult) {
          case Success(data: final items):
            emit(ExpirableItemSuccess(expirableItem: items));
          case Failure(exception: final exception):
            emit(ExpirableItemError(exception: exception));
        }
      case Failure(exception: final exception):
        // 保持當前狀態下的資料，但顯示錯誤
        final currentItems = state is ExpirableItemSuccess 
            ? (state as ExpirableItemSuccess).expirableItem 
            : <ExpirableItem>[];
        emit(ExpirableItemError(
          exception: exception,
          expirableItem: currentItems,
        ));
    }
  }

  void _delete(ExpirableItemDeleteEvent event, Emitter<ExpirableItemState> emit) async {
    // 先取消通知
    await notificationService.cancelExpiryNotifications(event.expirableItem);
    
    final deleteResult = realmHelper.deleteItem(event.expirableItem);
    
    switch (deleteResult) {
      case Success():
        final getResult = realmHelper.getAllItems();
        switch (getResult) {
          case Success(data: final items):
            emit(ExpirableItemSuccess(expirableItem: items));
          case Failure(exception: final exception):
            emit(ExpirableItemError(exception: exception));
        }
      case Failure(exception: final exception):
        // 保持當前狀態下的資料，但顯示錯誤
        final currentItems = state is ExpirableItemSuccess 
            ? (state as ExpirableItemSuccess).expirableItem 
            : <ExpirableItem>[];
        emit(ExpirableItemError(
          exception: exception,
          expirableItem: currentItems,
        ));
    }
  }
}
