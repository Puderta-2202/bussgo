import 'package:bussgo/services/auth_service.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'tiket_saya.dart';
import 'jadwalkeberangkatan.dart';
import 'akun_screen.dart';
import 'package:bussgo/pages/topup_screen.dart';
import 'app_color.dart';
import 'nav_bar.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => HomeScreenState();
}

class HomeScreenState extends State<HomeScreen> {
  // State untuk Navigasi dan Data API
  final int _currentIndex = 0;
  Map<String, dynamic>? _currentUser;
  bool _isLoading = true;

  // State untuk Form Pencarian
  int _jumlahPenumpang = 1; // Default 1 penumpang
  DateTime? _selectedDepartureDate;
  String? _selectedDariCity;
  String? _selectedKeCity;

  final List<String> _kotaSumateraUtara = [
    'Medan',
    'Pematang Siantar',
    'Binjai',
    'Tebing Tinggi',
    'Sibolga',
    'Tanjungbalai',
    'Padang Sidempuan',
    'Gunungsitoli',
    'Kisaran',
    'Rantau Prapat',
    'Lubuk Pakam',
    'Stabat',
    'Kabanjahe',
    'Sidikalang',
    'Berastagi',
    'Dolok Sanggul',
    'Samosir',
    'Seribudolok',
    'Tarutung',
    'Siborong-borong',
    'Panyabungan',
  ];

  @override
  void initState() {
    super.initState();
    _loadUserData();
  }

  // --- FUNGSI-FUNGSI LOGIKA ---

