import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:food_deadline/core/constants/app_string.dart';
import 'package:food_deadline/core/di/service_locator.dart';
import 'package:food_deadline/features/dialog/edit_expirable_item_dialog.dart';
import 'package:food_deadline/features/home/bloc/expirable_Item/expirable_bloc.dart';
import 'package:food_deadline/features/home/home_screen.dart';
import 'package:food_deadline/features/settings/settings_screen.dart';
import 'package:food_deadline/shared/widgets/shared_common_text.dart';

enum MainBottomNavType {
  home(
    title: AppString.bottomNavBarHome,
    icon: Icons.home,
  ),
  settings(
    title: AppString.bottomNavBarSetting,
    icon: Icons.settings,
  );

  const MainBottomNavType({
    required this.title,
    required this.icon,
  });

  final AppString title;
  final IconData icon;
}

class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  State<MainScreen> createState() => MainScreenState();
}

class MainScreenState extends State<MainScreen> {
  var _currentIndex = 0;
  late final ExpirableItemBloc _expirableItemBloc;

  @override
  void initState() {
    super.initState();
    _expirableItemBloc = getIt<ExpirableItemBloc>()..add(ExpirableItemInitialEvent());
  }

  @override
  void dispose() {
    _expirableItemBloc.close();
    super.dispose();
  }

  void onItemTapped(int index) {
    setState(() => _currentIndex = index);
  }

  Widget _getCurrentScreen() {
    switch (_currentIndex) {
      case 0:
        return BlocProvider<ExpirableItemBloc>.value(
          value: _expirableItemBloc,
          child: const HomeScreen(),
        );
      case 1:
        return const SettingsScreen();
      default:
        return BlocProvider<ExpirableItemBloc>.value(
          value: _expirableItemBloc,
          child: const HomeScreen(),
        );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(15),
        child: AppBar(
          backgroundColor: Theme.of(context).colorScheme.primary,
        ),
      ),
      body: _getCurrentScreen(),
      bottomNavigationBar: BottomAppBar(
        shape: const CircularNotchedRectangle(),
        color: Theme.of(context).colorScheme.primary,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            for (var i = 0; i < MainBottomNavType.values.length; i++) ...[
              ElevatedButton.icon(
                label: SharedCommonText(
                  text: MainBottomNavType.values[i].title.getI18n(context),
                  style: CommonTextStyle.textStyle(
                      color: Theme.of(context).colorScheme.onPrimary),
                ),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.transparent,
                  shadowColor: Colors.transparent,
                ),
                onPressed: () => onItemTapped(i),
                icon: Icon(
                  MainBottomNavType.values[i].icon,
                  color: Theme.of(context).colorScheme.onPrimary,
                ),
              ),
            ],
          ],
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      floatingActionButton: _currentIndex == 0
          ? FloatingActionButton(
              shape: const CircleBorder(),
              onPressed: () {
                showDialog(
                  context: context,
                  builder: (dialogContext) => BlocProvider<ExpirableItemBloc>.value(
                    value: _expirableItemBloc, // 使用同一個 BLoC 實例
                    child: const EditExpirableItemDialog(),
                  ),
                );
              },
              child: const Icon(Icons.add),
            )
          : null,
    );
  }
}
