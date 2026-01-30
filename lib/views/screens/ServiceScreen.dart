import 'package:intl/intl.dart';
import '../../helpers/ExportImports.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class ServicesScreen extends StatefulWidget {
  const ServicesScreen({super.key});

  @override
  State<ServicesScreen> createState() => _ServicesScreenState();
}

class _ServicesScreenState extends State<ServicesScreen> {
  // Static fallback services
  final List<Map<String, dynamic>> staticServices = [
    {
      'title': 'Installation',
      'description': 'Professional solar panel installation service',
      'price': 'Rs 5000',
      'icon': Icons.handyman,
      'selected': false,
      'imageUrl': '',
    },
    {
      'title': 'Cleaning',
      'description': 'Solar panel cleaning and maintenance',
      'price': 'Rs 1500',
      'icon': Icons.cleaning_services,
      'selected': false,
      'imageUrl': '',
    },
    {
      'title': 'Electrician',
      'description': 'Expert electrical work and repairs',
      'price': 'Rs 2500',
      'icon': Icons.electrical_services,
      'selected': false,
      'imageUrl': '',
    },
  ];

  List<Map<String, dynamic>> dbServices = [];
  List<Map<String, dynamic>> services = [];
  bool isLoading = true;

  int? selectedServiceIndex;
  DateTime? selectedDate;
  String? selectedTimeSlot;

  final List<String> timeSlots = [
    '09:00 AM',
    '11:00 AM',
    '02:00 PM',
    '04:00 PM',
  ];

  @override
  void initState() {
    super.initState();
    fetchServices();
  }

  Future<void> fetchServices() async {
    try {
      final response = await http.get(
        Uri.parse('http://localhost:3000/getAllServices'),
      );

      if (response.statusCode == 200) {
        final responseBody = jsonDecode(response.body);
        final List<dynamic> servicesFromDb = responseBody['services'];

        setState(() {
          dbServices = servicesFromDb.map((s) => {
            'id': s['id'],
            'title': s['service_name'],
            'description': s['service_type'],
            'price': 'Rs ${s['price']}',
            'icon': Icons.handyman,
            'selected': false,
            'service_guy_name': s['service_guy_name'],
          }).toList();

          // Combine DB services with static ones
          services = [...dbServices, ...staticServices];
          isLoading = false;
        });

        print('✓ Fetched ${dbServices.length} services from database');
      } else {
        setState(() {
          services = staticServices;
          isLoading = false;
        });
      }
    } catch (e) {
      print('Error fetching services: $e');
      setState(() {
        services = staticServices;
        isLoading = false;
      });
    }
  }

