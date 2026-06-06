import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../models/food_model.dart';
import '../providers/food_provider.dart';

class EditFoodPage extends StatefulWidget {

  final FoodModel food;

  const EditFoodPage({
    super.key,
    required this.food,
  });

  @override
  State<EditFoodPage> createState() =>
      _EditFoodPageState();
}

class _EditFoodPageState
    extends State<EditFoodPage> {

  late TextEditingController nameController;
  late TextEditingController priceController;
  late TextEditingController categoryController;
  late TextEditingController descriptionController;
  late TextEditingController imageController;
  late TextEditingController ratingController;

  @override
  void initState() {

    super.initState();

    nameController =
        TextEditingController(
      text: widget.food.name,
    );

    priceController =
        TextEditingController(
      text: widget.food.price.toString(),
    );

    categoryController =
        TextEditingController(
      text: widget.food.category,
    );

    descriptionController =
        TextEditingController(
      text: widget.food.description,
    );

    imageController =
        TextEditingController(
      text: widget.food.image,
    );

    ratingController =
        TextEditingController(
      text: widget.food.rating.toString(),
    );
  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(

      appBar: AppBar(
        title: const Text(
          "Edit Makanan",
        ),
      ),

      body: SingleChildScrollView(

        padding:
            const EdgeInsets.all(16),

        child: Column(

          children: [

            TextField(
              controller:
                  nameController,
              decoration:
                  const InputDecoration(
                labelText:
                    "Nama",
              ),
            ),

            const SizedBox(height: 12),

            TextField(
              controller:
                  priceController,
              decoration:
                  const InputDecoration(
                labelText:
                    "Harga",
              ),
            ),

            const SizedBox(height: 12),

            TextField(
              controller:
                  categoryController,
              decoration:
                  const InputDecoration(
                labelText:
                    "Kategori",
              ),
            ),

            const SizedBox(height: 12),

            TextField(
              controller:
                  descriptionController,
              decoration:
                  const InputDecoration(
                labelText:
                    "Deskripsi",
              ),
            ),

            const SizedBox(height: 12),

            TextField(
              controller:
                  imageController,
              decoration:
                  const InputDecoration(
                labelText:
                    "URL Gambar",
              ),
            ),

            const SizedBox(height: 12),

            TextField(
              controller:
                  ratingController,
              decoration:
                  const InputDecoration(
                labelText:
                    "Rating",
              ),
            ),

            const SizedBox(height: 24),

            ElevatedButton(

              onPressed: () async {

                await Provider.of<
                    FoodProvider>(
                  context,
                  listen: false,
                ).updateFood(

                  id:
                      widget.food.id!,

                  name:
                      nameController.text,

                  price:
                      int.parse(
                    priceController.text,
                  ),

                  category:
                      categoryController.text,

                  description:
                      descriptionController.text,

                  image:
                      imageController.text,

                  rating:
                      double.parse(
                    ratingController.text,
                  ),
                );

                if (mounted) {

                  Navigator.pop(
                    context,
                  );
                }
              },

              child: const Text(
                "UPDATE",
              ),
            ),
          ],
        ),
      ),
    );
  }
}