
// ignore_for_file: deprecated_member_use

import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';
import 'package:ashore/screens/sign_up_page.dart';
import 'package:ashore/screens/login_page.dart';

/// SplashScreen handles the premium image carousel and brand introduction.
/// It uses AnimatedSwitcher for seamless B&W image transitions.
class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  final List<String> _images = [
    'assets/images/splash_khimar_full.jpg',
    'assets/images/splash_native_man_1.png',
  ];
  int _currentIndex = 0;
  Timer? _timer;

  @override
  void initState() {
    super.initState();
    _startAutoSlide();
  }

  void _startAutoSlide() {
    _timer = Timer.periodic(const Duration(seconds: 4), (timer) {
      if (mounted) {
        setState(() {
          _currentIndex = (_currentIndex + 1) % _images.length;
        });
      }
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    
    // Strict Black & White Palette
    const Color bgWhite = Color(0xFFFAFAFA); 
    const Color textBlack = Color(0xFF000000);
    const Color textGrey = Color(0xFF666666);

    return Scaffold(
      backgroundColor: bgWhite,
      body: Stack(
        fit: StackFit.expand,
        children: [
          // 1. Background Image Cross-Fade
          Positioned.fill(
            child: ColorFiltered(
              colorFilter: const ColorFilter.mode(
                Colors.grey,
                BlendMode.saturation,
              ),
              child: AnimatedSwitcher(
                duration: const Duration(milliseconds: 1500),
                switchInCurve: Curves.easeInOut,
                switchOutCurve: Curves.easeInOut,
                transitionBuilder: (Widget child, Animation<double> animation) {
                  return FadeTransition(opacity: animation, child: child);
                },
                child: Image.asset(
                  _images[_currentIndex],
                  key: ValueKey<String>(_images[_currentIndex]),
                  fit: BoxFit.cover,
                  width: double.infinity,
                  height: double.infinity,
                ),
              ),
            ),
          ),
          
          // 2. Gradient Overlay for readability
          Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [
                  Colors.white.withOpacity(0.0),
                  Colors.white.withOpacity(0.7),
                  Colors.white,
                ],
                stops: const [0.3, 0.7, 1.0],
              ),
            ),
          ),

          // 3. Content
          SafeArea(
            child: Column(
              children: [
                const Spacer(flex: 10), // Push content down, leaving top clear

                // Magazine Style Headlines
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 24.0),
                  child: Column(
                    children: [
                      Text(
                        'TIMELESS\nELEGANCE',
                        textAlign: TextAlign.center,
                        style: GoogleFonts.playfairDisplay(
                          fontSize: size.width * 0.1, // Responsive font size
                          fontWeight: FontWeight.w700,
                          height: 1.0,
                          color: textBlack,
                          letterSpacing: -0.5,
                        ),
                      ).animate().fadeIn(duration: 800.ms).slideY(begin: 0.1, end: 0),
                      
                      const SizedBox(height: 16),
                      
                      Text(
                        'Discover the art of modest fashion.\nCurated for the modern individual.',
                        textAlign: TextAlign.center,
                        style: GoogleFonts.lato(
                          fontSize: 14,
                          color: textGrey,
                          height: 1.5,
                          letterSpacing: 0.5,
                        ),
                      ).animate().fadeIn(delay: 300.ms, duration: 800.ms),
                    ],
                  ),
                ),

                const SizedBox(height: 32),

                // Indicator
                 AnimatedSmoothIndicator(
                  activeIndex: _currentIndex,
                  count: _images.length,
                  effect: const ExpandingDotsEffect(
                    activeDotColor: textBlack,
                    dotColor: Color(0xFFD6D6D6),
                    dotHeight: 6,
                    dotWidth: 6,
                    expansionFactor: 4,
                    spacing: 8,
                  ),
                ),

                const Spacer(flex: 2),

                // Button strictly matching reference (Pill shape, Uppercase, Shadow)
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 40),
                  child: SizedBox(
                    width: double.infinity,
                    height: 54, // Standard height for this style
                    child: ElevatedButton(
                      onPressed: () {
                         Navigator.of(context).push(MaterialPageRoute(builder: (_) => const SignUpPage()));
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: textBlack,
                        foregroundColor: Colors.white,
                        elevation: 5, // Subtle shadow like reference
                        shadowColor: Colors.black.withOpacity(0.4),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(30), // Full pill shape
                        ),
                        // Remove default padding to ensure text centering
                        padding: const EdgeInsets.symmetric(vertical: 0),
                      ),
                      child: Text(
                        "GET STARTED",
                        style: GoogleFonts.lato(
                          fontSize: 15,
                          fontWeight: FontWeight.w800, // Thicker font like reference
                          letterSpacing: 0.5,
                        ),
                      ),
                    ).animate().scale(begin: const Offset(0.95, 0.95), end: const Offset(1.0, 1.0), duration: const Duration(milliseconds: 400)),
                  ),
                ),
                
                const SizedBox(height: 24),
                
                // Minimal Login Link
                GestureDetector(
                  onTap: () {
                    Navigator.of(context).push(MaterialPageRoute(builder: (_) => const LoginPage()));
                  },
                  child: RichText(
                    text: TextSpan(
                      text: "Already have an account? ",
                      style: GoogleFonts.lato(
                        fontSize: 14,
                        color: textGrey,
                      ),
                      children: [
                        TextSpan(
                          text: "Login",
                          style: GoogleFonts.lato(
                            fontWeight: FontWeight.bold,
                            color: textBlack, 
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                
                const SizedBox(height: 24),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
