import 'package:flutter/material.dart';
import 'package:soz_alem/models/category_model.dart';
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
          ? _buildCategoriesGrid(isDarkMode) // Home Screen (Categories)
          : SettingsScreen(), // Settings Screen (Replace with your settings page)
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
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          PageRouteBuilder(
            transitionDuration: Duration(milliseconds: 300),
            pageBuilder: (_, __, ___) => CategoryScreen(category: category),
            transitionsBuilder: (_, animation, __, child) {
              return FadeTransition(opacity: animation, child: child);
            },
          ),
        );
      },
      child: Card(
        color: isDarkMode ? Colors.grey[850] : Colors.white,
        elevation: 4,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.music_note,
                size: 50, color: isDarkMode ? Colors.yellow : Colors.blue),
            SizedBox(height: 10),
            Text(
              category.name,
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: isDarkMode ? Colors.white : Colors.black87,
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}



/*Widget _buildCategoryCard(Category category, bool isDarkMode) {
  String imagePath;
  String displayName;

  // **Manually assign images and text based on category.id or category.name**
  switch (category.id) {
    case 1:
      imagePath = 'assets/animals.png';
      displayName = 'Животные';
      break;
    case 2:
      imagePath = 'assets/music.png';
      displayName = 'Музыка';
      break;
    case 3:
      imagePath = 'assets/sports.png';
      displayName = 'Спорт';
      break;
    case 4:
      imagePath = 'assets/nature.png';
      displayName = 'Природа';
      break;
    case 5:
      imagePath = 'assets/vehicles.png';
      displayName = 'Транспорт';
      break;
    default:
      imagePath = 'assets/default_category.png'; // Default image
      displayName = category.name; // Use original category name
      break;
  }

  return GestureDetector(
    onTap: () {
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => CategoryScreen(category: category)),
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
*/