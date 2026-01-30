import '../../helpers/ExportImports.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class SignupScreen extends StatefulWidget {
  const SignupScreen({super.key});

  @override
  State<SignupScreen> createState() => _SignupScreenState();
}

class _SignupScreenState extends State<SignupScreen> {
  late TextEditingController firstNameController;
  late TextEditingController lastNameController;
  late TextEditingController emailController;
  late TextEditingController passwordController;
  late TextEditingController confirmPasswordController;
  
  String selectedRole = 'customer'; // Default role
  final List<String> roles = ['customer', 'shopowner', 'service_guy'];

  @override
  void initState() {
    super.initState();
    firstNameController = TextEditingController();
    lastNameController = TextEditingController();
    emailController = TextEditingController();
    passwordController = TextEditingController();
    confirmPasswordController = TextEditingController();
  }

  @override
  void dispose() {
    firstNameController.dispose();
    lastNameController.dispose();
    emailController.dispose();
    passwordController.dispose();
    confirmPasswordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        color: PrimaryDarkColor, // Dark background
        child: Center(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 32.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // Logo with glow
                Container(
                  width: 80,
                  height: 80,
                  decoration: BoxDecoration(
                    color: SecondaryLightColor, // Yellow logo background
                    borderRadius: BorderRadius.circular(16),
                    boxShadow: [
                      BoxShadow(
                        color: SecondaryLightColor.withOpacity(0.5),
                        blurRadius: 20,
                        spreadRadius: 5,
                      ),
                    ],
                  ),
                  child: const Icon(
                    Icons.wb_sunny_outlined, // Sun icon (replace with custom if available)
                    color: NeutralDarkColor, // Black icon
                    size: 50,
                  ),
                ),
                const SizedBox(height: 16),
                // Title
                const Text(
                  'SolarEase',
                  style: TextStyle(
                    color: NeutralLightColor, // White
                    fontSize: 28,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 4),
                // Subtitle
                const Text(
                  'Smart Solar Solutions',
                  style: TextStyle(
                    color: PrimaryLightColor, // Light gray
                    fontSize: 16,
                  ),
                ),
                const SizedBox(height: 48),
                // First Name Input
                TextField(
                  controller: firstNameController,
                  decoration: InputDecoration(
                    filled: true,
                    fillColor: PrimaryColor, // Dark input fill
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                      borderSide: BorderSide.none,
                    ),
                    prefixIcon: const Icon(
                      Icons.person,
                      color: PrimaryLightColor, // Gray icon
                    ),
                    hintText: 'First Name',
                    hintStyle: const TextStyle(color: PrimaryLightColor), // Gray hint
                  ),
                  style: const TextStyle(color: NeutralLightColor), // White input text
                ),
                const SizedBox(height: 16),
                // Last Name Input
                TextField(
                  controller: lastNameController,
                  decoration: InputDecoration(
                    filled: true,
                    fillColor: PrimaryColor, // Dark input fill
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                      borderSide: BorderSide.none,
                    ),
                    prefixIcon: const Icon(
                      Icons.person_outline,
                      color: PrimaryLightColor, // Gray icon
                    ),
                    hintText: 'Last Name',
                    hintStyle: const TextStyle(color: PrimaryLightColor), // Gray hint
                  ),
                  style: const TextStyle(color: NeutralLightColor), // White input text
                ),
                const SizedBox(height: 16),
                // Email Input
                TextField(
                  controller: emailController,
                  decoration: InputDecoration(
                    filled: true,
                    fillColor: PrimaryColor, // Dark input fill
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                      borderSide: BorderSide.none,
                    ),
                    prefixIcon: const Icon(
                      Icons.mail,
                      color: PrimaryLightColor, // Gray icon
                    ),
                    hintText: 'Email address',
                    hintStyle: const TextStyle(color: PrimaryLightColor), // Gray hint
                  ),
                  style: const TextStyle(color: NeutralLightColor), // White input text
                ),
                const SizedBox(height: 16),
                // Password Input
                TextField(
                  controller: passwordController,
                  obscureText: true,
                  decoration: InputDecoration(
                    filled: true,
                    fillColor: PrimaryColor, // Dark input fill
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                      borderSide: BorderSide.none,
                    ),
                    prefixIcon: const Icon(
                      Icons.lock,
                      color: PrimaryLightColor, // Gray icon
                    ),
                    hintText: 'Password',
                    hintStyle: const TextStyle(color: PrimaryLightColor), // Gray hint
                  ),
                  style: const TextStyle(color: NeutralLightColor), // White input text
                ),
                const SizedBox(height: 16),
                // Role Selection Dropdown
                DropdownButtonFormField<String>(
                  value: selectedRole,
                  decoration: InputDecoration(
                    filled: true,
                    fillColor: PrimaryColor, // Dark input fill
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                      borderSide: BorderSide.none,
                    ),
                    prefixIcon: const Icon(
                      Icons.person_outline,
                      color: PrimaryLightColor, // Gray icon
                    ),
                    hintText: 'Select Role',
                    hintStyle: const TextStyle(color: PrimaryLightColor),
                    labelText: 'Select Your Role',
                    labelStyle: const TextStyle(color: PrimaryLightColor),
                  ),
                  dropdownColor: PrimaryColor,
                  items: roles.map((String role) {
                    return DropdownMenuItem<String>(
                      value: role,
                      child: Text(
                        role.replaceAll('_', ' ').toUpperCase(),
                        style: const TextStyle(color: NeutralLightColor),
                      ),
                    );
                  }).toList(),
                  onChanged: (String? newValue) {
                    setState(() {
                      selectedRole = newValue!;
                    });
                  },
                ),
                const SizedBox(height: 32),
                // Sign Up Button with glow
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: () async {
                      final response = await http.post(
                        Uri.parse('http://localhost:3000/signup'),
                        headers: <String, String>{
                          'Content-Type': 'application/json; charset=UTF-8',
                        },
                        body: jsonEncode(<String, String>{
                          'firstName': firstNameController.text,
                          'lastName': lastNameController.text,
                          'email': emailController.text,
                          'password': passwordController.text,
                          'role': selectedRole,
                        }),
                      );
                      if (response.statusCode == 201) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text('✓ Signup successful! Welcome!'),
                            backgroundColor: Colors.green,
                          ),
                        );
                        firstNameController.clear();
                        lastNameController.clear();
                        emailController.clear();
                        passwordController.clear();
                        confirmPasswordController.clear();
                      } else if (response.statusCode == 500) {
                        final errorBody = jsonDecode(response.body);
                        String errorMessage = errorBody['error'] ?? 'Signup failed';
                        
                        if (errorMessage.contains('duplicate') || errorMessage.contains('already exists')) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content: Text('❌ Email already exists! Try a different email.'),
                              backgroundColor: Colors.red,
                            ),
                          );
                        } else {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text('❌ Error: $errorMessage'),
                              backgroundColor: Colors.red,
                            ),
                          );
                        }
                      } else {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text('❌ Signup failed'),
                            backgroundColor: Colors.red,
                          ),
                        );
                      }
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: SecondaryLightColor, // Yellow button
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(30),
                      ),
                      shadowColor: SecondaryLightColor.withOpacity(0.5),
                      elevation: 10, // For glow
                    ),
                    child: const Text(
                      'Sign Up',
                      style: TextStyle(
                        color: NeutralDarkColor, // Black text on button
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 16),
                // Login Link
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text(
                      'Already have an account? ',
                      style: TextStyle(
                        color: PrimaryLightColor, // Gray
                        fontSize: 14,
                      ),
                    ),
                    TextButton(
                      onPressed: () {
                        Get.back(); // Navigate back to LoginScreen
                      }, // Add login navigation
                      child: const Text(
                        'Login',
                        style: TextStyle(
                          color: SecondaryLightColor, // Yellow
                          fontSize: 14,
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}