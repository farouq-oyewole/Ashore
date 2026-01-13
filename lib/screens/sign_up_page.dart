
// ignore_for_file: deprecated_member_use

import 'package:flutter/material.dart';
import 'package:glassmorphism_ui/glassmorphism_ui.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:ashore/screens/login_page.dart';
import 'package:ashore/screens/home_page.dart';

class SignUpPage extends StatefulWidget {
  const SignUpPage({super.key});

  @override
  State<SignUpPage> createState() => _SignUpPageState();
}

class _SignUpPageState extends State<SignUpPage> {
  bool _obscurePassword = true;
  bool _obscureConfirmPassword = true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          // Background - White/Light Grey Gradient
          Container(
            width: double.infinity,
            height: double.infinity,
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.bottomLeft,
                end: Alignment.topRight,
                colors: [
                  Color(0xFFFFFFFF),
                  Color(0xFFF5F5F5),
                  Color(0xFFFFFFFF),
                ],
              ),
            ),
          ),
          
          // Background Decoration
          Positioned(
            bottom: -100,
            left: -50,
            child: Container(
              width: 300,
              height: 300,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: Colors.black.withOpacity(0.02),
              ),
            ),
          ),

          SafeArea(
            child: SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 20),
              child: Column(
                children: [
                  const SizedBox(height: 20),
                  
                  // Back Button
                  Align(
                    alignment: Alignment.centerLeft,
                    child: IconButton(
                      icon: const Icon(Icons.arrow_back_ios_new, color: Colors.black, size: 20),
                      onPressed: () => Navigator.of(context).pop(),
                    ),
                  ),
                  
                  const SizedBox(height: 20),
                  
                  // Header
                  Text(
                    'CREATE NEW\nACCOUNT',
                    textAlign: TextAlign.center,
                    style: GoogleFonts.playfairDisplay(
                      fontSize: 32,
                      fontWeight: FontWeight.bold,
                      color: Colors.black,
                      height: 1.2,
                    ),
                  ),
                  const SizedBox(height: 12),
                  Text(
                    'Join the world of modest elegance',
                    style: GoogleFonts.lato(
                      fontSize: 16,
                      color: Colors.black54,
                    ),
                  ),
                  
                  const SizedBox(height: 40),

                  // Glassmorphism Container
                  GlassContainer(
                    blur: 15,
                    border: Border.fromBorderSide(
                      BorderSide(color: Colors.black.withOpacity(0.05), width: 1),
                    ),
                    gradient: LinearGradient(
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                      colors: [
                        Colors.black.withOpacity(0.02),
                        Colors.black.withOpacity(0.05),
                      ],
                    ),
                    borderRadius: BorderRadius.circular(24),
                    child: Padding(
                      padding: const EdgeInsets.all(24),
                      child: Column(
                        children: [
                          // Full Name Field
                          _buildTextField(
                            hint: 'Full Name',
                            icon: FontAwesomeIcons.user,
                          ),
                          const SizedBox(height: 20),
                          
                          // Email Field
                          _buildTextField(
                            hint: 'Email Address',
                            icon: FontAwesomeIcons.envelope,
                          ),
                          const SizedBox(height: 20),
                          
                          // Password Field
                          _buildTextField(
                            hint: 'Password',
                            icon: FontAwesomeIcons.lock,
                            isPassword: true,
                            obscure: _obscurePassword,
                            onToggle: () => setState(() => _obscurePassword = !_obscurePassword),
                          ),
                          const SizedBox(height: 20),
                          
                          // Confirm Password Field
                          _buildTextField(
                            hint: 'Confirm Password',
                            icon: FontAwesomeIcons.shieldHalved,
                            isPassword: true,
                            obscure: _obscureConfirmPassword,
                            onToggle: () => setState(() => _obscureConfirmPassword = !_obscureConfirmPassword),
                          ),
                          
                          const SizedBox(height: 32),
                          
                          // Sign Up Button (Black)
                          SizedBox(
                            width: double.infinity,
                            height: 56,
                            child: ElevatedButton(
                              onPressed: () {
                                Navigator.of(context).pushReplacement(
                                  MaterialPageRoute(builder: (_) => const HomePage()),
                                );
                              },
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.black,
                                foregroundColor: Colors.white,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(30),
                                ),
                                elevation: 4,
                                shadowColor: Colors.black45,
                              ),
                              child: Text(
                                'SIGN UP',
                                style: GoogleFonts.lato(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 16,
                                  letterSpacing: 1.2,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),

                  const SizedBox(height: 32),
                  
                  // Terms text
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    child: Text(
                      'By signing up you agree to our Terms of Service and Privacy Policy',
                      textAlign: TextAlign.center,
                      style: GoogleFonts.lato(color: Colors.black54, fontSize: 12, height: 1.5),
                    ),
                  ),

                  const SizedBox(height: 32),
                  
                  // Login Link
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        'Already have an account?',
                        style: GoogleFonts.lato(color: Colors.black54),
                      ),
                      TextButton(
                        onPressed: () {
                          Navigator.of(context).pushReplacement(
                            MaterialPageRoute(builder: (_) => const LoginPage()),
                          );
                        },
                        child: Text(
                          'Log In',
                          style: GoogleFonts.lato(
                            color: Colors.black,
                            fontWeight: FontWeight.bold,
                            decoration: TextDecoration.underline,
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTextField({
    required String hint,
    required IconData icon,
    bool isPassword = false,
    bool? obscure,
    VoidCallback? onToggle,
  }) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.black.withOpacity(0.03),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.black.withOpacity(0.05)),
      ),
      child: TextField(
        obscureText: obscure ?? false,
        style: const TextStyle(color: Colors.black),
        decoration: InputDecoration(
          hintText: hint,
          hintStyle: const TextStyle(color: Colors.black38, fontSize: 14),
          prefixIcon: Icon(icon, color: Colors.black45, size: 18),
          suffixIcon: isPassword
              ? IconButton(
                  icon: Icon(
                    obscure! ? FontAwesomeIcons.eyeSlash : FontAwesomeIcons.eye,
                    color: Colors.black45,
                    size: 16,
                  ),
                  onPressed: onToggle,
                )
              : null,
          border: InputBorder.none,
          contentPadding: const EdgeInsets.symmetric(vertical: 16, horizontal: 16),
        ),
      ),
    );
  }
}
