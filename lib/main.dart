
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

class _ProductDetailPageState extends State<ProductDetailPage> {
  final ScrollController _scrollController = ScrollController();
  double _scrollOffset = 0.0;
  Color _backgroundColor1 = Colors.blueGrey.shade900;
  Color _backgroundColor2 = Colors.blueGrey.shade700;

  // Placeholder for product data. In a real app, this would come from a model.
  final List<Product> products = [
    Product(
      name: 'Sport Shoe X',
      imagePath: 'assets/shoe_x.png',
      dominantColors: [Colors.red.shade800, Colors.red.shade400], // Example dominant colors
    ),
    Product(
      name: 'Luxury Handbag',
      imagePath: 'assets/handbag_y.png',
      dominantColors: [Colors.brown.shade800, Colors.brown.shade400], // Example dominant colors
    ),
    // Add more products as needed
  ];

  Product _currentProduct = Product(
    name: 'Sport Shoe X',
    imagePath: 'assets/shoe_x.png',
    dominantColors: [Colors.red.shade800, Colors.red.shade400],
  );

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_updateScroll);
    // Initialize with the first product's colors
    _updateBackgroundColors(_currentProduct.dominantColors);
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

  // In a real application, you would extract dominant colors from the image dynamically.
  // For this example, we are using pre-defined dominantColors in the Product model.
  // A package like `palette_generator` could be used for this.

  @override
  Widget build(BuildContext context) {
    // Calculate rotation based on scroll offset
    // The rotation factor can be adjusted for desired sensitivity
    final double rotationAngle = (_scrollOffset / 300) * math.pi * 2; // Full rotation every 300 pixels

    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
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
                  child: Transform(
                    alignment: Alignment.center,
                    transform: Matrix4.identity()
                      ..setEntry(3, 2, 0.001) // Perspective
                      ..rotateY(rotationAngle), // Y-axis rotation
                    child: Image.asset(
                      _currentProduct.imagePath,
                      fit: BoxFit.contain,
                      height: 300,
                    ),
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
    super.dispose();
  }
}

class Product {
  final String name;
  final String imagePath;
  final List<Color> dominantColors;

  Product({
    required this.name,
    required this.imagePath,
    required this.dominantColors,
  });
}

// To make the dynamic color palette truly dynamic based on the image,
// you would typically use a package like `palette_generator`.
// Example usage (conceptual):
/*
import 'package:palette_generator/palette_generator.dart';

Future<List<Color>> _updatePalette(String imagePath) async {
  final PaletteGenerator generator = await PaletteGenerator.fromImageProvider(
    AssetImage(imagePath),
    maximumColorCount: 2,
  );
  return generator.colors.toList();
}
*/

// Remember to add product images to your `pubspec.yaml` under the `assets` section.
// For example:
/*
flutter:
  uses-material-design: true
  assets:
    - assets/shoe_x.png
    - assets/handbag_y.png
*/
