import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../models/food_model.dart';

class DetailPage extends StatelessWidget {

  final FoodModel food;

  const DetailPage({
    super.key,
    required this.food,
  });

  @override
  Widget build(BuildContext context) {

    return Scaffold(

      backgroundColor:
          const Color(0xff161622),

      body: Column(

        children: [

          Image.network(
            food.image,

            width: double.infinity,
            height: 320,

            fit: BoxFit.cover,
          ),

          Expanded(

            child: Padding(

              padding:
                  const EdgeInsets.all(20),

              child: Column(

                crossAxisAlignment:
                    CrossAxisAlignment.start,

                children: [

                  Text(

                    food.name,

                    style:
                        GoogleFonts.poppins(

                      color: Colors.white,

                      fontSize: 28,

                      fontWeight:
                          FontWeight.bold,
                    ),
                  ),

                  const SizedBox(height: 10),

                  Text(

                    food.category,

                    style:
                        GoogleFonts.poppins(

                      color: Colors.orange,

                      fontSize: 18,
                    ),
                  ),

                  const SizedBox(height: 20),

                  Text(

                    food.description,

                    style:
                        GoogleFonts.poppins(

                      color: Colors.white70,

                      fontSize: 16,
                    ),
                  ),

                  const SizedBox(height: 20),

                  Text(

                    '💰 Rp ${food.price}',

                    style:
                        GoogleFonts.poppins(

                      color: Colors.orange,

                      fontSize: 20,

                      fontWeight:
                          FontWeight.bold,
                    ),
                  ),

                  const SizedBox(height: 10),

                  Text(

                    '⭐ ${food.rating}',

                    style:
                        GoogleFonts.poppins(

                      color: Colors.white,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}