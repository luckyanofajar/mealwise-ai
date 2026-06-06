class FoodModel {

  final int? id;

  final String name;
  final int price;
  final double rating;
  final String image;
  final String category;
  final String description;

  bool isFavorite;

  FoodModel({
    this.id,
    required this.name,
    required this.price,
    required this.rating,
    required this.image,
    required this.category,
    required this.description,
    this.isFavorite = false,
  });

  factory FoodModel.fromJson(
      Map<String, dynamic> json) {

    return FoodModel(

      id: int.tryParse(
          json['id'].toString()) ?? 0,

      name: json['name'] ?? '',

      price: int.tryParse(
          json['price'].toString()) ?? 0,

      category:
          json['category'] ?? '',

      description:
          json['description'] ?? '',

      image:
          json['image'] ?? '',

      rating: double.tryParse(
              json['rating']
                  .toString()) ??
          0,
    );
  }

  Map<String, dynamic> toJson() {

    return {

      "id": id,

      "name": name,

      "price": price,

      "category": category,

      "description":
          description,

      "image": image,

      "rating": rating,
    };
  }
}