  Future<void> _loadUserData() async {
    if (!mounted) return;
    setState(() {
      _isLoading = true;
    });

    try {
      final userData = await AuthService.getAuthenticatedUser();
      if (!mounted) return;
      setState(() {
        _currentUser = userData;
      });
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(e.toString().replaceFirst('Exception: ', ''))),
      );
    } finally {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  void _onSearchTapped() {
    if (_selectedDariCity == null ||
        _selectedKeCity == null ||
        _selectedDepartureDate == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          backgroundColor: Colors.red,
          content: Text('Harap lengkapi kota asal, tujuan, dan tanggal!'),
        ),
      );
      return;
    }
    Navigator.push(
      context,
      MaterialPageRoute(
        builder:
            (context) => JadwalKeberangkatanScreen(
              kotaAsal: _selectedDariCity!,
              kotaTujuan: _selectedKeCity!,
              tanggalKeberangkatan: _selectedDepartureDate!,
              jumlahPenumpang: _jumlahPenumpang,
              currentUser: _currentUser!,
            ),
      ),
    );
  }

  void _handleBottomNavTapped(int index) {
    if (index == _currentIndex) return;
    switch (index) {
      case 1:
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => const TiketSayaPage()),
        );
        break;
      case 2:
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Halaman Promo belum tersedia.')),
        );
        break;
      case 3:
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => const AkunScreen()),
        );
        break;
    }
  }

  // --- FUNGSI-FUNGSI DIALOG UNTUK UI ---

  Future<void> _showCityPickerDialog(
    BuildContext context,
    bool isDariField,
  ) async {
    final String? selectedCity = await showDialog<String>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(
            'Pilih Kota ${isDariField ? "Asal" : "Tujuan"}',
            textAlign: TextAlign.start,
          ),
          contentPadding: const EdgeInsets.only(
            top: 10.0,
            left: 0,
            right: 0,
            bottom: 0,
          ),
          content: SizedBox(
            width: double.maxFinite,
            height: MediaQuery.of(context).size.height * 0.6,
            child: ListView.separated(
              itemCount: _kotaSumateraUtara.length,
              itemBuilder: (BuildContext context, int index) {
                return ListTile(
                  title: Center(child: Text(_kotaSumateraUtara[index])),
                  onTap:
                      () =>
                          Navigator.of(context).pop(_kotaSumateraUtara[index]),
                );
              },
              separatorBuilder:
                  (context, index) => const Divider(height: 1, thickness: 1),
            ),
          ),
          actions: <Widget>[
            TextButton(
              child: const Text('Batal', style: TextStyle(color: mainBlue)),
              onPressed: () => Navigator.of(context).pop(),
            ),
          ],
        );
      },
    );

    if (selectedCity != null && mounted) {
      setState(() {
        if (isDariField) {
          _selectedDariCity = selectedCity;
        } else {
          _selectedKeCity = selectedCity;
        }
      });
    }
  }

  Future<void> _selectDepartureDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: _selectedDepartureDate ?? DateTime.now(),
      firstDate: DateTime.now(),
      lastDate: DateTime.now().add(const Duration(days: 365 * 2)),
      helpText: 'PILIH TANGGAL KEBERANGKATAN',
      cancelText: 'BATAL',
      confirmText: 'PILIH',
      builder: (BuildContext context, Widget? child) {
        return Theme(
          data: ThemeData.light().copyWith(
            colorScheme: const ColorScheme.light(
              primary: mainBlue,
              onPrimary: Colors.white,
              surface: Colors.white,
              onSurface: Colors.black,
            ),
            dialogBackgroundColor: Colors.white,
            textButtonTheme: TextButtonThemeData(
              style: TextButton.styleFrom(foregroundColor: mainBlue),
            ),
          ),
          child: child!,
        );
      },
    );
    if (picked != null && picked != _selectedDepartureDate && mounted) {
      setState(() {
        _selectedDepartureDate = picked;
      });
    }
  }

  Future<void> _showPassengerPickerDialog(BuildContext context) async {
    final int? selectedValue = await showModalBottomSheet<int>(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (BuildContext context) {
        return Container(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Pilih Jumlah Penumpang',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 16),
              Wrap(
                spacing: 10.0,
                runSpacing: 10.0,
                children: List.generate(6, (index) {
                  int value = index + 1;
                  bool isSelected = _jumlahPenumpang == value;
                  return ChoiceChip(
                    label: Text('$value Orang'),
                    selected: isSelected,
                    onSelected: (bool selected) {
                      if (selected) {
                        Navigator.pop(context, value);
                      }
                    },
                    selectedColor: mainBlue.withOpacity(0.2),
                    labelStyle: TextStyle(
                      color: isSelected ? mainBlue : Colors.black87,
                      fontWeight:
                          isSelected ? FontWeight.bold : FontWeight.normal,
                    ),
                    shape: StadiumBorder(
                      side: BorderSide(
                        color: isSelected ? mainBlue : Colors.grey.shade300,
                      ),
                    ),
                  );
                }),
              ),
              const SizedBox(height: 20),
            ],
          ),
        );
      },
    );

    if (selectedValue != null && selectedValue != _jumlahPenumpang) {
      setState(() {
        _jumlahPenumpang = selectedValue;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final String userName = _currentUser?['nama_lengkap'] ?? 'Pengguna';
    final String busPayBalanceString =
        _isLoading
            ? "Memuat..."
            : NumberFormat.currency(
              locale: 'id_ID',
              symbol: 'Rp ',
              decimalDigits: 0,
            ).format(
              double.tryParse(_currentUser?['saldo']?.toString() ?? '0') ?? 0,
            );

    return Scaffold(
      backgroundColor: screenBgLightBlue,
      body: Column(
        children: [
          Container(
            padding: const EdgeInsets.fromLTRB(20, 45, 20, 20),
            decoration: const BoxDecoration(
              color: mainBlue,
              borderRadius: BorderRadius.only(
                bottomLeft: Radius.circular(30),
                bottomRight: Radius.circular(30),
              ),
            ),
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      children: [
                        const CircleAvatar(
                          radius: 20,
                          backgroundImage: AssetImage('assets/images/pp.jpeg'),
                        ),
                        const SizedBox(width: 12),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text(
                              'Hi,',
                              style: TextStyle(
                                color: Colors.white70,
                                fontSize: 14,
                              ),
                            ),
                            Text(
                              userName,
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
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
                              color: Colors.white,
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          InkWell(
                            onTap: () {
                              // Navigasi ke halaman TopUpScreen yang baru
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => const TopUpScreen(),
                                ),
                              );
                            },
                            child: const Padding(
                              padding: EdgeInsets.all(4.0),
                              child: Icon(
                                Icons.add_card_outlined,
                                color: Colors.white,
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 5),
                      Row(
                        children: [
                          if (_isLoading)
                            const SizedBox(
                              height: 18,
                              width: 18,
                              child: CircularProgressIndicator(
                                strokeWidth: 2,
                                color: Colors.white,
                              ),
                            )
                          else
                            Text(
                              busPayBalanceString,
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          const SizedBox(width: 8),
                          const Icon(
                            Icons.remove_red_eye_outlined,
                            color: Colors.white70,
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          Expanded(
            child: SingleChildScrollView(
              child: Container(
                padding: const EdgeInsets.fromLTRB(20, 25, 20, 0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Dari',
                      style: TextStyle(
                        color: Colors.black87,
                        fontSize: 16,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    const SizedBox(height: 8),
                    GestureDetector(
                      onTap: () => _showCityPickerDialog(context, true),
                      child: AbsorbPointer(
                        child: _buildFormField(
                          icon: Icons.directions_bus_outlined,
                          text: _selectedDariCity ?? 'Pilih Kota Asal',
                          hasValue: _selectedDariCity != null,
                        ),
                      ),
                    ),
                    const SizedBox(height: 20),
                    const Text(
                      'Ke',
                      style: TextStyle(
                        color: Colors.black87,
                        fontSize: 16,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    const SizedBox(height: 8),
                    GestureDetector(
                      onTap: () => _showCityPickerDialog(context, false),
                      child: AbsorbPointer(
                        child: _buildFormField(
                          icon: Icons.directions_bus_outlined,
                          text: _selectedKeCity ?? 'Pilih Kota Tujuan',
                          hasValue: _selectedKeCity != null,
                        ),
                      ),
                    ),
                    const SizedBox(height: 20),
                    const Text(
                      'Tanggal Keberangkatan',
                      style: TextStyle(
                        color: Colors.black87,
                        fontSize: 16,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    const SizedBox(height: 8),
                    GestureDetector(
                      onTap: () => _selectDepartureDate(context),
                      child: AbsorbPointer(
                        child: _buildFormField(
                          icon: Icons.calendar_today_outlined,
                          text:
                              _selectedDepartureDate == null
                                  ? 'Pilih Tanggal'
                                  : DateFormat(
                                    'EEEE, dd MMMM yyyy',
                                    'id_ID',
                                  ).format(_selectedDepartureDate!),
                          hasValue: _selectedDepartureDate != null,
                        ),
                      ),
                    ),
                    const SizedBox(height: 20),
                    const Text(
                      'Jumlah Penumpang',
                      style: TextStyle(
                        color: Colors.black87,
                        fontSize: 16,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    const SizedBox(height: 8),
                    GestureDetector(
                      onTap: () => _showPassengerPickerDialog(context),
                      child: AbsorbPointer(
                        child: _buildFormField(
                          icon: Icons.event_seat_outlined,
                          text: '$_jumlahPenumpang Penumpang',
                          hasValue: true,
                        ),
                      ),
                    ),
                    const SizedBox(height: 30),
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        onPressed: _onSearchTapped,
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
                    const SizedBox(height: 20),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
        child: SharedBottomNavBar(
          currentIndex: _currentIndex,
          onItemTapped: _handleBottomNavTapped,
        ),
      ),
    );
  }

  Widget _buildFormField({
    required IconData icon,
    required String text,
    required bool hasValue,
  }) {
    return Container(
      padding: const EdgeInsets.only(bottom: 8),
      decoration: const BoxDecoration(
        border: Border(bottom: BorderSide(color: Colors.black26, width: 1.0)),
      ),
      child: Row(
        children: [
          Icon(icon, size: 24, color: Colors.black54),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              text,
              style: TextStyle(
                fontSize: 16,
                color: hasValue ? Colors.black87 : Colors.grey[600],
              ),
              overflow: TextOverflow.ellipsis,
            ),
          ),
          const Icon(Icons.arrow_drop_down, color: Colors.black54),
        ],
      ),
    );
  }
}
