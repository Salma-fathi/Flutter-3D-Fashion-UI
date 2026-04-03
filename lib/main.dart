
import 'package:flutter/material.dart';
import 'dart:math' as math;

void main() {
  runApp(const FashionApp());
}

class FashionApp extends StatelessWidget {
  const FashionApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Fashion App UI',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: const ProductDetailPage(),
    );
  }
}

class ProductDetailPage extends StatefulWidget {
  const ProductDetailPage({super.key});

  @override
  State<ProductDetailPage> createState() => _ProductDetailPageState();
}

class _ProductDetailPageState extends State<ProductDetailPage> with SingleTickerProviderStateMixin {
  final ScrollController _scrollController = ScrollController();
  late AnimationController _animationController;
  late Animation<double> _rotationAnimation;

  double _scrollOffset = 0.0;
  Color _backgroundColor1 = Colors.blueGrey.shade900;
  Color _backgroundColor2 = Colors.blueGrey.shade700;

  // Placeholder for product data. Using network images now.
  final List<Product> products = [
    Product(
      name: 'Sport Shoe X',
      imageUrl: 'https://i.imgur.com/2X8p1gY.png', // Example transparent PNG shoe
      dominantColors: [Colors.red.shade800, Colors.red.shade400], // Example dominant colors
    ),
    Product(
      name: 'Luxury Handbag',
      imageUrl: 'https://i.imgur.com/3Y0j4fX.png', // Example transparent PNG handbag
      dominantColors: [Colors.brown.shade800, Colors.brown.shade400], // Example dominant colors
    ),
    // Add more products as needed
  ];

  Product _currentProduct = Product(
    name: 'Sport Shoe X',
    imageUrl: 'https://i.imgur.com/2X8p1gY.png',
    dominantColors: [Colors.red.shade800, Colors.red.shade400],
  );

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_updateScroll);
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 500),
    );
    _rotationAnimation = Tween<double>(begin: 0.0, end: 0.0).animate(_animationController);

    // Initialize with the first product's colors
    _updateBackgroundColors(_currentProduct.dominantColors);

    _scrollController.addListener(() {
      if (_scrollController.position.isScrollingNotifier.value == false) {
        // User stopped scrolling, start inertia animation
        _animationController.forward(from: 0.0);
      } else {
        // User is scrolling, stop inertia animation
        _animationController.stop();
      }
    });
  }

  void _updateScroll() {
    setState(() {
      _scrollOffset = _scrollController.offset;
      // Logic to change product based on scroll position could go here
      // For simplicity, we'll assume a single product for now or change based on a threshold
    });
  }

  void _updateBackgroundColors(List<Color> colors) {
    setState(() {
      if (colors.length >= 2) {
        _backgroundColor1 = colors[0];
        _backgroundColor2 = colors[1];
      } else if (colors.isNotEmpty) {
        _backgroundColor1 = colors[0];
        _backgroundColor2 = colors[0].withOpacity(0.7);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    // Calculate rotation based on scroll offset and inertia
    final double baseRotationAngle = (_scrollOffset / 300) * math.pi * 2; // Full rotation every 300 pixels
    final double effectiveRotationAngle = baseRotationAngle + (_rotationAnimation.value * 0.1); // Add a small inertia effect

    // Calculate parallax effect for background gradient
    final double parallaxOffset = _scrollOffset * 0.001; // Adjust sensitivity
    final Alignment beginAlignment = Alignment.topLeft.add(Alignment(parallaxOffset, parallaxOffset));
    final Alignment endAlignment = Alignment.bottomRight.add(Alignment(-parallaxOffset, -parallaxOffset));

    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: beginAlignment,
            end: endAlignment,
            colors: [_backgroundColor1, _backgroundColor2],
            tileMode: TileMode.clamp,
          ),
        ),
        child: CustomScrollView(
          controller: _scrollController,
          slivers: <Widget>[
            SliverAppBar(
              backgroundColor: Colors.transparent,
              elevation: 0,
              expandedHeight: 250.0,
              flexibleSpace: FlexibleSpaceBar(
                centerTitle: true,
                title: Text(
                  _currentProduct.name,
                  style: const TextStyle(color: Colors.white, fontSize: 24.0, fontWeight: FontWeight.bold),
                ),
              ),
            ),
            SliverToBoxAdapter(
              child: SizedBox(
                height: MediaQuery.of(context).size.height * 0.6, // Adjust height as needed
                child: Center(
                  child: AnimatedBuilder(
                    animation: _animationController,
                    builder: (context, child) {
                      return Transform(
                        alignment: Alignment.center,
                        transform: Matrix4.identity()
                          ..setEntry(3, 2, 0.001) // Perspective
                          ..rotateY(effectiveRotationAngle) // Y-axis rotation
                          ..rotateX(effectiveRotationAngle * 0.2), // Add slight tilt on X-axis
                        child: Image.network(
                          _currentProduct.imageUrl,
                          fit: BoxFit.contain,
                          height: 300,
                        ),
                      );
                    },
                  ),
                ),
              ),
            ),
            SliverList(
              delegate: SliverChildBuilderDelegate(
                (BuildContext context, int index) {
                  return Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Card(
                      color: Colors.white.withOpacity(0.8),
                      elevation: 4,
                      child: const Padding(
                        padding: EdgeInsets.all(16.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Product Description',
                              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                            ),
                            SizedBox(height: 10),
                            Text(
                              'This is a detailed description of the product. It highlights its features, materials, and unique selling points. Scroll to see the amazing 3D effect and dynamic background colors!',
                              style: TextStyle(fontSize: 16),
                            ),
                            SizedBox(height: 20),
                            Text(
                              'More details about the product can be added here, such as size, available colors, and customer reviews.',
                              style: TextStyle(fontSize: 16),
                            ),
                            // Add more content to make the page scrollable
                            SizedBox(height: 500), // Placeholder for more content to enable scrolling
                          ],
                        ),
                      ),
                    ),
                  );
                },
                childCount: 1, // Only one product description for now
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  void dispose() {
    _scrollController.dispose();
    _animationController.dispose();
    super.dispose();
  }
}

class Product {
  final String name;
  final String imageUrl;
  final List<Color> dominantColors;

  Product({
    required this.name,
    required this.imageUrl,
    required this.dominantColors,
  });
}
