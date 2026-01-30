import '../../helpers/ExportImports.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class ServiceGuyScreen extends StatefulWidget {
  final Map<String, dynamic> user;

  const ServiceGuyScreen({super.key, required this.user});

  @override
  State<ServiceGuyScreen> createState() => _ServiceGuyScreenState();
}

class _ServiceGuyScreenState extends State<ServiceGuyScreen> {
  late TextEditingController serviceNameController;
  late TextEditingController serviceTypeController;
  late TextEditingController priceController;
  late TextEditingController descriptionController;

  List<Map<String, dynamic>> services = [];
  List<String> serviceTypes = ['Electrician', 'Cleaning', 'Plumbing', 'Carpentry', 'Painting', 'Solar Installation', 'Other'];
  String selectedServiceType = 'Electrician';

  @override
  void initState() {
    super.initState();
    serviceNameController = TextEditingController();
    serviceTypeController = TextEditingController();
    priceController = TextEditingController();
    descriptionController = TextEditingController();
    fetchServices();
  }

  @override
  void dispose() {
    serviceNameController.dispose();
    serviceTypeController.dispose();
    priceController.dispose();
    descriptionController.dispose();
    super.dispose();
  }

  // Fetch services from database
  void fetchServices() async {
    try {
      final response = await http.get(
        Uri.parse('http://localhost:3000/getServices/${widget.user['id']}'),
      );

      if (response.statusCode == 200) {
        final responseBody = jsonDecode(response.body);
        final List<dynamic> servicesFromDb = responseBody['services'];

        setState(() {
          services = servicesFromDb.map((s) => {
            'id': s['id'],
            'name': s['service_name'],
            'type': s['service_type'],
            'price': s['price'].toString(),
            'description': s['description'],
          }).toList();
        });

        print('✓ Fetched ${services.length} services from database');
      }
    } catch (e) {
      print('Error fetching services: $e');
    }
  }

  // Add service to database
  Future<void> addServiceToDb(String name, String type, String price, String description) async {
    try {
      print('DEBUG: Starting addServiceToDb');
      print('DEBUG: Service Guy ID: ${widget.user['id']}');
      print('DEBUG: Service Name: $name');
      print('DEBUG: Service Type: $type');
      print('DEBUG: Price: $price');
      print('DEBUG: Description: $description');

      final body = jsonEncode(<String, dynamic>{
        'serviceGuyId': widget.user['id'],
        'serviceName': name,
        'serviceType': type,
        'price': double.parse(price),
        'description': description,
      });

      print('DEBUG: Request body: $body');

      final response = await http.post(
        Uri.parse('http://localhost:3000/addService'),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
        body: body,
      );

      print('DEBUG: Response status: ${response.statusCode}');
      print('DEBUG: Response body: ${response.body}');

      if (response.statusCode == 201) {
        print('✓ Service added to database');
        fetchServices();
      } else {
        print('Failed to add service: ${response.body}');
      }
    } catch (e) {
      print('Error adding service: $e');
    }
  }

  // Delete service from database
  Future<void> deleteServiceFromDb(int serviceId) async {
    try {
      final response = await http.delete(
        Uri.parse('http://localhost:3000/deleteService/$serviceId'),
      );

      if (response.statusCode == 200) {
        print('✓ Service deleted from database');
        fetchServices();
      } else {
        print('Failed to delete service: ${response.body}');
      }
    } catch (e) {
      print('Error deleting service: $e');
    }
  }

