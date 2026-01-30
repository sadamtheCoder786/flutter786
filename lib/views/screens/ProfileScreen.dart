import '../../helpers/ExportImports.dart';// Import your colors.dart (adjust path if needed)

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // Dummy user data (replace with actual user data later)
    const String userName = 'Muhammad Osama';
    const String userEmail = 'osama@gmail.com';
    const String memberSince = 'November 2025';

    return Scaffold(
      backgroundColor: PrimaryDarkColor,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: const Text(
          'Profile & Settings',
          style: TextStyle(
            color: NeutralLightColor,
            fontSize: 22,
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: false,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Manage your account',
              style: TextStyle(color: PrimaryLightColor, fontSize: 16),
            ),
            const SizedBox(height: 24),

            // User Profile Card
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
              child: Row(
                children: [
                  // Avatar
                  Container(
                    width: 70,
                    height: 70,
                    decoration: const BoxDecoration(
                      color: SecondaryLightColor,
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(
                      Icons.person,
                      color: NeutralDarkColor,
                      size: 40,
                    ),
                  ),
                  const SizedBox(width: 16),
                  // User Info
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          userName,
                          style: const TextStyle(
                            color: NeutralLightColor,
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          userEmail,
                          style: const TextStyle(color: PrimaryLightColor, fontSize: 14),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          'Member since $memberSince',
                          style: const TextStyle(color: PrimaryLightColor, fontSize: 14),
                        ),
                      ],
                    ),
                  ),
                  // Edit Button
                  IconButton(
                    onPressed: () {
                      // TODO: Navigate to Edit Profile
                      Get.snackbar('Edit Profile', 'Coming soon!',
                          backgroundColor: SecondaryLightColor.withOpacity(0.9),
                          colorText: NeutralDarkColor);
                    },
                    icon: const Icon(Icons.edit, color: SecondaryLightColor),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 32),

            // Language Section
            Container(
              width: double.infinity,
              padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 20),
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
                      Icon(Icons.language, color: SecondaryLightColor, size: 24),
                      SizedBox(width: 12),
                      Text(
                        'Language',
                        style: TextStyle(
                          color: NeutralLightColor,
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  // English
                  _buildRadioTile('English', true),
                  // Urdu
                  _buildRadioTile('اردو (Urdu)', false),
                ],
              ),
            ),

            const SizedBox(height: 32),

            // Notifications Section
            Container(
              width: double.infinity,
              padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 20),
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
                      Icon(Icons.notifications, color: SecondaryLightColor, size: 24),
                      SizedBox(width: 12),
                      Text(
                        'Notifications',
                        style: TextStyle(
                          color: NeutralLightColor,
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  _buildSwitchTile('Push Notifications', 'Get alerts and updates', true),
                  _buildSwitchTile('Email Notifications', 'Receive emails', true),
                  _buildSwitchTile('Warranty Alerts', 'Expiration reminders', true),
                ],
              ),
            ),

            const SizedBox(height: 32),

            // Quick Links Section
            Container(
              width: double.infinity,
              padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 20),
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
                  const Text(
                    'Quick Links',
                    style: TextStyle(
                      color: NeutralLightColor,
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 16),
                  _buildLinkTile('Privacy Policy'),
                  _buildLinkTile('Terms of Service'),
                  _buildLinkTile('Help & Support'),
                  _buildLinkTile('About SolarEase'),
                ],
              ),
            ),

            const SizedBox(height: 32),

            // Logout Button
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: SizedBox(
                width: double.infinity,
                child: OutlinedButton.icon(
                  onPressed: () {
                    // Show confirmation dialog
                    Get.defaultDialog(
                      title: "Logout",
                      middleText: "Are you sure you want to logout?",
                      textConfirm: "Yes",
                      textCancel: "No",
                      confirmTextColor: NeutralDarkColor,
                      cancelTextColor: NeutralDarkColor,
                      buttonColor: SecondaryLightColor,
                      barrierDismissible: false,
                      onConfirm: () {
                        // Clear navigation stack and go to LoginScreen
                        Get.offAll(() => const LoginScreen());
                      },
                    );
                  },
                  icon: const Icon(Icons.logout, color: Colors.redAccent),
                  label: const Text(
                    'Logout',
                    style: TextStyle(
                      color: Colors.redAccent,
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  style: OutlinedButton.styleFrom(
                    side: const BorderSide(color: Colors.redAccent, width: 2),
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30),
                    ),
                    backgroundColor: PrimaryColor.withOpacity(0.3),
                  ),
                ),
              ),
            ),

            const SizedBox(height: 10), // Optional extra space at bottom
          ],
        ),
      ),
    );
  }

  Widget _buildRadioTile(String title, bool selected) {
    return ListTile(
      contentPadding: EdgeInsets.zero,
      title: Text(
        title,
        style: const TextStyle(color: NeutralLightColor, fontSize: 16),
      ),
      trailing: Radio<bool>(
        value: selected,
        groupValue: true,
        onChanged: (value) {},
        activeColor: SecondaryLightColor,
        fillColor: WidgetStateProperty.resolveWith((states) {
          if (states.contains(WidgetState.selected)) {
            return SecondaryLightColor;
          }
          return PrimaryLightColor;
        }),
      ),
      onTap: () {
        // TODO: Change language
        Get.snackbar('Language', 'Language change coming soon!',
            backgroundColor: SecondaryLightColor.withOpacity(0.9),
            colorText: NeutralDarkColor);
      },
    );
  }

  Widget _buildSwitchTile(String title, String subtitle, bool value) {
    return SwitchListTile(
      contentPadding: EdgeInsets.zero,
      title: Text(
        title,
        style: const TextStyle(color: NeutralLightColor, fontSize: 16),
      ),
      subtitle: Text(
        subtitle,
        style: const TextStyle(color: PrimaryLightColor, fontSize: 14),
      ),
      value: value,
      onChanged: (bool newValue) {
        // TODO: Toggle notification setting
      },
      activeColor: SecondaryLightColor,
      inactiveThumbColor: PrimaryLightColor,
      inactiveTrackColor: PrimaryColor,
    );
  }

  Widget _buildLinkTile(String title) {
    return ListTile(
      contentPadding: EdgeInsets.zero,
      title: Text(
        title,
        style: const TextStyle(color: NeutralLightColor, fontSize: 16),
      ),
      trailing: const Icon(Icons.chevron_right, color: PrimaryLightColor),
      onTap: () {
        Get.snackbar(title, 'Page coming soon!',
            backgroundColor: SecondaryLightColor.withOpacity(0.9),
            colorText: NeutralDarkColor);
      },
    );
  }
}