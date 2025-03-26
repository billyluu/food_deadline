import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:food_deadline/core/constants/enums/app_task.dart';
import 'package:food_deadline/extension/datetime_extension.dart';
import 'package:food_deadline/presentation/blocs/stuff/stuff_bloc.dart';
import 'package:food_deadline/presentation/screen/edit_stuff/edit_stuff_main_screen.dart';
import 'package:food_deadline/presentation/screen/home/home_screen.dart';
import 'package:food_deadline/presentation/screen/settings/settings_screen.dart';
import 'package:food_deadline/presentation/widgets/common_text.dart';
import 'package:food_deadline/realm/realm_helper.dart';
import 'package:workmanager/workmanager.dart';

enum MainBottomNavType {
  home(
    title: AppString.bottomNavBarHome,
    icon: Icons.home,
    screen: HomeScreen(),
  ),
  settings(
    title: AppString.bottomNavBarSetting,
    icon: Icons.settings,
    screen: SizedBox(),
  ),
  ;

  const MainBottomNavType({
    required this.title,
    required this.icon,
    required this.screen,
  });

  final AppString title;
  final IconData icon;
  final Widget screen;
}

class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  State<MainScreen> createState() => MainScreenState();
}

class MainScreenState extends State<MainScreen> {
  var _currentIndex = 0;
  final now = DateTime.now();

  @override
  void initState() {
    super.initState();
  }

  void onItemTapped(int index) {
    setState(() {
      _currentIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider<StuffBloc>(
          create: (context) =>
              StuffBloc(realmHelper: RealmHelper())..add(StuffInitialEvent()),
        ),
      ],
      child: Scaffold(
        appBar: PreferredSize(
          preferredSize: const Size.fromHeight(15),
          child: AppBar(
            backgroundColor: Theme.of(context).colorScheme.primary,
          ),
        ),
        body: BlocBuilder<StuffBloc, StuffState>(
          builder: (context, state) {
            if (state is StuffSuccess) {
              final stuffs = state.stuffs;
              final expired = stuffs
                  .where((element) =>
                      element.deadline < DateTime.now().millisecondsSinceEpoch)
                  .length;
              return Column(
                children: [
                  if (_currentIndex == MainBottomNavType.home.index)
                    _Header(
                      date: now,
                      total: stuffs.length,
                      expired: expired,
                    ),
                  Expanded(
                    child: IndexedStack(
                      index: _currentIndex,
                      children: const [
                        HomeScreen(),
                        SettingsScreen(), // 設定畫面
                      ],
                    ),
                  ),
                ],
              );
            }

            return const Center(
              child: CircularProgressIndicator(),
            );
          },
        ),
        bottomNavigationBar: BottomAppBar(
          shape: const CircularNotchedRectangle(),
          color: Theme.of(context).colorScheme.primary,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              for (var i = 0; i < MainBottomNavType.values.length; i++) ...[
                ElevatedButton.icon(
                  label: CommonText(
                    text: MainBottomNavType.values[i].title.getL10n(context),
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
        floatingActionButton: BlocBuilder<StuffBloc, StuffState>(
          builder: (context, state) {
            return FloatingActionButton(
              shape: const CircleBorder(),
              onPressed: () async {
                // await Navigator.of(context).push(
                //   MaterialPageRoute(
                //     builder: (_) => BlocProvider.value(
                //       value: context.read<StuffBloc>(),
                //       child: const EditStuffMainScreen(),
                //     ),
                //   ),
                // );
                Workmanager().registerOneOffTask(
                  'test_task',
                  AppTask.updateDeadline.name,
                  initialDelay: const Duration(seconds: 5), // 5 秒後執行
                );
              },
              child: const Icon(Icons.add),
            );
          },
        ),
      ),
    );
  }
}

class _Header extends StatelessWidget {
  const _Header({
    required this.date,
    required this.total,
    required this.expired,
  });

  final DateTime date;
  final int total;
  final int expired;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.primary,
        borderRadius: const BorderRadius.only(
          bottomLeft: Radius.circular(16),
          bottomRight: Radius.circular(16),
        ),
      ),
      padding: const EdgeInsets.all(16.0),
      width: double.infinity,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          CommonText(
            text: date.toYYYYMMDD(),
            style: CommonTextStyle.textStyleLarge(
                color: Theme.of(context).colorScheme.onPrimary),
          ),
          const SizedBox(height: 8),
          Row(
            children: [
              CommonText(
                text: '${AppString.homeScreenTotal.getL10n(context)}$total',
                style: CommonTextStyle.textStyle(
                    color: Theme.of(context).colorScheme.onPrimary),
              ),
              const SizedBox(width: 16),
              CommonText(
                text: '${AppString.homeScreenExpired.getL10n(context)}$expired',
                style: CommonTextStyle.textStyle(
                    color: Theme.of(context).colorScheme.onPrimary),
              ),
            ],
          )
        ],
      ),
    );
  }
}