  void _selectService(int index) {
    setState(() {
      if (selectedServiceIndex == index) {
        selectedServiceIndex = null;
      } else {
        selectedServiceIndex = index;
      }
    });
  }

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now().add(const Duration(days: 1)),
      firstDate: DateTime.now(),
      lastDate: DateTime.now().add(const Duration(days: 90)),
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: ColorScheme.dark(
              primary: SecondaryLightColor,
              surface: PrimaryColor,
            ),
          ),
          child: child!,
        );
      },
    );
    if (picked != null) {
      setState(() {
        selectedDate = picked;
      });
    }
  }

  void _bookNow() {
    if (selectedServiceIndex == null) {
      Get.snackbar('Error', 'Please select a service',
          backgroundColor: Colors.red.withOpacity(0.8), colorText: Colors.white);
      return;
    }
    if (selectedDate == null) {
      Get.snackbar('Error', 'Please select a date',
          backgroundColor: Colors.red.withOpacity(0.8), colorText: Colors.white);
      return;
    }
    if (selectedTimeSlot == null) {
      Get.snackbar('Error', 'Please select a time slot',
          backgroundColor: Colors.red.withOpacity(0.8), colorText: Colors.white);
      return;
    }

    // Success
    Get.snackbar(
      'Booked!',
      '${services[selectedServiceIndex!]['title']} booked for ${DateFormat('dd MMM yyyy').format(selectedDate!)} at $selectedTimeSlot',
      backgroundColor: SecondaryLightColor.withOpacity(0.9),
      colorText: NeutralDarkColor,
      duration: const Duration(seconds: 4),
    );

    // Reset form
    setState(() {
      selectedServiceIndex = null;
      selectedDate = null;
      selectedTimeSlot = null;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: PrimaryDarkColor,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: const Text(
          'Service Booking',
          style: TextStyle(
            color: NeutralLightColor,
            fontSize: 22,
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: false,
      ),
      body: isLoading
          ? const Center(
              child: CircularProgressIndicator(color: SecondaryLightColor),
            )
          : SingleChildScrollView(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Book professional solar services',
                    style: TextStyle(color: PrimaryLightColor, fontSize: 16),
                  ),
                  const SizedBox(height: 24),

            // Service Cards
            ...services.asMap().entries.map((entry) {
              int index = entry.key;
              Map<String, dynamic> service = entry.value;
              bool isSelected = selectedServiceIndex == index;

              return Padding(
                padding: const EdgeInsets.only(bottom: 16),
                child: Container(
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    color: PrimaryColor.withOpacity(0.6),
                    borderRadius: BorderRadius.circular(20),
                    border: isSelected
                        ? Border.all(color: SecondaryLightColor, width: 2)
                        : null,
                    boxShadow: isSelected
                        ? [
                      BoxShadow(
                        color: SecondaryLightColor.withOpacity(0.4),
                        blurRadius: 15,
                        spreadRadius: 2,
                      )
                    ]
                        : [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.2),
                        blurRadius: 10,
                        offset: const Offset(0, 5),
                      ),
                    ],
                  ),
                  child: Row(
                    children: [
                      Container(
                        width: 60,
                        height: 60,
                        decoration: BoxDecoration(
                          color: isSelected ? SecondaryLightColor : SecondaryLightColor.withOpacity(0.3),
                          borderRadius: BorderRadius.circular(16),
                        ),
                        child: Icon(
                          service['icon'],
                          color: isSelected ? NeutralDarkColor : SecondaryLightColor,
                          size: 32,
                        ),
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              service['title'],
                              style: const TextStyle(
                                color: NeutralLightColor,
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              service['description'],
                              style: const TextStyle(color: PrimaryLightColor, fontSize: 14),
                            ),
                            const SizedBox(height: 8),
                            Text(
                              service['price'],
                              style: const TextStyle(
                                color: SecondaryLightColor,
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                      ),
                      ElevatedButton(
                        onPressed: () => _selectService(index),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: isSelected ? SecondaryLightColor : PrimaryColor,
                          foregroundColor: isSelected ? NeutralDarkColor : NeutralLightColor,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(30),
                          ),
                          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                        ),
                        child: Text(isSelected ? 'Selected' : 'Select'),
                      ),
                    ],
                  ),
                ),
              );
            }).toList(),

            const SizedBox(height: 32),

            // Only show date/time picker if a service is selected
            if (selectedServiceIndex != null) ...[
              // Select Date
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: PrimaryColor.withOpacity(0.6),
                  borderRadius: BorderRadius.circular(20),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.2),
                      blurRadius: 10,
                      offset: const Offset(0, 5),
                    ),
                  ],
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: const [
                        Icon(Icons.calendar_today, color: SecondaryLightColor),
                        SizedBox(width: 12),
                        Text(
                          'Select Date',
                          style: TextStyle(
                            color: NeutralLightColor,
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),
                    InkWell(
                      onTap: () => _selectDate(context),
                      borderRadius: BorderRadius.circular(12),
                      child: Container(
                        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
                        decoration: BoxDecoration(
                          color: PrimaryColor,
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              selectedDate == null
                                  ? 'dd/mm/yyyy'
                                  : DateFormat('dd/MM/yyyy').format(selectedDate!),
                              style: TextStyle(
                                color: selectedDate == null ? PrimaryLightColor : NeutralLightColor,
                                fontSize: 16,
                              ),
                            ),
                            const Icon(Icons.date_range, color: PrimaryLightColor),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 24),

              // Select Time Slot
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: PrimaryColor.withOpacity(0.6),
                  borderRadius: BorderRadius.circular(20),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.2),
                      blurRadius: 10,
                      offset: const Offset(0, 5),
                    ),
                  ],
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: const [
                        Icon(Icons.access_time, color: SecondaryLightColor),
                        SizedBox(width: 12),
                        Text(
                          'Select Time Slot',
                          style: TextStyle(
                            color: NeutralLightColor,
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),
                    Wrap(
                      spacing: 12,
                      runSpacing: 12,
                      children: timeSlots.map((slot) {
                        bool isSelected = selectedTimeSlot == slot;
                        return ChoiceChip(
                          label: Text(slot),
                          selected: isSelected,
                          onSelected: (selected) {
                            if (selected) {
                              setState(() {
                                selectedTimeSlot = slot;
                              });
                            }
                          },
                          selectedColor: SecondaryLightColor,
                          backgroundColor: PrimaryColor,
                          labelStyle: TextStyle(
                            color: isSelected ? NeutralDarkColor : NeutralLightColor,
                            fontWeight: FontWeight.bold,
                          ),
                        );
                      }).toList(),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 32),

              // Book Now Button
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: _bookNow,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: SecondaryLightColor,
                    padding: const EdgeInsets.symmetric(vertical: 18),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30),
                    ),
                    elevation: 8,
                    shadowColor: SecondaryLightColor.withOpacity(0.5),
                  ),
                  child: const Text(
                    'Book Now',
                    style: TextStyle(
                      color: NeutralDarkColor,
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
            ],
          ],
        ),
            ),
    );
  }
}