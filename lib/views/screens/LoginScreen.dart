import '../../helpers/ExportImports.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  late TextEditingController emailController;
  late TextEditingController passwordController;

  @override
  void initState() {
    super.initState();
    emailController = TextEditingController();
    passwordController = TextEditingController();
  }

  @override
  void dispose() {
    emailController.dispose();
    passwordController.dispose();
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
                  "SolarEase",
                  style: TextStyle(
                    color: NeutralLightColor, // White
                    fontSize: 28,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 4),
                // Subtitle
                const Text(
                  "Smart Solar Solutions",
                  style: TextStyle(
                    color: PrimaryLightColor, // Light gray
                    fontSize: 16,
                  ),
                ),
                const SizedBox(height: 48),
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
                const SizedBox(height: 8),
                // Forgot Password
                Align(
                  alignment: Alignment.centerRight,
                  child: TextButton(
                    onPressed: () {
                      // Get.to(() => const ForgotPasswordScreen());
                    }, // Add navigation logic
                    child: const Text(
                      'Forgot Password?',
                      style: TextStyle(
                        color: SecondaryLightColor, // Yellow
                        fontSize: 14,
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 16),
                // Login Button with glow
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: () async {
                      if (emailController.text.isEmpty || passwordController.text.isEmpty) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text('❌ Please enter email and password'),
                            backgroundColor: Colors.red,
                          ),
                        );
                        return;
                      }

                      try {
                        // Call the backend login API
                        final response = await http.post(
                          Uri.parse('http://localhost:3000/login'),
                          headers: <String, String>{
                            'Content-Type': 'application/json; charset=UTF-8',
                          },
                          body: jsonEncode(<String, String>{
                            'email': emailController.text,
                            'password': passwordController.text,
                          }),
                        );
                        
                        print('Login Response Status: ${response.statusCode}');
                        print('Login Response Body: ${response.body}');
                        
                        if (response.statusCode == 200) {
                          final responseBody = jsonDecode(response.body);
                          final user = responseBody['user'];
                          
                          print('DEBUG: User role received: ${user['role']}');
                          print('DEBUG: User role type: ${user['role'].runtimeType}');
                          
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text('✓ Welcome ${user['first_name']}!'),
                              backgroundColor: Colors.green,
                              duration: const Duration(seconds: 2),
                            ),
                          );
                          
                          // Wait a moment then redirect based on user role
                          await Future.delayed(const Duration(milliseconds: 500));
                          
                          if (user['role'] == 'shopowner') {
                            print('DEBUG: Redirecting to ShopOwnerScreen');
                            Get.offAll(() => ShopOwnerScreen(user: user));
                          } else if (user['role'] == 'service_guy') {
                            print('DEBUG: Redirecting to ServiceGuyScreen');
                            Get.offAll(() => ServiceGuyScreen(user: user));
                          } else {
                            // Default to DashboardScreen for customers and other roles
                            print('DEBUG: Redirecting to DashboardScreen (default)');
                            Get.offAll(() => const DashboardScreen());
                          }
                        } else if (response.statusCode == 401) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content: Text('❌ Invalid email or password'),
                              backgroundColor: Colors.red,
                            ),
                          );
                        } else {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content: Text('❌ Login failed. Please try again.'),
                              backgroundColor: Colors.red,
                            ),
                          );
                        }
                      } catch (e) {
                        print('Login Error: $e');
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text('❌ Error: $e'),
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
                      'Login',
                      style: TextStyle(
                        color: NeutralDarkColor, // Black text on button
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 16),
                // Sign Up Link
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text(
                      "Don't have an account? ",
                      style: TextStyle(
                        color: PrimaryLightColor, // Gray
                        fontSize: 14,
                      ),
                    ),
                    TextButton(
                      onPressed: () {
                        Get.to(() => const SignupScreen());
                      }, // Add sign up navigation
                      child: const Text(
                        'Sign Up',
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