import 'package:get_it/get_it.dart';
import 'package:food_deadline/core/realm/realm_helper.dart';
import 'package:food_deadline/core/utils/notification_service.dart';
import 'package:food_deadline/features/home/bloc/expirable_Item/expirable_bloc.dart';
import 'package:food_deadline/features/settings/blocs/app_settings/app_settings_bloc.dart';
import 'package:food_deadline/core/blocs/notification/notification_bloc.dart';

final getIt = GetIt.instance;

Future<void> setupServiceLocator() async {
  // 註冊核心服務
  getIt.registerSingleton<RealmHelper>(RealmHelper());
  getIt.registerSingleton<NotificationService>(NotificationService());

  // 註冊 BLoC（每次都建立新實例）
  getIt.registerFactory<AppSettingsBloc>(
    () => AppSettingsBloc(),
  );
  
  getIt.registerFactory<NotificationBloc>(
    () => NotificationBloc(),
  );
  
  getIt.registerFactory<ExpirableItemBloc>(
    () => ExpirableItemBloc(
      realmHelper: getIt<RealmHelper>(),
      notificationService: getIt<NotificationService>(),
    ),
  );
}