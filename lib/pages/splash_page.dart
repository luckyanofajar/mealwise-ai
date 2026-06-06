import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:google_fonts/google_fonts.dart';
import 'login_page.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'home_page.dart';

class SplashPage extends StatefulWidget {
  const SplashPage({super.key});

  @override
  State<SplashPage> createState() =>
      _SplashPageState();
}

class _SplashPageState
    extends State<SplashPage> {

  @override
  void initState() {
    super.initState();

    Future<void> checkLogin() async {

  final prefs =
      await SharedPreferences
          .getInstance();

  final isLogin =
      prefs.getBool('isLogin') ?? false;

  await Future.delayed(
    const Duration(seconds: 4),
  );

  if (!mounted) return;

  if (isLogin) {

    Navigator.pushReplacement(
      context,

      MaterialPageRoute(
        builder: (_) =>
            const HomePage(),
      ),
    );

  } else {

    Navigator.pushReplacement(
      context,

      MaterialPageRoute(
        builder: (_) =>
            const LoginPage(),
      ),
    );
  }
}

checkLogin();

  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        width: double.infinity,

        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              Color(0xff1E1E2E),
              Color(0xff2A2A40),
              Color(0xffFF7A00),
            ],
          ),
        ),

        child: Center(
          child: Column(
            mainAxisAlignment:
                MainAxisAlignment.center,
            children: [

              Container(
                width: 140,
                height: 140,

                decoration: BoxDecoration(
                  color: Colors.white
                      .withOpacity(0.1),

                  borderRadius:
                      BorderRadius.circular(
                    40,
                  ),

                  border: Border.all(
                    color: Colors.white24,
                    width: 2,
                  ),
                ),

                child: const Icon(
                  Icons.restaurant_menu,
                  color: Colors.white,
                  size: 80,
                ),
              )
                  .animate(
                    onPlay: (controller) =>
                        controller.repeat(),
                  )
                  .rotate(
                    duration: 4.seconds,
                  ),

              const SizedBox(height: 40),

              Text(
                'MealWise AI',
                style: GoogleFonts.poppins(
                  color: Colors.white,
                  fontSize: 34,
                  fontWeight:
                      FontWeight.bold,
                  letterSpacing: 2,
                ),
              )
                  .animate()
                  .fadeIn(
                    duration: 1500.ms,
                  )
                  .slideY(
                    begin: 1,
                    end: 0,
                  ),

              const SizedBox(height: 12),

              Text(
                'Makan Enak Tanpa Boncos\nAI Atur Menu Sesuai Kantong',
                textAlign: TextAlign.center,
                style: GoogleFonts.poppins(
                  color: Colors.white70,
                  fontSize: 16,
                ),
              )
                  .animate()
                  .fadeIn(
                    delay: 500.ms,
                    duration: 1500.ms,
                  ),
            ],
          ),
        ),
      ),
    );
  }
}