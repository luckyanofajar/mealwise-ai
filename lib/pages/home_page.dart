import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:firebase_auth/firebase_auth.dart';

import '../models/food_model.dart';
import '../providers/food_provider.dart';
import '../services/auth_service.dart';
import '../services/websocket_service.dart';
import '../services/local_notif_service.dart';
import 'detail_page.dart';
import 'login_page.dart';
import 'add_food_page.dart';
import 'edit_food_page.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final user = FirebaseAuth.instance.currentUser;
  final TextEditingController budgetController = TextEditingController();

  int? _activeBudget;
  bool _isLoading = false;
  String searchQuery = '';
  int _currentTab = 0;

  @override
  void initState() {
    super.initState();
    Future.microtask(() {
      Provider.of<FoodProvider>(context, listen: false).fetchFoods();
    });
  }

  @override
  void dispose() {
    budgetController.dispose();
    super.dispose();
  }

  Future<void> _recommendByBudget() async {
    final text = budgetController.text.trim();
    if (text.isEmpty) {
      _showSnack('Masukkan budget dulu bro! 😅');
      return;
    }
    final budget = int.tryParse(text.replaceAll('.', '').replaceAll(',', ''));
    if (budget == null || budget <= 0) {
      _showSnack('Budget harus angka valid bro! 🙏');
      return;
    }
    setState(() {
      _isLoading = true;
      _activeBudget = budget;
    });
    await Provider.of<FoodProvider>(context, listen: false).fetchFoods();
    setState(() => _isLoading = false);
  }

  void _clearBudget() {
    budgetController.clear();
    setState(() => _activeBudget = null);
  }

  void _showSnack(String msg) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(msg),
        behavior: SnackBarBehavior.floating,
        backgroundColor: Colors.orange,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<FoodProvider>(context);

    var sourceFoods = _currentTab == 0 ? provider.foods : provider.favoriteFoods;

    var budgetFoods = _activeBudget == null
        ? sourceFoods
        : sourceFoods.where((f) => f.price <= _activeBudget!).toList();

    final displayFoods = budgetFoods.where((food) {
      return food.name.toLowerCase().contains(searchQuery.toLowerCase());
    }).toList();

    return Scaffold(
      backgroundColor: const Color(0xff161622),
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: Text(
          _currentTab == 0 ? 'MealWise AI' : 'Favorit Saya',
          style: GoogleFonts.poppins(
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
        actions: [
          IconButton(
            onPressed: () async {
              await AuthService().logout();
              if (mounted) {
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(builder: (_) => const LoginPage()),
                );
              }
            },
            icon: const Icon(Icons.logout, color: Colors.white),
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Profile
            Row(
              children: [
                CircleAvatar(
                  radius: 28,
                  backgroundImage: user?.photoURL != null
                      ? NetworkImage(user!.photoURL!)
                      : null,
                  child: user?.photoURL == null
                      ? const Icon(Icons.person, color: Colors.white)
                      : null,
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Halo, ${user?.displayName ?? "Pengguna"} 👋',
                        style: GoogleFonts.poppins(
                          color: Colors.white,
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      if (_activeBudget != null)
                        Text(
                          'Budget aktif: Rp $_activeBudget',
                          style: GoogleFonts.poppins(
                            color: Colors.orange,
                            fontSize: 12,
                          ),
                        ),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 6),
            Text(
              'Masukkan budgetmu, biar MealWise AI yang cariin menu terbaik 😎',
              style: GoogleFonts.poppins(color: Colors.white60),
            ),
            const SizedBox(height: 25),
            // Budget
            TextField(
              controller: budgetController,
              keyboardType: TextInputType.number,
              style: const TextStyle(color: Colors.white),
              decoration: InputDecoration(
                hintText: 'Masukkan budget makanan',
                hintStyle: const TextStyle(color: Colors.white54),
                prefixIcon: const Icon(Icons.wallet, color: Colors.orange),
                suffixIcon: _activeBudget != null
                    ? IconButton(
                        icon: const Icon(Icons.clear, color: Colors.white54),
                        onPressed: _clearBudget,
                      )
                    : null,
                filled: true,
                fillColor: Colors.white10,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(18),
                  borderSide: BorderSide.none,
                ),
              ),
            ),
            const SizedBox(height: 12),
            // Tombol Rekomendasi
            SizedBox(
              width: double.infinity,
              height: 50,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.orange,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(18),
                  ),
                ),
                onPressed: _isLoading ? null : _recommendByBudget,
                child: _isLoading
                    ? const SizedBox(
                        width: 20,
                        height: 20,
                        child: CircularProgressIndicator(
                          color: Colors.black,
                          strokeWidth: 2,
                        ),
                      )
                    : Text(
                        'REKOMENDASIKAN MAKANAN',
                        style: GoogleFonts.poppins(
                          fontWeight: FontWeight.bold,
                          color: Colors.black,
                        ),
                      ),
              ),
            ),
            const SizedBox(height: 12),
            // Search
            TextField(
              onChanged: (value) => setState(() => searchQuery = value),
              style: const TextStyle(color: Colors.white),
              decoration: InputDecoration(
                hintText: 'Cari makanan...',
                hintStyle: const TextStyle(color: Colors.white54),
                prefixIcon: const Icon(Icons.search, color: Colors.orange),
                filled: true,
                fillColor: Colors.white10,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(18),
                  borderSide: BorderSide.none,
                ),
              ),
            ),
            const SizedBox(height: 12),
            // Statistik
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Colors.white10,
                borderRadius: BorderRadius.circular(18),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  _statItem('${provider.foods.length}', 'Total Menu'),
                  _statItem(
                    'Rp ${provider.foods.isEmpty ? 0 : provider.foods.map((e) => e.price).reduce((a, b) => a < b ? a : b)}',
                    'Termurah',
                  ),
                  _statItem(
                    'Rp ${provider.foods.isEmpty ? 0 : provider.foods.map((e) => e.price).reduce((a, b) => a > b ? a : b)}',
                    'Termahal',
                  ),
                ],
              ),
            ),
            const SizedBox(height: 12),
            // Counter
            if (_activeBudget != null)
              Padding(
                padding: const EdgeInsets.only(bottom: 8),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      '${displayFoods.length} menu cocok',
                      style: GoogleFonts.poppins(
                        color: Colors.white70,
                        fontSize: 14,
                      ),
                    ),
                    Text(
                      'Max: Rp $_activeBudget',
                      style: GoogleFonts.poppins(
                        color: Colors.orange,
                        fontSize: 12,
                      ),
                    ),
                  ],
                ),
              ),
            // List Makanan
            Expanded(
              child: displayFoods.isEmpty
                  ? _buildEmptyState()
                  : ListView.builder(
                      itemCount: displayFoods.length,
                      itemBuilder: (context, index) {
                        final food = displayFoods[index];
                        return _buildFoodCard(food, provider);
                      },
                    ),
            ),
            // WebSocket + Notif
            Consumer<WebSocketService>(
              builder: (context, ws, child) {
                return Container(
                  margin: const EdgeInsets.only(top: 12),
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: const Color(0xff1e1e2e),
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(
                      color: ws.isConnected ? Colors.green : Colors.red,
                      width: 2,
                    ),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            '🔌 WebSocket',
                            style: GoogleFonts.poppins(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                              fontSize: 16,
                            ),
                          ),
                          Container(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 12, vertical: 6),
                            decoration: BoxDecoration(
                              color: ws.isConnected ? Colors.green : Colors.red,
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: Text(
                              ws.isConnected ? 'ON' : 'OFF',
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 12,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 8),
                      Text(
                        ws.status,
                        style: GoogleFonts.poppins(
                          color: Colors.white60,
                          fontSize: 12,
                        ),
                      ),
                      const SizedBox(height: 12),
                      Row(
                        children: [
                          Expanded(
                            child: ElevatedButton(
                              onPressed:
                                  ws.isConnected ? null : () => ws.connect(),
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.green,
                                disabledBackgroundColor: Colors.grey,
                              ),
                              child: const Text('Connect'),
                            ),
                          ),
                          const SizedBox(width: 8),
                          Expanded(
                            child: ElevatedButton(
                              onPressed: ws.isConnected
                                  ? () => ws.disconnect()
                                  : null,
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.red,
                                disabledBackgroundColor: Colors.grey,
                              ),
                              child: const Text('Disconnect'),
                            ),
                          ),
                          const SizedBox(width: 8),
                          Expanded(
                            child: ElevatedButton(
                              onPressed: ws.isConnected
                                  ? () => ws.send('Hello!')
                                  : null,
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.blue,
                                disabledBackgroundColor: Colors.grey,
                              ),
                              child: const Text('Send'),
                            ),
                          ),
                          const SizedBox(width: 8),
                          Expanded(
                            child: ElevatedButton(
                              onPressed: () {
                                LocalNotifService.show(
                                  title: 'MealWise AI 🔥',
                                  body: 'Ada menu baru nih bro!',
                                );
                              },
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.purple,
                              ),
                              child: const Text('Notif'),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                );
              },
            ),
          ],
        ),
      ),
      floatingActionButton: _currentTab == 0
          ? FloatingActionButton(
              backgroundColor: Colors.orange,
              child: const Icon(Icons.add, color: Colors.black),
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => const AddFoodPage()),
                );
              },
            )
          : null,
      bottomNavigationBar: BottomNavigationBar(
        backgroundColor: const Color(0xff1e1e2e),
        selectedItemColor: Colors.orange,
        unselectedItemColor: Colors.white54,
        currentIndex: _currentTab,
        onTap: (index) => setState(() => _currentTab = index),
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.restaurant_menu),
            label: 'Semua',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.favorite),
            label: 'Favorit',
          ),
        ],
      ),
    );
  }

  Widget _statItem(String value, String label) {
    return Column(
      children: [
        Text(
          value,
          style: const TextStyle(
            color: Colors.orange,
            fontSize: 16,
            fontWeight: FontWeight.bold,
          ),
        ),
        Text(
          label,
          style: const TextStyle(color: Colors.white, fontSize: 12),
        ),
      ],
    );
  }

  Widget _buildFoodCard(FoodModel food, FoodProvider provider) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (_) => DetailPage(food: food)),
        );
      },
      child: Container(
        margin: const EdgeInsets.only(bottom: 14),
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: Colors.white10,
          borderRadius: BorderRadius.circular(22),
        ),
        child: Row(
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(18),
              child: Image.network(
                food.image,
                width: 85,
                height: 85,
                fit: BoxFit.cover,
                errorBuilder: (context, error, stackTrace) {
                  return Container(
                    width: 85,
                    height: 85,
                    color: Colors.white70,
                    child: const Icon(Icons.fastfood, color: Colors.orange),
                  );
                },
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    food.name,
                    style: GoogleFonts.poppins(
                      color: Colors.white,
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    '💰 Rp ${food.price}',
                    style: GoogleFonts.poppins(
                      color: Colors.orange,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    '⭐ ${food.rating}',
                    style: const TextStyle(color: Colors.white70),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    food.description,
                    style: const TextStyle(color: Colors.white60),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ),
            ),
            Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                if (_currentTab == 0)
                  IconButton(
                    onPressed: () => provider.toggleFavorite(food),
                    icon: Icon(
                      food.isFavorite
                          ? Icons.favorite
                          : Icons.favorite_border,
                      color: food.isFavorite ? Colors.red : Colors.white54,
                    ),
                  ),
                IconButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => EditFoodPage(food: food),
                      ),
                    );
                  },
                  icon: const Icon(Icons.edit, color: Colors.blue, size: 20),
                ),
                IconButton(
                  onPressed: () => _confirmDelete(food, provider),
                  icon: const Icon(Icons.delete, color: Colors.red, size: 20),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  void _confirmDelete(FoodModel food, FoodProvider provider) {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text("Hapus Data"),
        content: const Text("Yakin ingin menghapus makanan ini?"),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text("Batal"),
          ),
          TextButton(
            onPressed: () async {
              Navigator.pop(context);
              await provider.deleteFood(food.id!);
            },
            child: const Text(
              "Hapus",
              style: TextStyle(color: Colors.red),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            _currentTab == 1 ? Icons.favorite_border : Icons.search_off,
            size: 64,
            color: Colors.white24,
          ),
          const SizedBox(height: 16),
          Text(
            _currentTab == 1
                ? 'Belum ada makanan favorit 😢'
                : 'Waduh, ga ada menu yang cocok 😢',
            textAlign: TextAlign.center,
            style: GoogleFonts.poppins(
              color: Colors.white60,
              fontSize: 16,
            ),
          ),
          const SizedBox(height: 8),
          if (_activeBudget != null || _currentTab == 1)
            TextButton(
              onPressed: _currentTab == 1
                  ? () => setState(() => _currentTab = 0)
                  : _clearBudget,
              child: Text(
                _currentTab == 1 ? 'Jelajahi menu' : 'Coba budget lain',
                style: GoogleFonts.poppins(color: Colors.orange),
              ),
            ),
        ],
      ),
    );
  }
}