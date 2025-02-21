import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:food_deadline/presentation/blocs/stuff/stuff_bloc.dart';
import 'package:food_deadline/realm/models/stuff.dart';

class EditStuffMainScreen extends StatefulWidget {
  const EditStuffMainScreen({super.key});

  @override
  State<EditStuffMainScreen> createState() => _EditStuffMainScreenState();
}

class _EditStuffMainScreenState extends State<EditStuffMainScreen> {
  final _stuffTextController = TextEditingController();
  DateTime _date = DateTime.now();

  void _showDialog(Widget child) {
    showCupertinoModalPopup<void>(
      context: context,
      builder: (BuildContext context) => Container(
        height: 216,
        padding: const EdgeInsets.only(top: 6.0),
        margin: EdgeInsets.only(
          bottom: MediaQuery.of(context).viewInsets.bottom,
        ),
        color: CupertinoColors.systemBackground.resolveFrom(context),
        child: SafeArea(
          top: false,
          child: child,
        ),
      ),
    );
  }

  void updateDate(DateTime newDate) {
    setState(() => _date = newDate);
  }

  @override
  Widget build(BuildContext context) {
    final bloc = context.read<StuffBloc>();
    return Scaffold(
      appBar: AppBar(
        foregroundColor: Theme.of(context).secondaryHeaderColor,
        title: Text(
          '新增物品',
          style: TextStyle(color: Theme.of(context).secondaryHeaderColor),
        ),
        backgroundColor: Theme.of(context).primaryColor,
      ),
      body: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          children: [
            TextField(
              keyboardType: TextInputType.text,
              controller: _stuffTextController,
              decoration: InputDecoration(
                label: const Text('物品名稱'),
                hintText: '請輸入物品名稱，上限30字',
                hintStyle: TextStyle(
                  color: Theme.of(context).hintColor,
                  fontSize: 12,
                ),
              ),
            ),
            const SizedBox(height: 24),
            GestureDetector(
              onTap: () {
                _showDialog(
                  CupertinoDatePicker(
                    dateOrder: DatePickerDateOrder.ymd,
                    mode: CupertinoDatePickerMode.date,
                    use24hFormat: true,
                    showDayOfWeek: true,
                    onDateTimeChanged: (newDate) => updateDate(newDate),
                  ),
                );
              },
              child: DecoratedBox(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(15.0),
                  border: Border.all(
                    color: Theme.of(context).disabledColor,
                    width: 1,
                  ),
                ),
                child: Padding(
                  padding: const EdgeInsets.symmetric(
                    vertical: 12,
                    horizontal: 16,
                  ),
                  child: Text(
                    '${_date.year} - ${_date.month} - ${_date.day}',
                    style: TextStyle(
                      fontSize: 24.0,
                      color: Theme.of(context).primaryColor,
                    ),
                  ),
                ),
              ),
            ),
            const SizedBox(height: 72),
            ElevatedButton(
              onPressed: () {
                if (_stuffTextController.text.isNotEmpty) {
                  bloc.add(
                    StuffAddEvent(
                      stuff: Stuff.schema.newStuff(
                        _stuffTextController.text,
                        _date.millisecondsSinceEpoch,
                      ),
                    ),
                  );
                }
                Navigator.pop(context);
              },
              child: const Text('送出'),
            )
          ],
        ),
      ),
    );
  }
}
