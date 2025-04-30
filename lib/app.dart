import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:food_deadline/core/blocs/notification/notification_bloc.dart';
import 'package:food_deadline/core/constants/app_localizations.dart';
import 'package:food_deadline/core/constants/enums/app_locale.dart';
import 'package:food_deadline/features/main/main_screen.dart';
import 'package:food_deadline/features/settings/blocs/app_settings/app_settings_bloc.dart';

class App extends StatelessWidget {
  const App({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider<AppSettingsBloc>(create: (context) => AppSettingsBloc()),
        BlocProvider<NotificationBloc>(create: (context) => NotificationBloc()),
      ],
      child: BlocBuilder<AppSettingsBloc, AppSettingsState>(
        builder: (context, state) {
          context.read<AppSettingsBloc>().add(AppSettingsLoadingEvent());
          return MaterialApp(
            supportedLocales: AppLocale.values.map((e) => e.getLocale()),
            locale: state.appLocale.getLocale(),
            localizationsDelegates: const [
              AppLocalizations.delegate,
              GlobalMaterialLocalizations.delegate,
              GlobalWidgetsLocalizations.delegate,
              GlobalCupertinoLocalizations.delegate,
            ],
            theme: ThemeData(
              colorScheme: ColorScheme.fromSeed(
                seedColor: Colors.green,
                brightness: Brightness.light,
              ),
              useMaterial3: true,
            ),
            darkTheme: ThemeData(
              colorScheme: ColorScheme.fromSeed(
                seedColor: Colors.green,
                brightness: Brightness.dark,
              ),
              useMaterial3: true,
            ),
            themeMode: state.theme,
            home: const MainScreen(),
          );
        },
      ),
    );
  }
}
