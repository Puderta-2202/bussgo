import 'package:flutter/material.dart';
import 'app_color.dart';

class SharedBottomNavBar extends StatelessWidget {
  final int currentIndex;
  final Function(int) onItemTapped;

  const SharedBottomNavBar({
    Key? key,
    required this.currentIndex,
    required this.onItemTapped,
  }) : super(key: key);

  Widget _buildNavItemInternal(
    BuildContext context,
    IconData icon,
    String label,
    int itemIndex,
  ) {
    bool isActive = currentIndex == itemIndex;
    // Dapatkan tema teks default untuk fallback jika diperlukan

    return Expanded(
      child: GestureDetector(
        onTap: () => onItemTapped(itemIndex),
        behavior:
            HitTestBehavior
                .opaque, // Memastikan seluruh area Expanded bisa di-tap
        child: Container(
          // Tambahkan Container di sini untuk padding per item jika perlu
          padding: const EdgeInsets.symmetric(
            vertical: 4.0,
          ), // Sedikit padding vertikal untuk setiap item
          child: Column(
            mainAxisSize:
                MainAxisSize
                    .min, // Penting agar Column tidak mengambil semua tinggi Expanded
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                icon,
                color: isActive ? mainBlue : Colors.grey,
                size: 24,
              ), // Ukuran ikon tetap
              const SizedBox(height: 3),
              SizedBox(
                // Batasi tinggi untuk area teks agar FittedBox bekerja dengan baik
                height:
                    15, // Perkiraan tinggi untuk font size 11-12, bisa disesuaikan
                child: FittedBox(
                  fit: BoxFit.scaleDown, // Hanya mengecilkan jika perlu
                  child: Text(
                    label,
                    style: TextStyle(
                      color: isActive ? mainBlue : Colors.grey,
                      fontSize: 12, // Ukuran font target
                      fontWeight:
                          isActive ? FontWeight.bold : FontWeight.normal,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 60, // Tinggi bottom nav bar yang konsisten
      // Tidak ada padding vertikal di sini, biarkan _buildNavItemInternal yang mengatur
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(
          15,
        ), // Sesuai styling HomeScreen sebelumnya
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
        crossAxisAlignment:
            CrossAxisAlignment
                .stretch, // Membuat item mengambil tinggi penuh dari Row
        children: [
          _buildNavItemInternal(context, Icons.home_outlined, 'Beranda', 0),
          _buildNavItemInternal(
            context,
            Icons.confirmation_number_outlined,
            'Tiket Saya',
            1,
          ),
          _buildNavItemInternal(
            context,
            Icons.local_offer_outlined,
            'Promo',
            2,
          ),
          _buildNavItemInternal(context, Icons.person_rounded, 'Akun', 3),
        ],
      ),
    );
  }
}
