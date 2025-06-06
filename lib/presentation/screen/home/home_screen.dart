import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:food_deadline/presentation/blocs/stuff/stuff_bloc.dart';

import 'widgets/stuff_deadline_card_item.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<StuffBloc, StuffState>(
      builder: (context, state) {
        final stuffBloc = context.read<StuffBloc>();
        if (state is StuffSuccess) {
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
                      title: stuff.name,
                      deadline: stuff.deadline.toString(),
                      onDelete: () {
                        stuffBloc.add(StuffDeleteEvent(stuff: stuff));
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
        } else if (state is StuffLoading) {
          return const Center(
            child: CircularProgressIndicator(),
          );
        }

        return const SizedBox.shrink();
      },
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
