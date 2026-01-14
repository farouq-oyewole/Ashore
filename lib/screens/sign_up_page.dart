// ignore_for_file: deprecated_member_use

import 'package:flutter/material.dart';
import 'package:glassmorphism_ui/glassmorphism_ui.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:rive/rive.dart' hide LinearGradient;
import 'package:ashore/core/widgets/moving_gradient_background.dart';
import 'package:ashore/screens/login_page.dart';
import 'package:ashore/screens/home_page.dart';
import 'package:ashore/core/services/auth_service.dart';

class SignUpPage extends StatefulWidget {
  const SignUpPage({super.key});

  @override
  State<SignUpPage> createState() => _SignUpPageState();
}

class _SignUpPageState extends State<SignUpPage> {
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();
  final _authService = AuthService();

  bool _obscurePassword = true;
  bool _obscureConfirmPassword = true;
  bool _isLoading = false;

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  Future<void> _handleSignUp() async {
    if (_emailController.text.isEmpty || _passwordController.text.isEmpty || _nameController.text.isEmpty) {
      _showError('Please fill in all fields');
      return;
    }

    if (_passwordController.text != _confirmPasswordController.text) {
      _showError('Passwords do not match');
      return;
    }

    setState(() => _isLoading = true);
    try {
      await _authService.signUpWithEmail(
        _emailController.text.trim(),
        _passwordController.text.trim(),
        displayName: _nameController.text.trim(),
      );
      
      if (mounted) {
        Navigator.of(context).pushReplacement(
          MaterialPageRoute(builder: (_) => const HomePage()),
        );
      }
    } catch (e) {
      _showError(e.toString());
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  void _showError(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: Colors.redAccent,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: true,
      body: Stack(
        children: [
          const Positioned.fill(
            child: MovingGradientBackground(),
          ),
          
          const Positioned.fill(
            child: Opacity(
              opacity: 0.3,
              child: RiveAnimation.network(
                'https://public.rive.app/community/runtime-files/2163-4334-spacer-animation.riv',
                fit: BoxFit.cover,
              ),
            ),
          ),

          SafeArea(
            child: SingleChildScrollView(
              physics: const BouncingScrollPhysics(),
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 24.0),
                child: Column(
                  children: [
                    const SizedBox(height: 5),
                    Align(
                      alignment: Alignment.centerLeft,
                      child: IconButton(
                        icon: const Icon(Icons.arrow_back_ios_new, color: Colors.black, size: 20),
                        onPressed: () => Navigator.of(context).pop(),
                      ),
                    ).animate().fadeIn(duration: 500.ms).slideX(begin: -0.2, end: 0),
                    
                    const SizedBox(height: 10),
                    
                    Column(
                      children: [
                        Text(
                          'CREATE NEW\nACCOUNT',
                          textAlign: TextAlign.center,
                          style: GoogleFonts.playfairDisplay(
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                            color: Colors.black,
                            height: 1.1,
                            letterSpacing: -0.5,
                          ),
                        ).animate()
                         .fadeIn(duration: 800.ms)
                         .slideY(begin: 0.2, end: 0, curve: Curves.easeOutQuad),
                        
                        const SizedBox(height: 4),
                        
                        Text(
                          'Join the world of modest elegance',
                          style: GoogleFonts.lato(
                            fontSize: 14,
                            color: Colors.black45,
                            letterSpacing: 0.2,
                          ),
                        ).animate()
                         .fadeIn(delay: 200.ms, duration: 800.ms)
                         .slideY(begin: 0.2, end: 0, curve: Curves.easeOutQuad),
                      ],
                    ),
                    
                    const SizedBox(height: 15),
                    
                    GlassContainer(
                      blur: 35,
                      opacity: 0.1,
                      border: Border.fromBorderSide(
                        BorderSide(color: Colors.white.withOpacity(0.6), width: 1.5),
                      ),
                      gradient: LinearGradient(
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                        colors: [
                          Colors.white.withOpacity(0.15),
                          Colors.white.withOpacity(0.08),
                        ],
                      ),
                      borderRadius: BorderRadius.circular(32),
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            _buildTextField(
                              hint: 'Full Name',
                              icon: FontAwesomeIcons.user,
                              iconColor: const Color(0xFFFBBC05),
                              controller: _nameController,
                            ).animate()
                             .fadeIn(delay: 400.ms, duration: 600.ms)
                             .slideX(begin: -0.1, end: 0),
                            
                            const SizedBox(height: 10),
                            
                            _buildTextField(
                              hint: 'Email Address',
                              icon: FontAwesomeIcons.envelope,
                              iconColor: const Color(0xFF4285F4),
                              controller: _emailController,
                            ).animate()
                             .fadeIn(delay: 500.ms, duration: 600.ms)
                             .slideX(begin: -0.1, end: 0),
                            
                            const SizedBox(height: 10),
                            
                            _buildTextField(
                              hint: 'Password',
                              icon: FontAwesomeIcons.lock,
                              iconColor: const Color(0xFF34A853),
                              controller: _passwordController,
                              isPassword: true,
                              obscure: _obscurePassword,
                              onToggle: () => setState(() => _obscurePassword = !_obscurePassword),
                            ).animate()
                             .fadeIn(delay: 600.ms, duration: 600.ms)
                             .slideX(begin: -0.1, end: 0),
                            
                            const SizedBox(height: 10),
                            
                            _buildTextField(
                              hint: 'Confirm Password',
                              icon: FontAwesomeIcons.shieldHalved,
                              iconColor: const Color(0xFFEA4335),
                              controller: _confirmPasswordController,
                              isPassword: true,
                              obscure: _obscureConfirmPassword,
                              onToggle: () => setState(() => _obscureConfirmPassword = !_obscureConfirmPassword),
                            ).animate()
                             .fadeIn(delay: 700.ms, duration: 600.ms)
                             .slideX(begin: -0.1, end: 0),
                            
                            const SizedBox(height: 15),
                            
                            SizedBox(
                              width: double.infinity,
                              height: 52,
                              child: ElevatedButton(
                                onPressed: _isLoading ? null : _handleSignUp,
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: Colors.black,
                                  foregroundColor: Colors.white,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(30),
                                  ),
                                  elevation: 8,
                                  shadowColor: Colors.black.withOpacity(0.4),
                                ),
                                child: _isLoading
                                  ? const SizedBox(
                                      height: 20, 
                                      width: 20, 
                                      child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2)
                                    )
                                  : Text(
                                      'SIGN UP',
                                      style: GoogleFonts.lato(
                                        fontWeight: FontWeight.w800,
                                        fontSize: 15,
                                        letterSpacing: 1.5,
                                      ),
                                    ),
                              ),
                            ).animate()
                             .fadeIn(delay: 800.ms)
                             .scale(begin: const Offset(0.9, 0.9), end: const Offset(1.0, 1.0), curve: Curves.elasticOut, duration: 800.ms),
                          ],
                        ),
                      ),
                    ).animate()
                     .fadeIn(delay: 300.ms, duration: 1.seconds)
                     .blur(begin: const Offset(10, 10), end: Offset.zero, duration: 1.seconds),
                    
                    const SizedBox(height: 15),
                    
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 40),
                      child: Text(
                        'By signing up, you agree to our Terms and Conditions',
                        textAlign: TextAlign.center,
                        style: GoogleFonts.lato(
                          color: Colors.black45,
                          fontSize: 10, 
                          height: 1.4,
                        ),
                      ),
                    ).animate().fadeIn(delay: 900.ms),
                    
