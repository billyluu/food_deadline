import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:food_deadline/core/constants/app_string.dart';
import 'package:food_deadline/core/realm/models/expirable_item.dart';
import 'package:food_deadline/features/home/bloc/expirable_Item/expirable_bloc.dart';
import 'package:food_deadline/shared/widgets/shared_close_icon_button.dart';
import 'package:food_deadline/shared/widgets/shared_send_button.dart';
import 'package:intl/intl.dart';

class EditExpirableItemDialog extends StatefulWidget {
  const EditExpirableItemDialog({super.key});

  @override
  State<EditExpirableItemDialog> createState() => _EditExpirableItemDialogState();
}

class _EditExpirableItemDialogState extends State<EditExpirableItemDialog> {
  final _expirableItemTextController = TextEditingController();
  DateTime _date = DateTime.now();

  void updateDate(DateTime newDate) {
    setState(() => _date = newDate);
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      contentPadding: const EdgeInsets.symmetric(vertical: 16.0, horizontal: 24),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              SharedCloseIconButton(
                onPressed: () => Navigator.pop(context),
              )
            ],
          ),
          TextField(
            keyboardType: TextInputType.text,
            controller: _expirableItemTextController,
            decoration: InputDecoration(
              label: Text(AppString.editExpirableItemScreenName.getI18n(context)),
              hintText: AppString.editExpirableItemScreenInputPlaceHolder.getI18n(context),
              hintStyle: TextStyle(
                color: Theme.of(context).hintColor,
                fontSize: 12,
              ),
            ),
          ),
          const SizedBox(height: 36),
          DatePickerField(
            initialDate: DateTime.now(),
            onDateChanged: (date) {
              _date = date;
            },
          ),
          const SizedBox(height: 72),
        ],
      ),
      actions: [
        SharedSendButton(
          onPressed: () {
            if (_expirableItemTextController.text.isNotEmpty) {
              context.read<ExpirableItemBloc>().add(
                    ExpirableItemAddEvent(
                      expirableItem: ExpirableItem.schema.newItem(
                        _expirableItemTextController.text,
                        _date.millisecondsSinceEpoch,
                      ),
                    ),
                  );
            }
            Navigator.pop(context);
          },
        ),
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
