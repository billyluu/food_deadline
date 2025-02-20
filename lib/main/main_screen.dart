import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:food_deadline/blocs/core/stuff/stuff_bloc.dart';
import 'package:food_deadline/edit_stuff/edit_stuff_main_screen.dart';
import 'package:food_deadline/extension/datetime_extension.dart';
import 'package:food_deadline/home/home_screen.dart';
import 'package:food_deadline/realm/realm_helper.dart';
import 'package:food_deadline/widgets/CommonText.dart';

enum MainBottomNavType {
  home(
    title: 'Home',
    icon: Icons.home,
    screen: HomeScreen(),
  ),
  settings(
    title: 'Settings',
    icon: Icons.settings,
    screen: SizedBox(),
  ),
  ;

  const MainBottomNavType({
    required this.title,
    required this.icon,
    required this.screen,
  });

  final String title;
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
            backgroundColor: Theme.of(context).colorScheme.inversePrimary,
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
                        SizedBox(), // 設定畫面
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
          color: Theme.of(context).colorScheme.inversePrimary,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              for (var i = 0; i < MainBottomNavType.values.length; i++) ...[
                ElevatedButton.icon(
                  label: Text(MainBottomNavType.values[i].title),
                  style: ElevatedButton.styleFrom(
                    splashFactory: NoSplash.splashFactory,
                    backgroundColor: Colors.transparent,
                    shadowColor: Colors.transparent,
                  ),
                  onPressed: () => onItemTapped(i),
                  icon: Icon(MainBottomNavType.values[i].icon),
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
                await Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (_) => BlocProvider.value(
                      value: context.read<StuffBloc>(),
                      child: const EditStuffMainScreen(),
                    ),
                  ),
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
        color: Theme.of(context).colorScheme.inversePrimary,
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
          Text(
            date.toYYYYMMDD(),
            style: CommonTextStyle.textStyleLarge(),
          ),
          const SizedBox(height: 8),
          Row(
            children: [
              Text(
                '總數量：$total',
                style: CommonTextStyle.textStyle(),
              ),
              const SizedBox(width: 16),
              Text(
                '過期：$expired',
                style: CommonTextStyle.textStyle(),
              ),
            ],
          )
        ],
      ),
    );
  }
}
