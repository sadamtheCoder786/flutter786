import '../../helpers/ExportImports.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class ShopOwnerScreen extends StatefulWidget {
  final Map<String, dynamic> user;

  const ShopOwnerScreen({super.key, required this.user});

  @override
  State<ShopOwnerScreen> createState() => _ShopOwnerScreenState();
}

class _ShopOwnerScreenState extends State<ShopOwnerScreen> {
  late TextEditingController productNameController;
  late TextEditingController productPriceController;
  late TextEditingController productDescriptionController;

  List<Map<String, dynamic>> products = [];

  @override
  void initState() {
    super.initState();
    productNameController = TextEditingController();
    productPriceController = TextEditingController();
    productDescriptionController = TextEditingController();
    fetchProducts();
  }

  @override
  void dispose() {
    productNameController.dispose();
    productPriceController.dispose();
    productDescriptionController.dispose();
    super.dispose();
  }

  // Fetch products from database
  void fetchProducts() async {
    try {
      final response = await http.get(
        Uri.parse('http://localhost:3000/getProducts/${widget.user['id']}'),
      );

      if (response.statusCode == 200) {
        final responseBody = jsonDecode(response.body);
        final List<dynamic> productsFromDb = responseBody['products'];

        setState(() {
          products = productsFromDb.map((p) => {
            'id': p['id'],
            'name': p['product_name'],
            'price': p['price'].toString(),
            'description': p['description'],
          }).toList();
        });

        print('✓ Fetched ${products.length} products from database');
      }
    } catch (e) {
      print('Error fetching products: $e');
    }
  }

  // Add product to database
  Future<void> addProductToDb(String name, String price, String description) async {
    try {
      print('DEBUG: Starting addProductToDb');
      print('DEBUG: Shopowner ID: ${widget.user['id']}');
      print('DEBUG: Product Name: $name');
      print('DEBUG: Price: $price');
      print('DEBUG: Description: $description');

      final body = jsonEncode(<String, dynamic>{
        'shopownerId': widget.user['id'],
        'productName': name,
        'price': double.parse(price),
        'description': description,
      });

      print('DEBUG: Request body: $body');

      final response = await http.post(
        Uri.parse('http://localhost:3000/addProduct'),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
        body: body,
      );

      print('DEBUG: Response status: ${response.statusCode}');
      print('DEBUG: Response body: ${response.body}');

      if (response.statusCode == 201) {
        print('✓ Product added to database');
        fetchProducts(); // Refresh the list
      } else {
        print('Failed to add product: ${response.body}');
      }
    } catch (e) {
      print('Error adding product: $e');
    }
  }

  // Delete product from database
  Future<void> deleteProductFromDb(int productId) async {
    try {
      final response = await http.delete(
        Uri.parse('http://localhost:3000/deleteProduct/$productId'),
      );

      if (response.statusCode == 200) {
        print('✓ Product deleted from database');
        fetchProducts(); // Refresh the list
      } else {
        print('Failed to delete product: ${response.body}');
      }
    } catch (e) {
      print('Error deleting product: $e');
    }
  }

