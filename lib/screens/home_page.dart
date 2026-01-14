// ignore_for_file: deprecated_member_use

import 'package:ashore/core/services/auth_service.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:glassmorphism_ui/glassmorphism_ui.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';
import 'dart:convert';

import 'package:ashore/screens/profile_page.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int _selectedIndex = 0;
  String _selectedCategory = 'All Items';
  final _authService = AuthService();
  File? _profileImage;
  final ImagePicker _picker = ImagePicker();

  final List<String> _categories = ['All Items', 'Khimar', 'Abaya', 'Syar\'i', 'Native'];

  final List<Map<String, dynamic>> _products = [
    {
      'name': 'Royal Purple',
      'label': 'Premium Native Agbada',
      'price': '\$299.99',
      'rating': '5.0',
      'image': 'assets/images/new_image_1.jpg',
      'category': 'Native',
    },
    {
      'name': 'Evening Abaya',
      'label': 'Noir Modesty Abaya',
      'price': '\$249.99',
      'rating': '5.0',
      'image': 'assets/images/new_image_2.jpg',
      'category': 'Abaya',
    },
    {
      'name': 'Syar\'i Elegance',
      'label': 'Full Coverage Set',
      'price': '\$189.99',
      'rating': '4.9',
      'image': 'assets/images/new_image_3.jpg',
      'category': 'Syar\'i',
    },
    {
      'name': 'Midnight Khimar',
      'label': 'Double Layered Khimar',
      'price': '\$219.99',
      'rating': '5.0',
      'image': 'assets/images/new_image_4.jpg',
      'category': 'Khimar',
    },
    {
      'name': 'Fatelieen Premium',
      'label': 'Elegant Blue Khimar',
      'price': '\$89.99',
      'rating': '5.0',
      'image': 'assets/images/splash_khimar_full.jpg',
      'category': 'Khimar',
    },
    {
      'name': 'Native Pride',
      'label': 'Traditional Native Wear',
      'price': '\$129.99',
      'rating': '5.0',
      'image': 'assets/images/splash_native_man_1.png',
      'category': 'Native',
    },
    {
      'name': 'Desert Rose',
      'label': 'Premium Black Abaya',
      'price': '\$175.00',
      'rating': '4.8',
      'image': 'assets/images/abaya1.jpg',
      'category': 'Abaya',
    },
    {
      'name': 'Urban Modesty',
      'label': 'Lace Detail Abaya',
      'price': '\$155.00',
      'rating': '4.7',
      'image': 'assets/images/abaya2.jpg',
      'category': 'Abaya',
    },
    {
      'name': 'Silk Serenity',
      'label': 'Traditional Native Set',
      'price': '\$190.00',
      'rating': '5.0',
      'image': 'assets/images/native1.jpg',
      'category': 'Native',
    },
    {
      'name': 'Majestic Flow',
      'label': 'Embroidered Native',
      'price': '\$185.00',
      'rating': '4.9',
      'image': 'assets/images/native2.jpg',
      'category': 'Native',
    },
  ];

  Future<void> _pickImage() async {
    try {
      final XFile? pickedFile = await _picker.pickImage(
        source: ImageSource.gallery,
        maxWidth: 512,
        maxHeight: 512,
        imageQuality: 75,
      );
      if (pickedFile != null) {
        final File file = File(pickedFile.path);
        final bytes = await file.readAsBytes();
        final String base64Image = 'data:image/jpeg;base64,${base64Encode(bytes)}';
        
        setState(() {
          _profileImage = file;
        });
        
        // Persist to user profile as Base64 string
        await _authService.updateProfile(photoURL: base64Image);
      }
    } catch (e) {
      debugPrint('Error picking image: $e');
    }
  }

  String _getUserFirstName() {
    final user = _authService.currentUser;
    if (user != null && user.displayName != null && user.displayName!.isNotEmpty) {
      return user.displayName!.split(' ')[0];
    }
    return 'Guest';
  }

  ImageProvider? _getProfileImageProvider() {
    if (_profileImage != null) {
      return FileImage(_profileImage!);
    }
    
    final photoURL = FirebaseAuth.instance.currentUser?.photoURL;
    if (photoURL == null || photoURL.isEmpty) {
      return null;
    }
    
    if (photoURL.startsWith('data:image')) {
      // Handle Base64
      try {
        final base64String = photoURL.split(',').last;
        return MemoryImage(base64Decode(base64String));
      } catch (e) {
        debugPrint('Error decoding base64 image: $e');
        return null;
      }
    } else if (photoURL.startsWith('http')) {
      return NetworkImage(photoURL);
    } else {
      return FileImage(File(photoURL));
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,
      body: Stack(
        children: [
          IndexedStack(
            index: _selectedIndex,
            children: [
              // Home Screen
              SafeArea(
                child: Column(
                  children: [
                    _buildHeader(),
                    _buildSearchBar(),
                    _buildCategories(),
                    Expanded(child: _buildProductGrid()),
                    const SizedBox(height: 100), // Space for floating nav bar
                  ],
                ),
              ),
              // Shopping Bag Placeholder
              const Center(child: Text('Shopping Bag (Coming Soon)')),
              // Liked Items Placeholder
              const Center(child: Text('Liked Items (Coming Soon)')),
              // Profile Screen
              const ProfilePage(),
            ],
          ),
          Positioned(
            left: 20,
            right: 20,
            bottom: 30,
            child: _buildBottomNav(isDark),
          ),
        ],
      ),
    );
  }

  Widget _buildHeader() {
    final theme = Theme.of(context);
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 16.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Assalamu Alaikum 👋', 
                style: GoogleFonts.outfit(
                  fontSize: 16,
                  color: theme.colorScheme.onSurface.withOpacity(0.54),
                  fontWeight: FontWeight.w400,
                ),
              ),
              Text(
                _getUserFirstName(),
                style: GoogleFonts.outfit(
                  fontSize: 28,
                  fontWeight: FontWeight.w800,
                  color: theme.colorScheme.onSurface,
                  letterSpacing: -0.5,
                ),
              ),
            ],
          ),
          GestureDetector(
            onTap: _pickImage,
            child: Container(
              padding: const EdgeInsets.all(3),
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(color: theme.colorScheme.onSurface.withOpacity(0.08), width: 1.5),
              ),
              child: CircleAvatar(
                radius: 26,
                backgroundColor: theme.colorScheme.surface,
                backgroundImage: _getProfileImageProvider(),
                child: (_profileImage == null && 
                       (FirebaseAuth.instance.currentUser?.photoURL == null || 
                        FirebaseAuth.instance.currentUser!.photoURL!.isEmpty))
                  ? Icon(FontAwesomeIcons.user, color: theme.colorScheme.onSurface.withOpacity(0.26), size: 20)
                  : null,
              ),
            ),
          ).animate().scale(delay: 200.ms, duration: 600.ms, curve: Curves.elasticOut),
        ],
      ),
    );
  }

  Widget _buildSearchBar() {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24.0),
      child: Row(
        children: [
          Expanded(
            child: GlassContainer(
              blur: 15,
              opacity: isDark ? 0.1 : 0.05,
              borderRadius: BorderRadius.circular(20),
              border: Border.fromBorderSide(
                BorderSide(color: theme.colorScheme.onSurface.withOpacity(0.05), width: 1),
              ),
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: TextField(
                  style: theme.textTheme.bodyMedium,
                  decoration: InputDecoration(
                    icon: Icon(FontAwesomeIcons.magnifyingGlass, size: 14, color: theme.colorScheme.onSurface.withOpacity(0.26)),
                    hintText: 'Search modest wear...',
                    hintStyle: GoogleFonts.outfit(color: theme.colorScheme.onSurface.withOpacity(0.26), fontSize: 14),
                    border: InputBorder.none,
                  ),
                ),
              ),
            ),
          ),
          const SizedBox(width: 12),
          _buildActionButton(context, FontAwesomeIcons.sliders),
        ],
      ),
    ).animate().fadeIn(delay: 400.ms).slideY(begin: 0.1, end: 0);
  }

  Widget _buildActionButton(BuildContext context, IconData icon) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    return GlassContainer(
      blur: 10,
      opacity: isDark ? 0.2 : 0.1,
      borderRadius: BorderRadius.circular(16),
      child: Padding(
        padding: const EdgeInsets.all(14),
        child: Icon(icon, color: theme.colorScheme.onSurface.withOpacity(0.87), size: 16),
      ),
    );
  }

  Widget _buildCategories() {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    return Container(
      height: 40,
      margin: const EdgeInsets.symmetric(vertical: 24),
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 24),
        itemCount: _categories.length,
        itemBuilder: (context, index) {
          final isSelected = _selectedCategory == _categories[index];
          return GestureDetector(
            onTap: () => setState(() => _selectedCategory = _categories[index]),
            child: AnimatedContainer(
              duration: 300.ms,
              padding: const EdgeInsets.symmetric(horizontal: 24),
              margin: const EdgeInsets.only(right: 12),
              decoration: BoxDecoration(
                color: isSelected 
                    ? theme.colorScheme.onSurface 
                    : (isDark ? Colors.white.withOpacity(0.1) : Colors.white.withOpacity(0.8)),
                borderRadius: BorderRadius.circular(25),
                boxShadow: isSelected ? [
                  BoxShadow(
                    color: theme.colorScheme.onSurface.withOpacity(0.2),
                    blurRadius: 10,
                    offset: const Offset(0, 4),
                  )
                ] : [],
              ),
              child: Center(
                child: Text(
                  _categories[index],
                  style: GoogleFonts.outfit(
                    color: isSelected ? theme.colorScheme.surface : theme.colorScheme.onSurface.withOpacity(0.87),
                    fontWeight: isSelected ? FontWeight.w700 : FontWeight.w500,
                    fontSize: 14,
                  ),
                ),
              ),
            ),
          );
        },
      ),
    ).animate().fadeIn(delay: 600.ms);
  }

  Widget _buildProductGrid() {
    final filteredProducts = _selectedCategory == 'All Items' 
      ? _products 
      : _products.where((p) => p['category'] == _selectedCategory).toList();

    return GridView.builder(
      padding: const EdgeInsets.symmetric(horizontal: 24),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        mainAxisSpacing: 24,
        crossAxisSpacing: 20,
        childAspectRatio: 0.65,
      ),
      itemCount: filteredProducts.length,
      itemBuilder: (context, index) {
        return _buildProductCard(filteredProducts[index]);
      },
    ).animate().fadeIn(delay: 800.ms);
  }

  Widget _buildProductCard(Map<String, dynamic> product) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(
          child: Stack(
            children: [
              Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(24),
                  image: DecorationImage(
                    image: AssetImage(product['image']),
                    fit: BoxFit.cover,
                  ),
                ),
              ),
              Positioned(
                top: 12,
                right: 12,
                child: GlassContainer(
                  blur: 10,
                  opacity: 0.1,
                  borderRadius: BorderRadius.circular(12),
                  child: const Padding(
                    padding: EdgeInsets.all(8),
                    child: Icon(FontAwesomeIcons.heart, color: Colors.white, size: 14),
                  ),
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 12),
        Text(
          product['name'],
          style: GoogleFonts.outfit(
            fontSize: 15,
            fontWeight: FontWeight.w700,
            color: Theme.of(context).colorScheme.onSurface,
          ),
        ),
        Text(
          product['label'],
          style: GoogleFonts.outfit(
            fontSize: 12,
            color: Theme.of(context).colorScheme.onSurface.withOpacity(0.45),
            fontWeight: FontWeight.w400,
          ),
        ),
        const SizedBox(height: 6),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              product['price'],
              style: GoogleFonts.outfit(
                fontSize: 16,
                fontWeight: FontWeight.w800,
                color: Theme.of(context).colorScheme.onSurface,
              ),
            ),
            Row(
              children: [
                const Icon(Icons.star_rounded, color: Color(0xFFFBC02D), size: 16),
                const SizedBox(width: 4),
                Text(
                  product['rating'],
                  style: GoogleFonts.outfit(
                    fontSize: 13,
                    fontWeight: FontWeight.w600,
                    color: Theme.of(context).colorScheme.onSurface,
                  ),
                ),
              ],
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildBottomNav(bool isDark) {
    return Container(
      height: 70,
      decoration: BoxDecoration(
        color: isDark ? const Color(0xFF1E1E1E) : const Color(0xFF1A1A1A), 
        borderRadius: BorderRadius.circular(40),
        border: isDark ? Border.all(color: Colors.white.withOpacity(0.1), width: 1) : null,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.4),
            blurRadius: 20,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 10),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            _buildNavItem(FontAwesomeIcons.house, 0),
            _buildNavItem(FontAwesomeIcons.bagShopping, 1, hasBadge: true),
            _buildNavItem(FontAwesomeIcons.heart, 2),
            _buildNavItem(FontAwesomeIcons.user, 3),
          ],
        ),
      ),
    );
  }

  Widget _buildNavItem(IconData icon, int index, {bool hasBadge = false}) {
    bool isSelected = _selectedIndex == index;
    return GestureDetector(
      onTap: () => setState(() => _selectedIndex = index),
      behavior: HitTestBehavior.opaque,
      child: SizedBox(
        width: 60,
        height: 60,
        child: Stack(
          alignment: Alignment.center,
          children: [
            // Active background glow/indicator
            if (isSelected)
              Container(
                width: 45,
                height: 45,
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.08),
                  shape: BoxShape.circle,
                ),
              ).animate().scale(duration: 400.ms, curve: Curves.easeOutQuint),
            
            // Icon
            Icon(
              icon,
              color: isSelected ? Colors.white : Colors.white54,
              size: 20,
            ),

            // Badge for Shopping Bag
            if (hasBadge)
              Positioned(
                top: 18,
                right: 18,
                child: Container(
                  width: 8,
                  height: 8,
                  decoration: const BoxDecoration(
                    color: Color(0xFFEA4335), // Red badge
                    shape: BoxShape.circle,
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}
