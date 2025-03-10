import 'package:flutter/material.dart';
import 'package:soz_alem/widgets/sound_button.dart';
import '../services/api_service.dart';
import '../models/sound_button.dart';
import 'settings_screen.dart';

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _selectedIndex = 0;
  late Future<List<SoundButton>> _buttonsFuture;

  @override
  void initState() {
    super.initState();
    _buttonsFuture = ApiService().fetchButtons();
  }

  @override
  Widget build(BuildContext context) {
    final isPortrait =
        MediaQuery.of(context).orientation == Orientation.portrait;
    final crossAxisCount =
        isPortrait ? 2 : 5; // ✅ 2 buttons in portrait, 5 in landscape

    return Scaffold(
      appBar: AppBar(title: const Text("Soz Alem")),
      body: _selectedIndex == 0
          ? FutureBuilder<List<SoundButton>>(
              future: _buttonsFuture,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                } else if (snapshot.hasError) {
                  return Center(child: Text("Ошибка: ${snapshot.error}"));
                } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                  return const Center(child: Text("Нет доступных кнопок"));
                }

                // Фильтруем кнопки без изображения
                List<SoundButton> validButtons = snapshot.data!
                    .where((btn) => btn.image.isNotEmpty)
                    .toList();

                if (validButtons.isEmpty) {
                  return const Center(
                      child: Text("Нет кнопок с изображениями"));
                }

                return GridView.builder(
                  padding: const EdgeInsets.all(10),
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: crossAxisCount,
                    crossAxisSpacing: 10,
                    mainAxisSpacing: 10,
                    childAspectRatio: 1,
                  ),
                  itemCount: validButtons.length,
                  itemBuilder: (context, index) {
                    return SoundButtonWidget(button: validButtons[index]);
                  },
                );
              },
            )
          : SettingsScreen(),
      bottomNavigationBar: NavigationBar(
        onDestinationSelected: (int index) {
          if (index == 1) {
            // ✅ Navigate to SettingsScreen as a separate page
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => SettingsScreen()),
            );
          }
        },
        selectedIndex: _selectedIndex,
        destinations: const <Widget>[
          NavigationDestination(
            selectedIcon: Icon(Icons.home),
            icon: Icon(Icons.home_outlined),
            label: 'Главная',
          ),
          NavigationDestination(
            selectedIcon: Icon(Icons.settings),
            icon: Icon(Icons.settings_outlined),
            label: 'Настройки',
          ),
        ],
      ),
    );
  }
}
