import 'package:flutter/material.dart';

const Color mainBlue = Color(0xFF1A9AEB);

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _selectedIndex = 0;

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          // Top Section (Blue background with user profile and BusGO text)
          Container(
            padding: const EdgeInsets.fromLTRB(10, 25, 10, 15),
            decoration: const BoxDecoration(
              color: mainBlue,
              borderRadius: BorderRadius.only(
                bottomLeft: Radius.circular(30),
                bottomRight: Radius.circular(30),
              ),
            ),
            child: Column(
              children: [
                // Header Row (User profile pic and BusGO logo)
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    // User Profile
                    Row(
                      children: [
                        Container(
                          width: 40,
                          height: 40,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: Colors.grey[300],
                            image: const DecorationImage(
                              image: AssetImage('assets/images/pp.jpeg'),
                              fit: BoxFit.cover,
                            ),
                          ),
                        ),
                        const SizedBox(width: 10),
                        const Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Hi,',
                              style: TextStyle(
                                color: Colors.black,
                                fontFamily: 'Kadwa',
                                fontSize: 14,
                              ),
                            ),
                            Text(
                              'User\'s',
                              style: TextStyle(
                                color: Colors.black,
                                fontFamily: 'Kadwa',
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                    // BusGO Logo
                    const Text(
                      'BusGO',
                      style: TextStyle(
                        color: Colors.white,
                        fontFamily: 'Racing',
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 20),

                // Balance Card
                Container(
                  padding: const EdgeInsets.all(15),
                  decoration: BoxDecoration(
                    color: const Color(0xFF64B5F6),
                    borderRadius: BorderRadius.circular(15),
                  ),
                  child: Column(
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Text(
                            'BusPay!',
                            style: TextStyle(
                              color: Colors.black87,
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          Row(
                            children: [
                              Icon(Icons.fullscreen, color: Colors.black54),
                              const SizedBox(width: 10),
                              Icon(Icons.credit_card, color: Colors.black54),
                            ],
                          ),
                        ],
                      ),
                      const SizedBox(height: 5),
                      Row(
                        children: [
                          const Text(
                            'Rp 1.000.000',
                            style: TextStyle(
                              color: Colors.black,
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(width: 8),
                          Icon(Icons.remove_red_eye, color: Colors.black54),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),

          // Form Section (Light blue background)
          Expanded(
            child: Container(
              padding: const EdgeInsets.all(20),
              decoration: const BoxDecoration(color: Color(0xFFE3F2FD)),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Dari (From) Field
                  const Text(
                    'Dari',
                    style: TextStyle(color: Colors.black87, fontSize: 16),
                  ),
                  Row(
                    children: [
                      const Icon(Icons.directions_bus_outlined, size: 24),
                      const SizedBox(width: 10),
                      Expanded(
                        child: Container(
                          height: 30,
                          decoration: const BoxDecoration(
                            border: Border(
                              bottom: BorderSide(
                                color: Colors.black54,
                                width: 1.0,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 20),

                  // Ke (To) Field
                  const Text(
                    'Ke',
                    style: TextStyle(color: Colors.black87, fontSize: 16),
                  ),
                  Row(
                    children: [
                      const Icon(Icons.directions_bus_outlined, size: 24),
                      const SizedBox(width: 10),
                      Expanded(
                        child: Container(
                          height: 30,
                          decoration: const BoxDecoration(
                            border: Border(
                              bottom: BorderSide(
                                color: Colors.black54,
                                width: 1.0,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 20),

                  // Tanggal Keberangkatan (Departure Date) Field
                  const Text(
                    'Tanggal Keberangkatan',
                    style: TextStyle(color: Colors.black87, fontSize: 16),
                  ),
                  Row(
                    children: [
                      const Icon(Icons.calendar_today, size: 24),
                      const SizedBox(width: 10),
                      Expanded(
                        child: Container(
                          height: 30,
                          decoration: const BoxDecoration(
                            border: Border(
                              bottom: BorderSide(
                                color: Colors.black54,
                                width: 1.0,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 20),

                  // Jumlah Kursi (Number of Seats) Field
                  const Text(
                    'Jumlah Kursi',
                    style: TextStyle(color: Colors.black87, fontSize: 16),
                  ),
                  Row(
                    children: [
                      const Icon(Icons.event_seat, size: 24),
                      const SizedBox(width: 10),
                      Expanded(
                        child: Container(
                          height: 30,
                          decoration: const BoxDecoration(
                            border: Border(
                              bottom: BorderSide(
                                color: Colors.black54,
                                width: 1.0,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 30),

                  // Cari (Search) Button
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: () {},
                      style: ElevatedButton.styleFrom(
                        backgroundColor: mainBlue,
                        padding: const EdgeInsets.symmetric(vertical: 15),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                      child: const Text(
                        'Cari',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),

                  const Spacer(),

                  // Bottom Navigation Bar
                  Container(
                    padding: const EdgeInsets.symmetric(vertical: 10),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(15),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.1),
                          spreadRadius: 1,
                          blurRadius: 5,
                          offset: const Offset(0, -1),
                        ),
                      ],
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        _buildNavItem(
                          Icons.home,
                          'Beranda',
                          _selectedIndex == 0,
                        ),
                        _buildNavItem(
                          Icons.confirmation_number_outlined,
                          'Tiket Saya',
                          _selectedIndex == 1,
                        ),
                        _buildNavItem(
                          Icons.local_offer_outlined,
                          'Promo',
                          _selectedIndex == 2,
                        ),
                        _buildNavItem(
                          Icons.person_outline,
                          'Akun',
                          _selectedIndex == 3,
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildNavItem(IconData icon, String label, bool isActive) {
    return GestureDetector(
      onTap: () {
        if (label == 'Beranda')
          _onItemTapped(0);
        else if (label == 'Tiket Saya')
          _onItemTapped(1);
        else if (label == 'Promo')
          _onItemTapped(2);
        else if (label == 'Akun')
          _onItemTapped(3);
      },
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, color: isActive ? mainBlue : Colors.grey, size: 24),
          const SizedBox(height: 4),
          Text(
            label,
            style: TextStyle(
              color: isActive ? mainBlue : Colors.grey,
              fontSize: 12,
            ),
          ),
        ],
      ),
    );
  }
}
