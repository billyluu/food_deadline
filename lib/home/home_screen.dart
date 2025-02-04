import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:food_deadline/edit_stuff/edit_stuff_main_screen.dart';
import 'package:food_deadline/home/home_bloc.dart';
import 'package:food_deadline/home/widgets/stuff_deadline_card_item.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key, required this.title});

  final String title;

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  late HomeBloc homeBloc;

  @override
  void initState() {
    homeBloc = BlocProvider.of<HomeBloc>(context);
    homeBloc.add(HomeInitialEvent());
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text(widget.title),
      ),
      body: BlocBuilder<HomeBloc, HomeState>(
        builder: (context, state) {
          if (state is HomeSuccess) {
            final stuffs = state.stuffs;

            if (stuffs.isEmpty) {
              return _Empty();
            }

            return Padding(
              padding: const EdgeInsets.all(12.0),
              child: SingleChildScrollView(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    for (final stuff in stuffs) ...[
                      StuffDeadlineCardItem(
                        color: Theme.of(context).primaryColorLight,
                        title: stuff.name,
                        deadline: stuff.deadline.toString(),
                        onDelete: () {
                          homeBloc.add(HomeDeleteEvent(stuff: stuff));
                        },
                      ),
                      if (stuff != stuffs.last)
                        const SizedBox(
                          height: 6.0,
                        )
                    ]
                  ],
                ),
              ),
            );
          } else if (state is HomeLoading) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }

          return const SizedBox.shrink();
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          final result = await Navigator.of(context).push(
            MaterialPageRoute(builder: (context) {
              return BlocProvider.value(
                value: context.read<HomeBloc>(),
                child: const EditStuffMainScreen(),
              );
            }),
          );

          if (result != null) {
            homeBloc.add(HomeInitialEvent());
          }
        },
        tooltip: 'Increment',
        child: const Icon(Icons.add),
      ),
    );
  }
}

class _Empty extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return const Center(
      child: Text('No data'),
    );
  }
}

class _Button extends StatefulWidget {
  @override
  State<_Button> createState() => _ButtonState();
}

class _ButtonState extends State<_Button> {
  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: () {},
      style: ElevatedButton.styleFrom(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        backgroundColor: Theme.of(context).primaryColor,
        foregroundColor: Theme.of(context).secondaryHeaderColor,
      ),
      child: const Text('Button_1'),
    );
  }
}
