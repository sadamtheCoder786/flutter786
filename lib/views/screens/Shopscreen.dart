import '../../helpers/ExportImports.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class ShopScreen extends StatefulWidget {
  const ShopScreen({super.key});

  @override
  State<ShopScreen> createState() => _ShopScreenState();
}

class _ShopScreenState extends State<ShopScreen> {
  List<Map<String, dynamic>> dbProducts = [];
  List<Map<String, dynamic>> products = [];
  bool isLoading = true;

  // Static fallback products
  static const List<Map<String, dynamic>> staticProducts = [
    {
      'title': 'Monocrystalline Solar Panel 450W',
      'rating': 4.8,
      'reviews': 156,
      'price': 'Rs 12,500',
      'imageUrl': 'https://cdn.shopify.com/s/files/1/0323/4090/2025/files/450W_e52ded3a-e8b1-43be-8613-900b2a41c8b8.jpg?v=1697676917',
    },
    {
      'title': 'Polycrystalline Solar Panel 350W',
      'rating': 4.5,
      'reviews': 89,
      'price': 'Rs 9,800',
      'imageUrl': 'https://www.brsolar.net/uploads/201916718/40w-to-350w-poly-solar-panles-good-quality35156290273.jpg',
    },
    {
      'title': 'Hybrid Solar Inverter 5kW',
      'rating': 4.7,
      'reviews': 124,
      'price': 'Rs 85,000',
      'imageUrl': 'https://m.media-amazon.com/images/I/61jUP84YyaL._AC_UF894,1000_QL80_.jpg',
    },
    {
      'title': 'Lithium Solar Battery 10kWh',
      'rating': 4.9,
      'reviews': 67,
      'price': 'Rs 250,000',
      'imageUrl': 'https://www.energy-storage.news/wp-content/uploads/2024/12/Invinity_ENDURIUM-1024x574.jpg',
    },
  ];

  @override
  void initState() {
    super.initState();
    fetchProducts();
  }

  Future<void> fetchProducts() async {
    try {
      final response = await http.get(
        Uri.parse('http://localhost:3000/getAllProducts'),
      );

      if (response.statusCode == 200) {
        final responseBody = jsonDecode(response.body);
        final List<dynamic> productsFromDb = responseBody['products'];

        setState(() {
          dbProducts = productsFromDb.map((p) => {
            'id': p['id'],
            'title': p['product_name'],
            'price': 'Rs ${p['price']}',
            'description': p['description'],
            'shopowner_name': p['shopowner_name'],
            'imageUrl': '',
            'rating': 4.5,
            'reviews': 0,
          }).toList();

          // Combine DB products with static ones
          products = [...dbProducts, ...staticProducts];
          isLoading = false;
        });

        print('✓ Fetched ${dbProducts.length} products from database');
      } else {
        setState(() {
          products = staticProducts;
          isLoading = false;
        });
      }
    } catch (e) {
      print('Error fetching products: $e');
      setState(() {
        products = staticProducts;
        isLoading = false;
      });
    }
  }

  Widget _buildProductCard(Map<String, dynamic> product) {
    return Container(
      width: MediaQuery.of(Get.context!).size.width / 2 - 24,
      margin: const EdgeInsets.all(8),
      decoration: BoxDecoration(
        color: PrimaryColor.withOpacity(0.6), // Slightly darker card background
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.3),
            blurRadius: 10,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Product Image
          ClipRRect(
            borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
            child: Image.network(
              product['imageUrl'],
              height: 100,
              width: double.infinity,
              fit: BoxFit.cover,
              loadingBuilder: (context, child, loadingProgress) {
                if (loadingProgress == null) return child;
                return Container(
                  height: 140,
                  color: Colors.grey[800],
                  child: const Center(child: CircularProgressIndicator(color: SecondaryLightColor)),
                );
              },
              errorBuilder: (context, error, stackTrace) {
                return Container(
                  height: 100,
                  color: Colors.grey[800],
                  child: const Icon(Icons.image_not_supported, color: PrimaryLightColor, size: 50),
                );
              },
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(12),
            child: Column(
              spacing: 1,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  product['title'],
                  style: const TextStyle(color: NeutralLightColor, fontSize: 14, fontWeight: FontWeight.bold),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
                Row(
                  children: [
                    const Icon(Icons.star, color: Colors.amber, size: 16),
                    Text(
                      '${product['rating']} (${product['reviews']})',
                      style: const TextStyle(color: PrimaryLightColor, fontSize: 12),
                    ),
                  ],
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      product['price'],
                      style: const TextStyle(
                        color: SecondaryLightColor,
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Container(
                      padding: const EdgeInsets.all(8),
                      decoration: const BoxDecoration(
                        color: SecondaryLightColor,
                        shape: BoxShape.circle,
                      ),
                      child: const Icon(Icons.shopping_cart, color: NeutralDarkColor, size: 20),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: PrimaryDarkColor,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: const Text(
          'Product Catalog',
          style: TextStyle(color: NeutralLightColor, fontSize: 22, fontWeight: FontWeight.bold),
        ),
        centerTitle: false,
      ),
      body: isLoading
          ? const Center(
              child: CircularProgressIndicator(color: SecondaryLightColor),
            )
          : Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: Text(
                    'Browse our solar solutions',
                    style: TextStyle(color: PrimaryLightColor, fontSize: 16),
                  ),
                ),
                const SizedBox(height: 16),
                // Search Bar
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: TextField(
                    decoration: InputDecoration(
                      filled: true,
                      fillColor: PrimaryColor,
                      hintText: 'Search products...',
                      hintStyle: TextStyle(color: PrimaryLightColor),
                      prefixIcon: const Icon(Icons.search, color: PrimaryLightColor),
                      suffixIcon: const Icon(Icons.filter_list, color: SecondaryLightColor),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(30),
                        borderSide: BorderSide.none,
                      ),
                    ),
                    style: const TextStyle(color: NeutralLightColor),
                  ),
                ),
                const SizedBox(height: 24),
                // Product Grid
                Expanded(
                  child: GridView.builder(
                    padding: const EdgeInsets.symmetric(horizontal: 8),
                    gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2,
                      childAspectRatio: 0.75,
                      mainAxisSpacing: 8,
                      crossAxisSpacing: 8,
                    ),
                    itemCount: products.length,
                    itemBuilder: (context, index) {
                      return _buildProductCard(products[index]);
                    },
                  ),
                ),
              ],
            ),
    );
  }
}