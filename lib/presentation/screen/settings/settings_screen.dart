import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:food_deadline/presentation/blocs/app_settings/app_settings_bloc.dart';
import 'package:food_deadline/presentation/widgets/common_text.dart';
import 'package:food_deadline/presentation/widgets/fd_card.dart';

part 'widgets/setting_theme_widget.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  State<SettingsScreen> createState() => _SettingScreenState();
}

class _SettingScreenState extends State<SettingsScreen> {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(24.0),
      child: Column(
        children: [
          _SettingThemeWidget(),
        ],
      ),
    );
  }
}
