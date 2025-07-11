import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:food_deadline/core/blocs/notification/notification_bloc.dart';
import 'package:food_deadline/core/constants/app_localizations.dart';
import 'package:food_deadline/core/constants/color.dart';
import 'package:food_deadline/core/constants/enums/app_locale.dart';
import 'package:food_deadline/core/di/service_locator.dart';
import 'package:food_deadline/features/main/main_screen.dart';
import 'package:food_deadline/features/settings/blocs/app_settings/app_settings_bloc.dart';

class App extends StatelessWidget {
  const App({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider<AppSettingsBloc>(create: (context) => getIt<AppSettingsBloc>()),
        BlocProvider<NotificationBloc>(create: (context) => getIt<NotificationBloc>()),
      ],
      child: BlocBuilder<AppSettingsBloc, AppSettingsState>(
        builder: (context, state) {
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
              colorScheme: myColorScheme,
              useMaterial3: true,
              appBarTheme: AppBarTheme(
                backgroundColor: myColorScheme.primary,
                foregroundColor: myColorScheme.onPrimary,
                elevation: 0,
              ),
              cardTheme: CardTheme(
                color: myColorScheme.surface,
                elevation: 2,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              elevatedButtonTheme: ElevatedButtonThemeData(
                style: ElevatedButton.styleFrom(
                  backgroundColor: myColorScheme.primary,
                  foregroundColor: myColorScheme.onPrimary,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
              ),
            ),
            darkTheme: ThemeData(
              colorScheme: myDarkColorScheme,
              useMaterial3: true,
              appBarTheme: AppBarTheme(
                backgroundColor: myDarkColorScheme.tertiary,
                foregroundColor: myDarkColorScheme.onTertiary,
                elevation: 0,
              ),
              cardTheme: CardTheme(
                color: myDarkColorScheme.surface,
                elevation: 4,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              elevatedButtonTheme: ElevatedButtonThemeData(
                style: ElevatedButton.styleFrom(
                  backgroundColor: myDarkColorScheme.primary,
                  foregroundColor: myDarkColorScheme.onPrimary,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
              ),
            ),
            themeMode: state.theme,
            home: const MainScreen(),
          );
        },
      ),
    );
  }
}
