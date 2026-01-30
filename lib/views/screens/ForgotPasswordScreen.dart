import '../../helpers/ExportImports.dart';

class ForgotPasswordScreen extends StatelessWidget {
  const ForgotPasswordScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        color: PrimaryDarkColor, // Dark background same as Login/Signup
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
                    Icons.wb_sunny_outlined, // Sun icon
                    color: NeutralDarkColor,
                    size: 50,
                  ),
                ),
                const SizedBox(height: 16),
                // Title
                const Text(
                  'SolarEase',
                  style: TextStyle(
                    color: NeutralLightColor,
                    fontSize: 28,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 4),
                // Subtitle
                const Text(
                  'Smart Solar Solutions',
                  style: TextStyle(
                    color: PrimaryLightColor,
                    fontSize: 16,
                  ),
                ),
                const SizedBox(height: 32),
                // Page-specific title
                const Text(
                  'Forgot Password?',
                  style: TextStyle(
                    color: NeutralLightColor,
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 12),
                // Description
                const Text(
                  'Enter your email address and we will send you an OTP to reset your password.',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: PrimaryLightColor,
                    fontSize: 15,
                  ),
                ),
                const SizedBox(height: 48),
                // Email Input
                TextField(
                  keyboardType: TextInputType.emailAddress,
                  decoration: InputDecoration(
                    filled: true,
                    fillColor: PrimaryColor,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                      borderSide: BorderSide.none,
                    ),
                    prefixIcon: const Icon(
                      Icons.mail,
                      color: PrimaryLightColor,
                    ),
                    hintText: 'Email address',
                    hintStyle: const TextStyle(color: PrimaryLightColor),
                  ),
                  style: const TextStyle(color: NeutralLightColor),
                ),
                const SizedBox(height: 32),
                // Get OTP Button with glow
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: () {
                      // TODO: Implement send OTP logic
                      // After sending OTP, navigate to OTP verification screen
                      // Get.to(() => const OtpVerificationScreen());
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: SecondaryLightColor,
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(30),
                      ),
                      shadowColor: SecondaryLightColor.withOpacity(0.5),
                      elevation: 10,
                    ),
                    child: const Text(
                      'Get OTP',
                      style: TextStyle(
                        color: NeutralDarkColor,
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 24),
                // Back to Login Link
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text(
                      'Remember your password? ',
                      style: TextStyle(
                        color: PrimaryLightColor,
                        fontSize: 14,
                      ),
                    ),
                    TextButton(
                      onPressed: () {
                        Get.back(); // Go back to LoginScreen
                      },
                      child: const Text(
                        'Login',
                        style: TextStyle(
                          color: SecondaryLightColor,
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