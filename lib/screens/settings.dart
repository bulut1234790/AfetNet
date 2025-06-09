import 'package:flutter/material.dart';

class SettingsScreen extends StatefulWidget {
  final bool isDarkMode;
  final bool notificationsEnabled;
  final Function(bool) onThemeChanged;
  final Function(bool) onNotificationsChanged;

  const SettingsScreen({
    Key? key,
    required this.isDarkMode,
    required this.notificationsEnabled,
    required this.onThemeChanged,
    required this.onNotificationsChanged,
  }) : super(key: key);

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  late bool _isDarkMode;
  late bool _notificationsEnabled;

  @override
  void initState() {
    super.initState();
    _isDarkMode = widget.isDarkMode;
    _notificationsEnabled = widget.notificationsEnabled;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Ayarlar")),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            const Align(
              alignment: Alignment.centerLeft,
              child: Text(
                "Tema Seçimi",
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
            ),
            const SizedBox(height: 12),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                ElevatedButton.icon(
                  style: ElevatedButton.styleFrom(
                    backgroundColor:
                        !_isDarkMode ? Colors.orange : Colors.grey[300],
                    foregroundColor: Colors.black87,
                    padding: const EdgeInsets.symmetric(
                      horizontal: 20,
                      vertical: 12,
                    ),
                  ),
                  icon: const Icon(Icons.wb_sunny),
                  label: const Text("Açık Tema"),
                  onPressed: () {
                    setState(() => _isDarkMode = false);
                    widget.onThemeChanged(false);
                  },
                ),
                ElevatedButton.icon(
                  style: ElevatedButton.styleFrom(
                    backgroundColor:
                        _isDarkMode ? Colors.indigo : Colors.grey[300],
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(
                      horizontal: 20,
                      vertical: 12,
                    ),
                  ),
                  icon: const Icon(Icons.nightlight_round),
                  label: const Text("Karanlık Tema"),
                  onPressed: () {
                    setState(() => _isDarkMode = true);
                    widget.onThemeChanged(true);
                  },
                ),
              ],
            ),
            const SizedBox(height: 30),
            SwitchListTile(
              title: const Text("Bildirimleri Aç"),
              value: _notificationsEnabled,
              onChanged: (value) {
                setState(() {
                  _notificationsEnabled = value;
                });
                widget.onNotificationsChanged(value);
              },
              secondary: const Icon(Icons.notifications_active),
            ),
          ],
        ),
      ),
    );
  }
}
