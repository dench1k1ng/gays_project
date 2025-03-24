import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:soz_alem/models/category_model.dart';
import 'package:soz_alem/models/sound_button.dart';
import 'package:soz_alem/providers/queue_provider.dart';
import '../services/api_service.dart';
import 'category_screen.dart';
import 'settings_screen.dart'; // Ensure this screen exists

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  late Future<List<Category>> _categoriesFuture;
  List<Category> _filteredCategories = [];
  bool _isSearching = false;
  TextEditingController _searchController = TextEditingController();
  int _selectedIndex = 0; // Tracks the selected tab

  @override
  void initState() {
    super.initState();
    _categoriesFuture = ApiService().fetchCategoriesFromButtons();
    _searchController.addListener(_onSearchChanged);
  }

  void _onSearchChanged() {
    setState(() {
      _isSearching = _searchController.text.isNotEmpty;
    });
  }

  Future<void> _playQueue() async {
    final queue = context.read<QueueProvider>().queue;
    if (queue.isEmpty) return;

    final AudioPlayer _audioPlayer = AudioPlayer();
    for (SoundButton button in List.from(queue)) {
      await _audioPlayer.play(UrlSource(button.audio));
      await _audioPlayer.onPlayerComplete.first;
    }
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  // **Handles navigation when a tab is selected**
  void _onTabSelected(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  Widget _buildQueueBar() {
    final queue = context.watch<QueueProvider>().queue;

    if (queue.isEmpty) return SizedBox.shrink();

    return Column(
      children: [
        Container(
          height: 100,
          padding: const EdgeInsets.all(8),
          child: ListView(
            scrollDirection: Axis.horizontal,
            children: queue.map((btn) {
              return Padding(
                padding: const EdgeInsets.symmetric(horizontal: 4),
                child: Chip(label: Text(btn.title)),
              );
            }).toList(),
          ),
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            IconButton(
              icon: Icon(Icons.play_arrow),
              onPressed: _playQueue,
              tooltip: "Играть очередь",
            ),
            IconButton(
              icon: Icon(Icons.clear),
              onPressed: () => context.read<QueueProvider>().clearQueue(),
              tooltip: "Очистить очередь",
            ),
          ],
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      appBar: AppBar(
        title: _isSearching
            ? TextField(
                controller: _searchController,
                autofocus: true,
                decoration: InputDecoration(
                  hintText: "Поиск категории...",
                  border: InputBorder.none,
                ),
              )
            : Text("Soz Alem"),
        actions: [
          IconButton(
            icon: Icon(_isSearching ? Icons.clear : Icons.search),
            onPressed: () {
              setState(() {
                if (_isSearching) {
                  _searchController.clear();
                } else {
                  _isSearching = true;
                }
              });
            },
          ),
        ],
      ),
      body: _selectedIndex == 0
          ? Column(
              children: [
                _buildQueueBar(), // 👈 сюда вставляем очередь
                Expanded(
                    child: _buildCategoriesGrid(
                        isDarkMode)), // или _buildCategoriesGrid
              ],
            )
          : _selectedIndex == 1
              ? _buildCategoriesGrid(isDarkMode)
              : SettingsScreen(),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _selectedIndex,
        onTap: _onTabSelected,
        backgroundColor: isDarkMode ? Colors.grey[900] : Colors.white,
        selectedItemColor: isDarkMode ? Colors.yellow : Colors.blue,
        unselectedItemColor: Colors.grey,
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Главная',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.settings),
            label: 'Настройки',
          ),
        ],
      ),
    );
  }

  // **Category Grid UI**
  Widget _buildCategoriesGrid(bool isDarkMode) {
    final isPortrait =
        MediaQuery.of(context).orientation == Orientation.portrait;
    final crossAxisCount = isPortrait ? 2 : 4;

    return FutureBuilder<List<Category>>(
      future: _categoriesFuture,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        } else if (snapshot.hasError) {
          return Center(child: Text("Ошибка: ${snapshot.error}"));
        } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
          return const Center(child: Text("Нет доступных категорий"));
        }

        List<Category> categories = snapshot.data!;
        if (_isSearching) {
          categories = categories
              .where((category) => category.name
                  .toLowerCase()
                  .contains(_searchController.text.toLowerCase()))
              .toList();
        }

        return Padding(
          padding: const EdgeInsets.all(10),
          child: GridView.builder(
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: crossAxisCount,
              crossAxisSpacing: 10,
              mainAxisSpacing: 10,
              childAspectRatio: 0.9,
            ),
            itemCount: categories.length,
            itemBuilder: (context, index) {
              return _buildCategoryCard(categories[index], isDarkMode);
            },
          ),
        );
      },
    );
  }

  // **Category Card UI**
  Widget _buildCategoryCard(Category category, bool isDarkMode) {
    String imagePath;
    String displayName;

    // **Manually assign images and text based on category.id or category.name**
    switch (category.id) {
      case 1:
        imagePath = 'assets/png/food.png';
        displayName = 'Еда';
        break;
      case 2:
        imagePath = 'assets/png/clothes.png';
        displayName = 'Одежда';
        break;
      case 3:
        imagePath = 'assets/png/transport.png';
        displayName = 'Транспорт';
        break;
      case 4:
        imagePath = 'assets/png/animals.png';
        displayName = 'Животные';
        break;
      case 5:
        imagePath = 'assets/png/furniture.png';
        displayName = 'Мебель';
        break;
      case 7:
        imagePath = 'assets/png/stationery.png';
        displayName = 'Канцелярия';
        break;
      case 8:
        imagePath = 'assets/png/stars.png';
        displayName = 'Звёзды';
        break;
      case 10:
        imagePath = 'assets/png/activities.png';
        displayName = 'Деятельность';
        break;
      case 11:
        imagePath = 'assets/png/places.png';
        displayName = 'Места';
        break;
      case 12:
        imagePath = 'assets/png/emotions.png';
        displayName = 'Эмоции';
        break;
      case 13:
        imagePath = 'assets/png/pain.png';
        displayName = 'Боль';
        break;
      case 14:
        imagePath = 'assets/png/things.png';
        displayName = 'Вещи';
        break;
      default:
        imagePath = 'assets/png/default_category.png'; // Default image
        displayName = category.name; // Use original category name if not listed
        break;
    }

    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
              builder: (context) => CategoryScreen(category: category)),
        );
      },
      child: Card(
        elevation: 4,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        child: Stack(
          children: [
            // **Background Image**
            ClipRRect(
              borderRadius: BorderRadius.circular(12),
              child: Image.asset(
                imagePath,
                width: double.infinity,
                height: double.infinity,
                fit: BoxFit.cover,
              ),
            ),
            // **Overlay with Text**
            Container(
              decoration: BoxDecoration(
                color: Colors.black.withOpacity(0.5),
                borderRadius: BorderRadius.circular(12),
              ),
              alignment: Alignment.center,
              child: Text(
                displayName,
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
                textAlign: TextAlign.center,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
