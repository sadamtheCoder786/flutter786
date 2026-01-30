import '../../helpers/ExportImports.dart';// Import your colors.dart (adjust path if needed)

class CalculateScreen extends StatefulWidget {
  const CalculateScreen({super.key});

  @override
  State<CalculateScreen> createState() => _CalculateScreenState();
}

class _CalculateScreenState extends State<CalculateScreen> {
  // List to hold appliances
  List<Map<String, dynamic>> appliances = [];

  // Controllers for input fields
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _wattageController = TextEditingController();

  // Quantity counter
  int _quantity = 1;

  // Calculate total wattage
  double get totalWattage {
    double total = 0;
    for (var appliance in appliances) {
      total += (appliance['wattage'] as num) * (appliance['quantity'] as int);
    }
    return total;
  }

  void _addAppliance() {
    if (_nameController.text.isEmpty || _wattageController.text.isEmpty) {
      Get.snackbar('Error', 'Please enter appliance name and wattage',
          backgroundColor: Colors.red.withOpacity(0.8), colorText: Colors.white);
      return;
    }

    double wattage = double.tryParse(_wattageController.text) ?? 0;

    setState(() {
      appliances.add({
        'name': _nameController.text.trim(),
        'wattage': wattage,
        'quantity': _quantity,
      });

      // Reset inputs
      _nameController.clear();
      _wattageController.clear();
      _quantity = 1;
    });

    Get.snackbar('Added', '${_nameController.text} added!',
        backgroundColor: SecondaryLightColor.withOpacity(0.9),
        colorText: NeutralDarkColor);
  }

  void _removeAppliance(int index) {
    setState(() {
      appliances.removeAt(index);
    });
  }

  @override
  void dispose() {
    _nameController.dispose();
    _wattageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: PrimaryDarkColor,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: const Text(
          'Solar Watt Calculator',
          style: TextStyle(
            color: NeutralLightColor,
            fontSize: 22,
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: false,
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Padding(
            padding: EdgeInsets.symmetric(horizontal: 16),
            child: Text(
              'Calculate your solar needs',
              style: TextStyle(color: PrimaryLightColor, fontSize: 16),
            ),
          ),
          const SizedBox(height: 24),

          // Add Appliance Card
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Container(
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
                      Icon(Icons.bolt, color: SecondaryLightColor, size: 24),
                      SizedBox(width: 8),
                      Text(
                        'Add Appliance',
                        style: TextStyle(
                          color: NeutralLightColor,
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),

                  // Appliance Name
                  TextField(
                    controller: _nameController,
                    decoration: InputDecoration(
                      filled: true,
                      fillColor: PrimaryColor,
                      hintText: 'Appliance name (e.g., LED TV, Fan, AC)',
                      hintStyle: TextStyle(color: PrimaryLightColor),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: BorderSide.none,
                      ),
                    ),
                    style: const TextStyle(color: NeutralLightColor),
                  ),
                  const SizedBox(height: 12),

                  // Wattage
                  TextField(
                    controller: _wattageController,
                    keyboardType: TextInputType.number,
                    decoration: InputDecoration(
                      filled: true,
                      fillColor: PrimaryColor,
                      hintText: 'Wattage (e.g., 100)',
                      hintStyle: TextStyle(color: PrimaryLightColor),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: BorderSide.none,
                      ),
                      suffixText: 'W',
                    ),
                    style: const TextStyle(color: NeutralLightColor),
                  ),
                  const SizedBox(height: 16),

                  // Quantity Counter
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text(
                        'Number of items',
                        style: TextStyle(color: NeutralLightColor, fontSize: 16),
                      ),
                      Row(
                        children: [
                          IconButton(
                            onPressed: () {
                              if (_quantity > 1) {
                                setState(() => _quantity--);
                              }
                            },
                            icon: const Icon(Icons.remove_circle_outline),
                            color: PrimaryLightColor,
                          ),
                          Text(
                            '$_quantity',
                            style: const TextStyle(
                              color: NeutralLightColor,
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          IconButton(
                            onPressed: () {
                              setState(() => _quantity++);
                            },
                            icon: const Icon(Icons.add_circle_outline),
                            color: SecondaryLightColor,
                          ),
                        ],
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),

                  // Add Button
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton.icon(
                      onPressed: _addAppliance,
                      icon: const Icon(Icons.add, size: 20),
                      label: const Text('Add Appliance'),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: SecondaryLightColor,
                        foregroundColor: NeutralDarkColor,
                        padding: const EdgeInsets.symmetric(vertical: 14),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(30),
                        ),
                        elevation: 5,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),

          const SizedBox(height: 24),

          // List of Added Appliances
          const Padding(
            padding: EdgeInsets.symmetric(horizontal: 16),
            child: Text(
              'Added Appliances',
              style: TextStyle(
                color: NeutralLightColor,
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          const SizedBox(height: 8),

          Expanded(
            child: appliances.isEmpty
                ? const Center(
              child: Text(
                'No appliances added yet.\nStart by adding one above!',
                textAlign: TextAlign.center,
                style: TextStyle(color: PrimaryLightColor, fontSize: 16),
              ),
            )
                : ListView.builder(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              itemCount: appliances.length,
              itemBuilder: (context, index) {
                final appliance = appliances[index];
                final subtotal =
                    (appliance['wattage'] as double) * (appliance['quantity'] as int);

                return Card(
                  color: PrimaryColor.withOpacity(0.6),
                  margin: const EdgeInsets.symmetric(vertical: 6),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: ListTile(
                    title: Text(
                      appliance['name'],
                      style: const TextStyle(
                        color: NeutralLightColor,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    subtitle: Text(
                      '${appliance['wattage']}W × ${appliance['quantity']} = ${subtotal.toStringAsFixed(0)}W',
                      style: const TextStyle(color: PrimaryLightColor),
                    ),
                    trailing: IconButton(
                      icon: const Icon(Icons.delete_outline, color: Colors.redAccent),
                      onPressed: () => _removeAppliance(index),
                    ),
                  ),
                );
              },
            ),
          ),

          // Total Wattage Footer
          Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: PrimaryColor.withOpacity(0.8),
              borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.3),
                  blurRadius: 10,
                ),
              ],
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  'Total Load Required',
                  style: TextStyle(
                    color: NeutralLightColor,
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Text(
                  '${totalWattage.toStringAsFixed(0)} Watts',
                  style: TextStyle(
                    color: SecondaryLightColor,
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}