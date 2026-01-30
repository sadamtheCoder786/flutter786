import '../../helpers/ExportImports.dart';// Import your colors.dart (adjust path if needed)

class DashboardScreen extends StatefulWidget {
  const DashboardScreen({super.key});

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  int _selectedIndex = 0; // Home is selected initially

  // Placeholder pages (you can replace with actual screens later)
  static const List<Widget> _pages = [
    Center(child: Text('Dashboard', style: TextStyle(fontSize: 32, color: Colors.white))),
    ShopScreen(),
    CalculateScreen(),
    ServicesScreen(),
    Center(child: Text('Chat', style: TextStyle(fontSize: 32, color: Colors.white))),
    ProfileScreen()
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: PrimaryDarkColor, // Dark background
      body: _pages[_selectedIndex],
      bottomNavigationBar: BottomNavigationBar(
        items: [
          BottomNavigationBarItem(
            icon: Icon(Icons.home_outlined),
            activeIcon: Icon(Icons.home, color: SecondaryLightColor),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.shopping_cart_outlined),
            activeIcon: Icon(Icons.shopping_cart, color: SecondaryLightColor),
            label: 'Shop',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.calculate_outlined),
            activeIcon: Icon(Icons.calculate, color: SecondaryLightColor),
            label: 'Calculate',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.handyman_outlined),
            activeIcon: Icon(Icons.handyman, color: SecondaryLightColor),
            label: 'Services',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.chat_bubble_outline),
            activeIcon: Icon(Icons.chat_bubble, color: SecondaryLightColor),
            label: 'Chat',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person_outline),
            activeIcon: Icon(Icons.person, color: SecondaryLightColor),
            label: 'Profile',
          ),
        ],
        currentIndex: _selectedIndex,
        selectedItemColor: SecondaryLightColor, // Yellow when selected
        unselectedItemColor: PrimaryLightColor, // Gray when unselected
        backgroundColor: PrimaryDarkColor.withOpacity(0.95),
        type: BottomNavigationBarType.fixed,
        showUnselectedLabels: true,
        selectedFontSize: 12,
        unselectedFontSize: 12,
        elevation: 20,
        onTap: _onItemTapped,
      ),
    );
  }
}