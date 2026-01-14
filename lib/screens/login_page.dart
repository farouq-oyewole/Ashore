
// ignore_for_file: deprecated_member_use

import 'package:flutter/material.dart';
import 'package:glassmorphism_ui/glassmorphism_ui.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:rive/rive.dart' hide LinearGradient;
import 'package:ashore/core/widgets/moving_gradient_background.dart';
import 'package:ashore/screens/sign_up_page.dart';
import 'package:ashore/screens/home_page.dart';
import 'package:ashore/core/services/auth_service.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _authService = AuthService();
  
  bool _obscurePassword = true;
  bool _rememberMe = false;
  bool _isLoading = false;

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  Future<void> _handleLogin() async {
    if (_emailController.text.isEmpty || _passwordController.text.isEmpty) {
      _showError('Please fill in all fields');
      return;
    }

    setState(() => _isLoading = true);
    try {
      await _authService.signInWithEmail(
        _emailController.text.trim(),
        _passwordController.text.trim(),
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

  Future<void> _handleSocialLogin(String platform) async {
    setState(() => _isLoading = true);
    try {
      if (platform == 'Google') {
        await _authService.signInWithGoogle();
      } else if (platform == 'Apple') {
        await _authService.signInWithApple();
      }
      
      if (mounted) {
        Navigator.of(context).pushReplacement(
          MaterialPageRoute(builder: (_) => const HomePage()),
        );
      }
    } catch (e) {
      _showError('Social Login Failed: $e');
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
      resizeToAvoidBottomInset: false,
      body: Stack(
        children: [
          const Positioned.fill(
            child: MovingGradientBackground(),
          ),
          
          const Positioned.fill(
            child: Opacity(
              opacity: 0.4,
              child: RiveAnimation.network(
                'https://public.rive.app/community/runtime-files/2163-4334-spacer-animation.riv',
                fit: BoxFit.cover,
              ),
            ),
          ),

          SafeArea(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 10),
              child: Column(
                children: [
                  const Spacer(flex: 2),
                  
                  Column(
                    children: [
                      Text(
                        'LOGIN TO\nYOUR ACCOUNT',
                        textAlign: TextAlign.center,
                        style: GoogleFonts.playfairDisplay(
                          fontSize: 30,
                          fontWeight: FontWeight.bold,
                          color: Colors.black,
                          height: 1.1,
                          letterSpacing: -0.5,
                        ),
                      ).animate()
                       .fadeIn(duration: 800.ms)
                       .slideY(begin: 0.2, end: 0, curve: Curves.easeOutQuad),
                      
                      const SizedBox(height: 8),
                      
                      Text(
                        'Enter your login information',
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
                  
                  const Spacer(flex: 3),

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
                      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 24),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          _buildTextField(
                            hint: 'cliveross@gmail.com',
                            icon: FontAwesomeIcons.envelope,
                            iconColor: const Color(0xFF4285F4),
                            controller: _emailController,
                          ).animate()
                           .fadeIn(delay: 400.ms, duration: 600.ms)
                           .slideX(begin: -0.1, end: 0),
                          
                          const SizedBox(height: 16),
                          
                          _buildTextField(
                            hint: 'Password',
                            icon: FontAwesomeIcons.lock,
                            iconColor: const Color(0xFF34A853),
                            controller: _passwordController,
                            isPassword: true,
                            obscure: _obscurePassword,
                            onToggle: () => setState(() => _obscurePassword = !_obscurePassword),
                          ).animate()
                           .fadeIn(delay: 500.ms, duration: 600.ms)
                           .slideX(begin: -0.1, end: 0),
                          
                          const SizedBox(height: 12),
                          
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Row(
                                children: [
                                  SizedBox(
                                    height: 18,
                                    width: 18,
                                    child: Checkbox(
                                      value: _rememberMe,
                                      onChanged: (val) => setState(() => _rememberMe = val!),
                                      activeColor: Colors.black,
                                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(4)),
                                      side: const BorderSide(color: Colors.black26),
                                    ),
                                  ),
                                  const SizedBox(width: 8),
                                  Text(
                                    'Remember me',
                                    style: GoogleFonts.lato(color: Colors.black54, fontSize: 12),
                                  ),
                                ],
                              ),
                              TextButton(
                                onPressed: () {},
                                style: TextButton.styleFrom(padding: EdgeInsets.zero, minimumSize: Size.zero, tapTargetSize: MaterialTapTargetSize.shrinkWrap),
                                child: Text(
                                  'Forgot password?',
                                  style: GoogleFonts.lato(
                                    color: Colors.black87, 
                                    fontSize: 12,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              ),
                            ],
                          ).animate().fadeIn(delay: 600.ms),
                          
                          const SizedBox(height: 24),
                          
                          SizedBox(
                            width: double.infinity,
                            height: 52,
                            child: ElevatedButton(
                              onPressed: _isLoading ? null : _handleLogin,
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
                                    'LOGIN',
                                    style: GoogleFonts.lato(
                                      fontWeight: FontWeight.w800,
                                      fontSize: 15,
                                      letterSpacing: 1.5,
                                    ),
                                  ),
                            ),
                          ).animate()
                           .fadeIn(delay: 700.ms)
                           .scale(begin: const Offset(0.9, 0.9), end: const Offset(1.0, 1.0), curve: Curves.elasticOut, duration: 800.ms),
                        ],
                      ),
                    ),
                  ).animate()
                   .fadeIn(delay: 300.ms, duration: 1.seconds)
                   .blur(begin: const Offset(10, 10), end: Offset.zero, duration: 1.seconds),

                  const Spacer(flex: 2),
                  
                  Row(
                    children: [
                      const Expanded(child: Divider(color: Colors.black12, thickness: 1)),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 16),
                        child: Text('OR CONTINUE WITH', 
                          style: GoogleFonts.lato(
                            color: Colors.black38, 
                            fontSize: 10,
                            fontWeight: FontWeight.w800,
                            letterSpacing: 0.8,
                          ),
                        ),
                      ),
                      const Expanded(child: Divider(color: Colors.black12, thickness: 1)),
                    ],
                  ).animate().fadeIn(delay: 800.ms),
                  
                  const Spacer(flex: 1),

                  Row(
                    children: [
                      Expanded(
                        child: _buildSocialButton(
                          icon: FontAwesomeIcons.google,
                          label: 'GOOGLE',
                          iconColor: const Color(0xFFEA4335),
                          onTap: () => _handleSocialLogin('Google'),
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: _buildSocialButton(
                          icon: FontAwesomeIcons.apple,
                          label: 'APPLE',
                          iconColor: Colors.black,
                          onTap: () => _handleSocialLogin('Apple'),
                        ),
                      ),
                    ],
                  ).animate()
                   .fadeIn(delay: 900.ms)
                   .slideY(begin: 0.2, end: 0, curve: Curves.easeOutQuad),

                  const Spacer(flex: 3),
                  
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        'New here?',
                        style: GoogleFonts.lato(color: Colors.black54, fontSize: 14),
                      ),
                      TextButton(
                        onPressed: () {
                          Navigator.of(context).push(
                            MaterialPageRoute(builder: (_) => const SignUpPage()),
                          );
                        },
                        child: Text(
                          'Create Account',
                          style: GoogleFonts.lato(
                            color: Colors.black,
                            fontWeight: FontWeight.w900,
                            fontSize: 14,
                          ),
                        ),
                      ),
                    ],
                  ).animate().fadeIn(delay: 1.seconds),
                  const SizedBox(height: 5),
                ],
              ),
            ),
          ),

          // Loading Overlay
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

  Widget _buildSocialButton({required IconData icon, required String label, required Color iconColor, required VoidCallback onTap}) {
    return GlassContainer(
      blur: 20,
      opacity: 0.12,
      borderRadius: BorderRadius.circular(16),
      border: Border.fromBorderSide(
        BorderSide(color: Colors.white.withOpacity(0.5), width: 1),
      ),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(16),
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 16),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(icon, color: iconColor, size: 18),
              const SizedBox(width: 12),
              Text(
                label,
                style: GoogleFonts.lato(
                  color: Colors.black,
                  fontWeight: FontWeight.w900,
                  fontSize: 13,
                  letterSpacing: 0.5,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