  // Update service in database
  Future<void> updateServiceInDb(int serviceId, String name, String type, String price, String description) async {
    try {
      final response = await http.put(
        Uri.parse('http://localhost:3000/updateService/$serviceId'),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
        body: jsonEncode(<String, dynamic>{
          'serviceName': name,
          'serviceType': type,
          'price': double.parse(price),
          'description': description,
        }),
      );

      if (response.statusCode == 200) {
        print('✓ Service updated in database');
        fetchServices();
      } else {
        print('Failed to update service: ${response.body}');
      }
    } catch (e) {
      print('Error updating service: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: PrimaryDarkColor,
        title: const Text('Service Dashboard'),
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
                    const SizedBox(height: 8),
                    Text(
                      'Role: Service Professional',
                      style: const TextStyle(
                        color: SecondaryLightColor,
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 24),

              // Add Service Section
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
                      'Add New Service',
                      style: TextStyle(
                        color: SecondaryLightColor,
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 16),
                    TextField(
                      controller: serviceNameController,
                      decoration: InputDecoration(
                        filled: true,
                        fillColor: PrimaryDarkColor,
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8),
                          borderSide: BorderSide.none,
                        ),
                        hintText: 'Service Name',
                        hintStyle: const TextStyle(color: PrimaryLightColor),
                      ),
                      style: const TextStyle(color: NeutralLightColor),
                    ),
                    const SizedBox(height: 12),
                    // Service Type Dropdown
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 12),
                      decoration: BoxDecoration(
                        color: PrimaryDarkColor,
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: DropdownButton<String>(
                        value: selectedServiceType,
                        isExpanded: true,
                        dropdownColor: PrimaryColor,
                        style: const TextStyle(color: NeutralLightColor, fontSize: 16),
                        underline: const SizedBox(),
                        onChanged: (String? newValue) {
                          setState(() {
                            selectedServiceType = newValue!;
                          });
                        },
                        items: serviceTypes.map<DropdownMenuItem<String>>((String value) {
                          return DropdownMenuItem<String>(
                            value: value,
                            child: Text(value),
                          );
                        }).toList(),
                      ),
                    ),
                    const SizedBox(height: 12),
                    TextField(
                      controller: priceController,
                      decoration: InputDecoration(
                        filled: true,
                        fillColor: PrimaryDarkColor,
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8),
                          borderSide: BorderSide.none,
                        ),
                        hintText: 'Price',
                        hintStyle: const TextStyle(color: PrimaryLightColor),
                      ),
                      style: const TextStyle(color: NeutralLightColor),
                      keyboardType: TextInputType.number,
                    ),
                    const SizedBox(height: 12),
                    TextField(
                      controller: descriptionController,
                      decoration: InputDecoration(
                        filled: true,
                        fillColor: PrimaryDarkColor,
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8),
                          borderSide: BorderSide.none,
                        ),
                        hintText: 'Service Description',
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
                          if (serviceNameController.text.isEmpty ||
                              priceController.text.isEmpty) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                content: Text('❌ Please fill in all required fields'),
                                backgroundColor: Colors.red,
                              ),
                            );
                            return;
                          }

                          // Validate price is a valid number
                          try {
                            double.parse(priceController.text);
                          } catch (e) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                content: Text('❌ Price must be a valid number'),
                                backgroundColor: Colors.red,
                              ),
                            );
                            return;
                          }

                          // Add service to database
                          await addServiceToDb(
                            serviceNameController.text,
                            selectedServiceType,
                            priceController.text,
                            descriptionController.text,
                          );

                          serviceNameController.clear();
                          priceController.clear();
                          descriptionController.clear();

                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content: Text('✓ Service added successfully!'),
                              backgroundColor: Colors.green,
                            ),
                          );
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: SecondaryLightColor,
                          padding: const EdgeInsets.symmetric(vertical: 12),
                        ),
                        child: const Text(
                          'Add Service',
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

              // Services List
              if (services.isNotEmpty)
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Your Services',
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
                      itemCount: services.length,
                      itemBuilder: (context, index) {
                        final service = services[index];
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
                                      service['name'],
                                      style: const TextStyle(
                                        color: NeutralLightColor,
                                        fontSize: 16,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    const SizedBox(height: 4),
                                    Text(
                                      service['type'],
                                      style: const TextStyle(
                                        color: SecondaryLightColor,
                                        fontSize: 13,
                                      ),
                                    ),
                                    const SizedBox(height: 4),
                                    Text(
                                      'Rs. ${service['price']}',
                                      style: const TextStyle(
                                        color: Colors.greenAccent,
                                        fontSize: 14,
                                        fontWeight: FontWeight.bold,
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
                                      serviceNameController.text = service['name'];
                                      priceController.text = service['price'];
                                      descriptionController.text = service['description'] ?? '';
                                      selectedServiceType = service['type'];

                                      showDialog(
                                        context: context,
                                        builder: (BuildContext context) {
                                          return StatefulBuilder(
                                            builder: (context, setDialogState) {
                                              return AlertDialog(
                                                backgroundColor: PrimaryColor,
                                                title: const Text(
                                                  'Edit Service',
                                                  style: TextStyle(color: SecondaryLightColor),
                                                ),
                                                content: Column(
                                                  mainAxisSize: MainAxisSize.min,
                                                  children: [
                                                    TextField(
                                                      controller: serviceNameController,
                                                      style: const TextStyle(color: NeutralLightColor),
                                                      decoration: InputDecoration(
                                                        filled: true,
                                                        fillColor: PrimaryDarkColor,
                                                        border: OutlineInputBorder(
                                                          borderRadius: BorderRadius.circular(8),
                                                        ),
                                                        hintText: 'Service Name',
                                                        hintStyle: const TextStyle(color: PrimaryLightColor),
                                                      ),
                                                    ),
                                                    const SizedBox(height: 12),
                                                    Container(
                                                      padding: const EdgeInsets.symmetric(horizontal: 12),
                                                      decoration: BoxDecoration(
                                                        color: PrimaryDarkColor,
                                                        borderRadius: BorderRadius.circular(8),
                                                      ),
                                                      child: DropdownButton<String>(
                                                        value: selectedServiceType,
                                                        isExpanded: true,
                                                        dropdownColor: PrimaryColor,
                                                        style: const TextStyle(color: NeutralLightColor),
                                                        underline: const SizedBox(),
                                                        onChanged: (String? newValue) {
                                                          setDialogState(() {
                                                            selectedServiceType = newValue!;
                                                          });
                                                        },
                                                        items: serviceTypes.map<DropdownMenuItem<String>>((String value) {
                                                          return DropdownMenuItem<String>(
                                                            value: value,
                                                            child: Text(value),
                                                          );
                                                        }).toList(),
                                                      ),
                                                    ),
                                                    const SizedBox(height: 12),
                                                    TextField(
                                                      controller: priceController,
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
                                                      await updateServiceInDb(
                                                        service['id'],
                                                        serviceNameController.text,
                                                        selectedServiceType,
                                                        priceController.text,
                                                        descriptionController.text,
                                                      );
                                                      Navigator.pop(context);
                                                      ScaffoldMessenger.of(context).showSnackBar(
                                                        const SnackBar(
                                                          content: Text('✓ Service updated!'),
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
                                      );
                                    },
                                  ),
                                  IconButton(
                                    icon: const Icon(Icons.delete, color: Colors.red),
                                    onPressed: () {
                                      deleteServiceFromDb(service['id']);
                                      ScaffoldMessenger.of(context).showSnackBar(
                                        const SnackBar(
                                          content: Text('✓ Service deleted!'),
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
                      'No services added yet. Add your first service!',
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
