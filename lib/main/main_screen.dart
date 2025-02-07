import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:food_deadline/blocs/core/stuff/stuff_bloc.dart';
import 'package:food_deadline/edit_stuff/edit_stuff_main_screen.dart';
import 'package:food_deadline/extension/datetime_extension.dart';
import 'package:food_deadline/home/home_screen.dart';
import 'package:food_deadline/blocs/ui/main/main_bloc.dart';
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
  late MainBloc mainBloc;
  var _currentIndex = 0;
  final now = DateTime.now();

  @override
  void initState() {
    mainBloc = BlocProvider.of<MainBloc>(context);
    mainBloc.add(MainInitialEvent());
    super.initState();
  }

  void onItemTapped(int index) {
    setState(() {
      _currentIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(15),
        child: AppBar(
          backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        ),
      ),
      body: BlocBuilder<MainBloc, MainState>(
        builder: (context, state) {
          switch(state) {
            case MainLoading():
              return const Center(
                child: CircularProgressIndicator(),
              );
            case MainSuccess():
              final expired = state.stuffs.where((stuff) => stuff.deadline < DateTime.now().millisecondsSinceEpoch).length;
              return Column(
                children: [
                  if (_currentIndex == MainBottomNavType.home.index)
                    _Header(
                      date: now,
                      total: state.stuffs.length,
                      expired: expired,
                    ),
                  _buildScreen(_currentIndex),
                ],
              );
          }
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
      floatingActionButton: FloatingActionButton(
        shape: const CircleBorder(),
        onPressed: () async {
          final result = await Navigator.of(context).push(
            MaterialPageRoute(
              builder: (newContext) => BlocProvider.value(
                value: StuffBloc(),
                child: const EditStuffMainScreen(),
              ),
            ),
          );

          if (result != null) {
            mainBloc.add(MainInitialEvent());
          }
        },
        child: const Icon(Icons.add),
      ),
    );
  }

  Widget _buildScreen(int index) {
    switch (MainBottomNavType.values[index]) {
      case MainBottomNavType.home:
        return BlocProvider(
          create: (context) => StuffBloc()..add(StuffInitialEvent()),
          child: const HomeScreen(),
        );
      case MainBottomNavType.settings:
        return const SizedBox(); // 設定畫面
    }
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