                    const SizedBox(height: 10),
                    
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          'Already a member?',
                          style: GoogleFonts.lato(color: Colors.black54, fontSize: 14),
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
                              fontWeight: FontWeight.w900,
                              fontSize: 14,
                            ),
                          ),
                        ),
                      ],
                    ).animate().fadeIn(delay: 1.seconds),
                    const SizedBox(height: 20),
                  ],
                ),
              ),
            ),
          ),

          if (_isLoading)
            Container(
              color: Colors.black26,
              child: const Center(
                child: GlassContainer(
                  blur: 10,
                  opacity: 0.2,
                  child: Padding(
                    padding: EdgeInsets.all(24.0),
                    child: CircularProgressIndicator(color: Colors.black),
                  ),
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
    required Color iconColor,
    required TextEditingController controller,
    bool isPassword = false,
    bool? obscure,
    VoidCallback? onToggle,
  }) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.6),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.black.withOpacity(0.08)),
        boxShadow: [
          BoxShadow(
            color: iconColor.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: TextField(
        controller: controller,
        obscureText: obscure ?? false,
        style: const TextStyle(color: Colors.black, fontSize: 15),
        decoration: InputDecoration(
          hintText: hint,
          hintStyle: const TextStyle(color: Colors.black38, fontSize: 14),
          prefixIcon: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Icon(icon, color: iconColor, size: 18),
          ),
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
          contentPadding: const EdgeInsets.symmetric(vertical: 18),
        ),
      ),
    );
  }
}
