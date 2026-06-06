import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/food_model.dart';

class ApiService {
  // Ubah dari .1.5 menjadi .1.27 sesuai IP warkop sekarang
static const String baseUrl = "http://192.168.1.5/mealwise_api";


  Future<List<FoodModel>> getFoods() async {
    final response = await http.get(
      Uri.parse("$baseUrl/get_foods.php"),
    );

    if (response.statusCode == 200) {
      final List data = jsonDecode(response.body);
      return data.map((e) => FoodModel.fromJson(e)).toList();
    }
    return [];
  }

  Future<bool> addFood({
    required String name,
    required int price,
    required String category,
    required String description,
    required String image,
    required double rating,
  }) async {
    final response = await http.post(
      Uri.parse("$baseUrl/add_food.php"),
      body: {
        "name": name,
        "price": price.toString(),
        "category": category,
        "description": description,
        "image": image,
        "rating": rating.toString(),
      },
    );
    final data = jsonDecode(response.body);
    return data["success"];
  }

  Future<bool> deleteFood(int id) async {
    final response = await http.post(
      Uri.parse("$baseUrl/delete_food.php"),
      body: {"id": id.toString()},
    );
    final data = jsonDecode(response.body);
    return data["success"];
  }

  Future<bool> updateFood({
    required int id,
    required String name,
    required int price,
    required String category,
    required String description,
    required String image,
    required double rating,
  }) async {
    final response = await http.post(
      Uri.parse("$baseUrl/update_food.php"),
      body: {
        "id": id.toString(),
        "name": name,
        "price": price.toString(),
        "category": category,
        "description": description,
        "image": image,
        "rating": rating.toString(),
      },
    );
    final data = jsonDecode(response.body);
    return data["success"];
  }
}