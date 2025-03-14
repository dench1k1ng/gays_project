import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/settings_provider.dart';

class SettingsScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final settings = Provider.of<SettingsProvider>(context);

    return Scaffold(
      body: Column(
        children: [
          ListTile(
            title: const Text("Темный режим"),
            trailing: Switch(
              value: settings.themeMode == ThemeMode.dark,
              onChanged: (value) {
                settings.toggleTheme(value);
              },
            ),
          ),
          // ListTile(
          //   title: const Text("Language"),
          //   trailing: DropdownButton<String>(
          //     value: settings.locale.languageCode,
          //     onChanged: (String? newLanguage) {
          //       if (newLanguage != null) {
          //         settings.changeLanguage(newLanguage);
          //       }
          //     },
          //     items: const [
          //       DropdownMenuItem(value: "en", child: Text("English")),
          //       DropdownMenuItem(value: "ru", child: Text("Русский")),
          //     ],
          //   ),
          // ),
        ],
      ),
    );
  }
}
