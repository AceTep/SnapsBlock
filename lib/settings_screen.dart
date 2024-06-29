import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class SettingsScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvisder>(context, listen: false);

    return Scaffold(
      appBar: AppBar(
        title: Text('Settings'),
      ),
      body: Center(
        child: Switch(
          value: themeProvider.darkMode,
          onChanged: (value) {
            themeProvider.toggleDarkMode(value);
          },
          activeColor: Colors.green,
          inactiveThumbColor: Colors.grey,
        ),
      ),
    );
  }
}
