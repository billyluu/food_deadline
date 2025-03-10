import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:food_deadline/presentation/blocs/app_settings/app_settings_bloc.dart';
import 'package:food_deadline/presentation/screen/main/main_screen.dart';

void main() {
  runApp(
    const App(),
  );
}

class App extends StatelessWidget {
  const App({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider<AppSettingsBloc>(create: (context) => AppSettingsBloc()),
      ],
      child: BlocBuilder<AppSettingsBloc, AppSettingsState>(
        builder: (context, state) {
          context.read<AppSettingsBloc>().add(AppSettingsLoadingEvent());
          return MaterialApp(
            locale: state.appLocale.getLocale(),
            theme: ThemeData(
              colorScheme: ColorScheme.fromSeed(
                  seedColor: Colors.green, brightness: Brightness.light),
              useMaterial3: true,
            ),
            darkTheme: ThemeData(
              colorScheme: ColorScheme.fromSeed(
                  seedColor: Colors.green, brightness: Brightness.dark),
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