  // Update product in database
  Future<void> updateProductInDb(int productId, String name, String price, String description) async {
    try {
      final response = await http.put(
        Uri.parse('http://localhost:3000/updateProduct/$productId'),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
        body: jsonEncode(<String, dynamic>{
          'productName': name,
          'price': double.parse(price),
          'description': description,
        }),
      );

      if (response.statusCode == 200) {
        print('✓ Product updated in database');
        fetchProducts(); // Refresh the list
      } else {
        print('Failed to update product: ${response.body}');
      }
    } catch (e) {
      print('Error updating product: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: PrimaryDarkColor,
        title: const Text('Shop Owner Dashboard'),
        centerTitle: true,
        elevation: 0,
        actions: [
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: () {
              Get.offAll(() => const LoginScreen());
            },
          ),
        ],
      ),
      body: Container(
        color: PrimaryDarkColor,
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Column(
            children: [
              // Welcome section
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: PrimaryColor,
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Welcome, ${widget.user['first_name']}!',
                      style: const TextStyle(
                        color: NeutralLightColor,
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'Email: ${widget.user['email']}',
                      style: const TextStyle(
                        color: PrimaryLightColor,
                        fontSize: 14,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 24),

              // Add Product Section
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: PrimaryColor,
                  borderRadius: BorderRadius.circular(10),
                  border: Border.all(color: SecondaryLightColor, width: 2),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Add New Product',
                      style: TextStyle(
                        color: SecondaryLightColor,
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 16),
                    TextField(
                      controller: productNameController,
                      decoration: InputDecoration(
                        filled: true,
                        fillColor: PrimaryDarkColor,
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8),
                          borderSide: BorderSide.none,
                        ),
                        hintText: 'Product Name',
                        hintStyle: const TextStyle(color: PrimaryLightColor),
                      ),
                      style: const TextStyle(color: NeutralLightColor),
                    ),
                    const SizedBox(height: 12),
                    TextField(
                      controller: productPriceController,
                      decoration: InputDecoration(
                        filled: true,
                        fillColor: PrimaryDarkColor,
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8),
                          borderSide: BorderSide.none,
                        ),
                        hintText: 'Product Price',
                        hintStyle: const TextStyle(color: PrimaryLightColor),
                      ),
                      style: const TextStyle(color: NeutralLightColor),
                      keyboardType: TextInputType.number,
                    ),
                    const SizedBox(height: 12),
                    TextField(
                      controller: productDescriptionController,
                      decoration: InputDecoration(
                        filled: true,
                        fillColor: PrimaryDarkColor,
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8),
                          borderSide: BorderSide.none,
                        ),
                        hintText: 'Product Description',
                        hintStyle: const TextStyle(color: PrimaryLightColor),
                      ),
                      style: const TextStyle(color: NeutralLightColor),
                      maxLines: 3,
                    ),
                    const SizedBox(height: 16),
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        onPressed: () async {
                          if (productNameController.text.isEmpty ||
                              productPriceController.text.isEmpty) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                content: Text('❌ Please fill in all fields'),
                                backgroundColor: Colors.red,
                              ),
                            );
                            return;
                          }

                          // Validate price is a valid number
                          try {
                            double.parse(productPriceController.text);
                          } catch (e) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                content: Text('❌ Price must be a valid number'),
                                backgroundColor: Colors.red,
                              ),
                            );
                            return;
                          }

                          // Add product to database
                          await addProductToDb(
                            productNameController.text,
                            productPriceController.text,
                            productDescriptionController.text,
                          );

                          productNameController.clear();
                          productPriceController.clear();
                          productDescriptionController.clear();

                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content: Text('✓ Product added successfully!'),
                              backgroundColor: Colors.green,
                            ),
                          );
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: SecondaryLightColor,
                          padding: const EdgeInsets.symmetric(vertical: 12),
                        ),
                        child: const Text(
                          'Add Product',
                          style: TextStyle(
                            color: NeutralDarkColor,
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 24),

              // Products List
              if (products.isNotEmpty)
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Your Products',
                      style: TextStyle(
                        color: NeutralLightColor,
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 12),
                    ListView.builder(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      itemCount: products.length,
                      itemBuilder: (context, index) {
                        final product = products[index];
                        return Container(
                          margin: const EdgeInsets.only(bottom: 12),
                          padding: const EdgeInsets.all(12),
                          decoration: BoxDecoration(
                            color: PrimaryColor,
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      product['name'],
                                      style: const TextStyle(
                                        color: NeutralLightColor,
                                        fontSize: 16,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    const SizedBox(height: 4),
                                    Text(
                                      'Rs. ${product['price']}',
                                      style: const TextStyle(
                                        color: SecondaryLightColor,
                                        fontSize: 14,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              Row(
                                children: [
                                  IconButton(
                                    icon: const Icon(Icons.edit, color: Colors.blue),
                                    onPressed: () {
                                      productNameController.text = product['name'];
                                      productPriceController.text = product['price'];
                                      productDescriptionController.text = product['description'];

                                      showDialog(
                                        context: context,
                                        builder: (BuildContext context) {
                                          return AlertDialog(
                                            backgroundColor: PrimaryColor,
                                            title: const Text(
                                              'Edit Product',
                                              style: TextStyle(color: SecondaryLightColor),
                                            ),
                                            content: Column(
                                              mainAxisSize: MainAxisSize.min,
                                              children: [
                                                TextField(
                                                  controller: productNameController,
                                                  style: const TextStyle(color: NeutralLightColor),
                                                  decoration: InputDecoration(
                                                    filled: true,
                                                    fillColor: PrimaryDarkColor,
                                                    border: OutlineInputBorder(
                                                      borderRadius: BorderRadius.circular(8),
                                                    ),
                                                    hintText: 'Product Name',
                                                    hintStyle: const TextStyle(color: PrimaryLightColor),
                                                  ),
                                                ),
                                                const SizedBox(height: 12),
                                                TextField(
                                                  controller: productPriceController,
                                                  style: const TextStyle(color: NeutralLightColor),
                                                  decoration: InputDecoration(
                                                    filled: true,
                                                    fillColor: PrimaryDarkColor,
                                                    border: OutlineInputBorder(
                                                      borderRadius: BorderRadius.circular(8),
                                                    ),
                                                    hintText: 'Price',
                                                    hintStyle: const TextStyle(color: PrimaryLightColor),
                                                  ),
                                                ),
                                              ],
                                            ),
                                            actions: [
                                              TextButton(
                                                onPressed: () => Navigator.pop(context),
                                                child: const Text('Cancel', style: TextStyle(color: PrimaryLightColor)),
                                              ),
                                              TextButton(
                                                onPressed: () async {
                                                  await updateProductInDb(
                                                    product['id'],
                                                    productNameController.text,
                                                    productPriceController.text,
                                                    productDescriptionController.text,
                                                  );
                                                  Navigator.pop(context);
                                                  ScaffoldMessenger.of(context).showSnackBar(
                                                    const SnackBar(
                                                      content: Text('✓ Product updated!'),
                                                      backgroundColor: Colors.green,
                                                    ),
                                                  );
                                                },
                                                child: const Text('Save', style: TextStyle(color: SecondaryLightColor)),
                                              ),
                                            ],
                                          );
                                        },
                                      );
                                    },
                                  ),
                                  IconButton(
                                    icon: const Icon(Icons.delete, color: Colors.red),
                                    onPressed: () {
                                      deleteProductFromDb(product['id']);
                                      ScaffoldMessenger.of(context).showSnackBar(
                                        const SnackBar(
                                          content: Text('✓ Product deleted!'),
                                          backgroundColor: Colors.orange,
                                        ),
                                      );
                                    },
                                  ),
                                ],
                              ),
                            ],
                          ),
                        );
                      },
                    ),
                  ],
                )
              else
                Center(
                  child: Padding(
                    padding: const EdgeInsets.all(32),
                    child: Text(
                      'No products added yet. Add your first product!',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: PrimaryLightColor,
                        fontSize: 16,
                      ),
                    ),
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}
