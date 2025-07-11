import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:food_deadline/core/constants/app_string.dart';
import 'package:food_deadline/core/extension/datetime_extension.dart';
import 'package:food_deadline/features/home/bloc/expirable_Item/expirable_bloc.dart';
import 'package:food_deadline/features/home/widgets/expirable_item_card.dart';
import 'package:food_deadline/shared/widgets/error_widget.dart';
import 'package:food_deadline/shared/widgets/shared_common_text.dart';

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
    return BlocConsumer<ExpirableItemBloc, ExpirableItemState>(
      listener: (context, state) {
        // 當有錯誤時顯示 SnackBar
        if (state is ExpirableItemError) {
          AppErrorSnackBar.show(context, state.exception);
        }
      },
      builder: (context, state) {
        final expirableItemBloc = context.read<ExpirableItemBloc>();
        
        switch (state) {
          case ExpirableItemSuccess():
            final expirableItems = state.expirableItem;
            final expired = expirableItems
                .where((element) => element.deadline < DateTime.now().millisecondsSinceEpoch)
                .length;
            
            return Column(
              children: [
                _Header(
                  date: DateTime.now(),
                  total: expirableItems.length,
                  expired: expired,
                ),
                Expanded(
                  child: expirableItems.isEmpty 
                    ? _Empty() 
                    : _BuildItemList(expirableItems: expirableItems, expirableItemBloc: expirableItemBloc),
                ),
              ],
            );
            
          case ExpirableItemError():
            // 如果有錯誤但還有資料，顯示資料
            if (state.expirableItem != null && state.expirableItem!.isNotEmpty) {
              return _BuildItemList(expirableItems: state.expirableItem!, expirableItemBloc: expirableItemBloc);
            }
            // 沒有資料時顯示錯誤畫面
            return AppErrorWidget(
              exception: state.exception,
              onRetry: () => expirableItemBloc.add(ExpirableItemInitialEvent()),
            );
            
          case ExpirableItemLoading():
            // 載入中但有快取資料
            if (state.expirableItem != null) {
              return _BuildItemList(expirableItems: state.expirableItem!, expirableItemBloc: expirableItemBloc);
            }
            return const Center(child: CircularProgressIndicator());
        }
      },
    );
  }
}

class _BuildItemList extends StatelessWidget {
  final List expirableItems;
  final ExpirableItemBloc expirableItemBloc;

  const _BuildItemList({
    required this.expirableItems,
    required this.expirableItemBloc,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(12.0),
      child: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            for (final expirableItem in expirableItems) ...[
              ExpiredItemCard(
                title: expirableItem.name,
                deadline: expirableItem.deadline.toString(),
                disabled: expirableItem.isExpired,
                onDelete: () => expirableItemBloc.add(ExpirableItemDeleteEvent(expirableItem: expirableItem)),
              ),
              if (expirableItem != expirableItems.last) ...[
                const SizedBox(height: 6.0),
              ]
            ]
          ],
        ),
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
          SharedCommonText(
            text: date.toYYYYMMDD(),
            style: CommonTextStyle.textStyleLarge(
                color: Theme.of(context).colorScheme.onPrimary),
          ),
          const SizedBox(height: 8),
          Row(
            children: [
              SharedCommonText(
                text: '${AppString.homeScreenTotal.getI18n(context)}$total',
                style: CommonTextStyle.textStyle(
                    color: Theme.of(context).colorScheme.onPrimary),
              ),
              const SizedBox(width: 16),
              SharedCommonText(
                text: '${AppString.homeScreenExpired.getI18n(context)}$expired',
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
