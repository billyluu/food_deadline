import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:food_deadline/core/constants/app_string.dart';
import 'package:food_deadline/core/realm/models/expirable_item.dart';
import 'package:food_deadline/features/home/bloc/expirable_Item/expirable_bloc.dart';
import 'package:food_deadline/shared/widgets/common_text.dart';
import 'package:intl/intl.dart';

class EditExpirableItemDialog extends StatefulWidget {
  const EditExpirableItemDialog({super.key});

  @override
  State<EditExpirableItemDialog> createState() =>
      _EditExpirableItemDialogState();
}

class _EditExpirableItemDialogState extends State<EditExpirableItemDialog> {
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
    return AlertDialog(
      contentPadding: const EdgeInsets.all(16.0),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              CommonText(text: AppString.commonClose.getL10n(context)),
            ],
          ),
          TextField(
            keyboardType: TextInputType.text,
            controller: _stuffTextController,
            decoration: InputDecoration(
              label:
                  Text(AppString.editExpirableItemScreenName.getL10n(context)),
              hintText: AppString.editExpirableItemScreenInputPlaceHolder
                  .getL10n(context),
              hintStyle: TextStyle(
                color: Theme.of(context).hintColor,
                fontSize: 12,
              ),
            ),
          ),
          const SizedBox(height: 36),
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
            child: DatePickerField(
              initialDate: DateTime.now(),
              onDateChanged: (date) {
                print('新日期: $date');
              },
            ),
            // child: DecoratedBox(
            //   decoration: BoxDecoration(
            //     borderRadius: BorderRadius.circular(15.0),
            //     border: Border.all(
            //       color: Theme.of(context).disabledColor,
            //       width: 1,
            //     ),
            //   ),
            //   child: Padding(
            //     padding: const EdgeInsets.symmetric(
            //       vertical: 12,
            //       horizontal: 16,
            //     ),
            //     child: Text(
            //       '${_date.year} - ${_date.month} - ${_date.day}',
            //       style: TextStyle(
            //         fontSize: 24.0,
            //         color: Theme.of(context).primaryColor,
            //       ),
            //     ),
            //   ),
            // ),
          ),
          const SizedBox(height: 72),
        ],
      ),
      actions: [
        ElevatedButton(
          onPressed: () {
            if (_stuffTextController.text.isNotEmpty) {
              context.read<ExpirableItemBloc>().add(
                    ExpirableItemAddEvent(
                      expirableItem: ExpirableItem.schema.newStuff(
                        _stuffTextController.text,
                        _date.millisecondsSinceEpoch,
                      ),
                    ),
                  );
            }
            Navigator.pop(context);
          },
          child: Text(AppString.commonSend.getL10n(context)),
        )
      ],
    );
  }
}

class DatePickerField extends StatefulWidget {
  final DateTime initialDate;
  final void Function(DateTime)? onDateChanged;

  const DatePickerField({
    Key? key,
    required this.initialDate,
    this.onDateChanged,
  }) : super(key: key);

  @override
  State<DatePickerField> createState() => _DatePickerFieldState();
}

class _DatePickerFieldState extends State<DatePickerField> {
  late DateTime _selectedDate;

  @override
  void initState() {
    super.initState();
    _selectedDate = widget.initialDate;
  }

  Future<void> _pickDate() async {
    final picked = await showDatePicker(
      context: context,
      initialDate: _selectedDate,
      firstDate: DateTime(2000),
      lastDate: DateTime(2100),
    );
    if (picked != null) {
      setState(() => _selectedDate = picked);
      widget.onDateChanged?.call(picked);
    }
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: _pickDate,
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
        decoration: BoxDecoration(
          border: Border.all(color: Theme.of(context).dividerColor),
          borderRadius: BorderRadius.circular(8),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              DateFormat('yyyy-MM-dd').format(_selectedDate),
              style: Theme.of(context).textTheme.bodyLarge,
            ),
            const Icon(Icons.calendar_today, size: 20),
          ],
        ),
      ),
    );
  }
}