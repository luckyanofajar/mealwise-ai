import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/food_model.dart';
import '../services/api_service.dart';

class FoodProvider extends ChangeNotifier {
  List<FoodModel> foods = [];
  List<FoodModel> recommendations = [];
  
  // Simpan ID favorit di SharedPreferences
  List<int> _favoriteIds = [];
  static const String _favKey = 'favorite_food_ids';

  List<FoodModel> get favoriteFoods => 
      foods.where((f) => f.isFavorite).toList();

  FoodProvider() {
    _loadFavorites();
  }

  Future<void> _loadFavorites() async {
    final prefs = await SharedPreferences.getInstance();
    final favString = prefs.getString(_favKey);
    if (favString != null) {
      _favoriteIds = List<int>.from(jsonDecode(favString));
    }
  }

  Future<void> _saveFavorites() async {
    final prefs = await SharedPreferences.getInstance();
    _favoriteIds = foods
        .where((f) => f.isFavorite)
        .map((f) => f.id!)
        .toList();
    await prefs.setString(_favKey, jsonEncode(_favoriteIds));
  }

  Future<void> fetchFoods() async {
    foods = await ApiService().getFoods();
    
    // Apply favorites dari SharedPreferences
    for (var food in foods) {
      if (_favoriteIds.contains(food.id)) {
        food.isFavorite = true;
      }
    }
    
    notifyListeners();
  }

  void filterByBudget(int budget) {
    recommendations = foods.where((food) {
      return food.price <= budget;
    }).toList();
    notifyListeners();
  }

  Future<void> toggleFavorite(FoodModel food) async {
    food.isFavorite = !food.isFavorite;
    await _saveFavorites();
    notifyListeners();
  }

  Future<void> deleteFood(int id) async {
    await ApiService().deleteFood(id);
    await fetchFoods();
  }

  Future<void> updateFood({
    required int id,
    required String name,
    required int price,
    required String category,
    required String description,
    required String image,
    required double rating,
  }) async {
    await ApiService().updateFood(
      id: id,
      name: name,
      price: price,
      category: category,
      description: description,
      image: image,
      rating: rating,
    );
    await fetchFoods();
  }

  Future<bool> addFood({
    required String name,
    required int price,
    required String category,
    required String description,
    required String image,
    required double rating,
  }) async {
    final success = await ApiService().addFood(
      name: name,
      price: price,
      category: category,
      description: description,
      image: image,
      rating: rating,
    );
    if (success) await fetchFoods();
    return success;
  }
}