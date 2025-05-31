import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'tiket_saya.dart';
import 'jadwalkeberangkatan.dart';
import 'akun_screen.dart';
import 'app_color.dart';
import 'nav_bar.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => HomeScreenState(); // Nama kelas State menjadi publik
}

class HomeScreenState extends State<HomeScreen> {
  // Variabel static saldo menjadi publik di dalam kelas State yang juga publik
  static double numericalBusPayBalance = 0.0;
  static String busPayBalanceString = "Memuat saldo...";
  static bool isLoadingBalanceStatic = true;

  static void updateAndFormatBusPayBalance(
    double newNumericalBalance, {
    Function? stateSetter,
  }) {
    numericalBusPayBalance = newNumericalBalance;
    busPayBalanceString = NumberFormat.currency(
      locale: 'id_ID',
      symbol: 'Rp ',
      decimalDigits: 0,
    ).format(numericalBusPayBalance);
    isLoadingBalanceStatic = false;
    if (stateSetter != null) {
      // Memastikan stateSetter dipanggil dengan aman
      try {
        stateSetter(() {});
      } catch (e) {
        // Mungkin widget sudah tidak ada, tangani error jika perlu
        // print("Error calling stateSetter in updateAndFormatBusPayBalance: $e");
      }
    }
  }

  final int _currentIndex = 0; // Index untuk halaman Beranda

  int _jumlahKursiTerpilih = 0;
  List<String> _detailKursiTerpilih = [];
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
    'Saribudolok',
    'Tarutung',
    'Siborong-borong',
    'Panyabungan',
  ];

  @override
  void initState() {
    super.initState();
    _fetchBusPayBalance();
  }

  Future<void> _fetchBusPayBalance() async {
    if (mounted) {
      // Cek mounted sebelum setState
      setState(() {
        HomeScreenState.isLoadingBalanceStatic = true;
        HomeScreenState.busPayBalanceString = "Memuat saldo...";
      });
    }

    await Future.delayed(const Duration(seconds: 1)); // Simulasi delay
    double fetchedBalanceFromDB = 1250750.0; // Saldo awal dummy

    // Gunakan `mounted` check sebelum memanggil setState melalui stateSetter
    HomeScreenState.updateAndFormatBusPayBalance(
      fetchedBalanceFromDB,
      stateSetter: mounted ? setState : null,
    );
  }

  void _handleBottomNavTapped(int index) {
    if (index == _currentIndex) return;

    switch (index) {
      case 0:
        // Sudah di Beranda
        break;
      case 1: // Tiket Saya
        // Asumsi TiketSayaPage bisa menangani tiketDibeli yang null
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => const TiketSayaPage()),
        );
        break;
      case 2: // Promo
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Halaman Promo belum tersedia.')),
        );
        break;
      case 3: // Akun
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => const AkunScreen()),
        );
        break;
    }
  }

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
              shrinkWrap: true,
              itemCount: _kotaSumateraUtara.length,
              itemBuilder: (BuildContext context, int index) {
                return ListTile(
                  title: Center(child: Text(_kotaSumateraUtara[index])),
                  onTap: () {
                    Navigator.of(context).pop(_kotaSumateraUtara[index]);
                  },
                );
              },
              separatorBuilder:
                  (context, index) => const Divider(height: 1, thickness: 1),
            ),
          ),
          actions: <Widget>[
            TextButton(
              child: const Text('Batal', style: TextStyle(color: mainBlue)),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );

    if (selectedCity != null && mounted) {
      // Cek mounted
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
      // Cek mounted
      setState(() {
        _selectedDepartureDate = picked;
      });
    }
  }

  Future<void> _showSeatPickerDialog(BuildContext context) async {
    List<String> tempSelectedSeats = List.from(_detailKursiTerpilih);
    final result = await showDialog<List<String>>(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return StatefulBuilder(
          builder: (context, setDialogState) {
            Widget buildSeat(
              String label, {
              bool isSpecial = false,
              bool isSelectable = true,
            }) {
              bool isSelected = tempSelectedSeats.contains(label);
              Color seatColor;
              if (!isSelectable) {
                seatColor = unselectableSeatColor;
              } else if (isSelected) {
                seatColor = selectedSeatColor;
              } else {
                seatColor = availableSeatColor;
              }
              return GestureDetector(
                onTap:
                    isSelectable
                        ? () {
                          setDialogState(() {
                            if (isSelected) {
                              tempSelectedSeats.remove(label);
                            } else {
                              tempSelectedSeats.add(label);
                            }
                          });
                        }
                        : null,
                child: Container(
                  width: isSpecial ? null : 45,
                  height: 40,
                  margin: const EdgeInsets.all(3),
                  padding:
                      isSpecial
                          ? const EdgeInsets.symmetric(
                            horizontal: 10,
                            vertical: 8,
                          )
                          : null,
                  decoration: BoxDecoration(
                    color: seatColor,
                    border: Border.all(color: Colors.grey.shade500),
                    borderRadius: BorderRadius.circular(5),
                  ),
                  child: Center(
                    child: Text(
                      label,
                      style: TextStyle(
                        fontSize: isSpecial ? 12 : 10,
                        color:
                            (!isSelectable || isSelected)
                                ? Colors.white
                                : Colors.black87,
                        fontWeight:
                            isSelected ? FontWeight.bold : FontWeight.normal,
                      ),
                    ),
                  ),
                ),
              );
            }

            List<Widget> dialogSeatWidgets = [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  buildSeat('Kernet', isSpecial: true, isSelectable: false),
                  buildSeat('CD', isSpecial: true, isSelectable: false),
                  const SizedBox(width: 20),
                  buildSeat('Sopir', isSpecial: true, isSelectable: false),
                ],
              ),
              const Divider(height: 20, thickness: 1),
            ];
            List<Widget> numberedSeatRows = [];
            int currentSeatNum = 1;
            for (int i = 0; i < 14 && currentSeatNum <= 55; i++) {
              List<Widget> seatsInRow = [];
              for (int j = 0; j < 4 && currentSeatNum <= 55; j++) {
                if (j == 2) {
                  seatsInRow.add(const SizedBox(width: 24));
                }
                seatsInRow.add(buildSeat(currentSeatNum.toString()));
                currentSeatNum++;
              }
              numberedSeatRows.add(
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: seatsInRow,
                ),
              );
              if (i < 13 && currentSeatNum <= 55) {
                numberedSeatRows.add(const SizedBox(height: 3));
              }
            }
            dialogSeatWidgets.addAll(numberedSeatRows);
            return AlertDialog(
              title: const Center(
                child: Text(
                  'Pilih Kursi',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
              ),
              content: SizedBox(
                width: double.maxFinite,
                child: SingleChildScrollView(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const Text(
                        'BUS AC 55 SEATS (2-2) + 1 KURSI CD',
                        style: TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.bold,
                          color: Colors.black54,
                        ),
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(height: 15),
                      ...dialogSeatWidgets,
                    ],
                  ),
                ),
              ),
              actionsAlignment: MainAxisAlignment.spaceBetween,
              actions: <Widget>[
                TextButton(
                  child: const Text('Batal', style: TextStyle(color: mainBlue)),
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                ),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(backgroundColor: mainBlue),
                  child: const Text(
                    'Pilih',
                    style: TextStyle(color: Colors.white),
                  ),
                  onPressed: () {
                    Navigator.of(context).pop(tempSelectedSeats);
                  },
                ),
              ],
            );
          },
        );
      },
    );
    if (result != null && mounted) {
      // Cek mounted
      setState(() {
        _detailKursiTerpilih = result;
        _jumlahKursiTerpilih = _detailKursiTerpilih.length;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: screenBgLightBlue, // Dari app_colors.dart
      body: Column(
        children: [
          Container(
            padding: const EdgeInsets.fromLTRB(
              10,
              45,
              10,
              20,
            ), // Disesuaikan agar status bar tidak overlap
            decoration: const BoxDecoration(
              color: mainBlue, // Dari app_colors.dart
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
                        Container(
                          width: 40,
                          height: 40,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: Colors.grey[300],
                            image: const DecorationImage(
                              // Pastikan aset ini ada di pubspec.yaml dan path benar
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
                              "User's",
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
                    const Padding(
                      padding: EdgeInsets.only(right: 30.0),
                      child: Text(
                        'BusGO',
                        style: TextStyle(
                          color: Colors.white,
                          fontFamily: 'Racing',
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 20),
                Container(
                  padding: const EdgeInsets.all(15),
                  decoration: BoxDecoration(
                    color: const Color(
                      0xFF64B5F6,
                    ), // Bisa juga dari app_colors.dart
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
                              Icon(
                                Icons.account_balance_wallet_outlined,
                                color: Colors.black54,
                              ),
                            ],
                          ),
                        ],
                      ),
                      const SizedBox(height: 5),
                      Row(
                        children: [
                          HomeScreenState.isLoadingBalanceStatic
                              ? const SizedBox(
                                height: 20,
                                width: 100,
                                child: Align(
                                  alignment: Alignment.centerLeft,
                                  child: SizedBox(
                                    height: 16,
                                    width: 16,
                                    child: CircularProgressIndicator(
                                      strokeWidth: 2,
                                      color: Colors.black87,
                                    ),
                                  ),
                                ),
                              )
                              : Text(
                                HomeScreenState.busPayBalanceString,
                                style: const TextStyle(
                                  color: Colors.black,
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                          const SizedBox(width: 8),
                          const Icon(
                            Icons.remove_red_eye_outlined,
                            color: Colors.black54,
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
            child: Container(
              padding: const EdgeInsets.fromLTRB(20, 20, 20, 0),
              decoration: const BoxDecoration(
                color: screenBgLightBlue,
              ), // Dari app_colors.dart
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Dari',
                    style: TextStyle(color: Colors.black87, fontSize: 16),
                  ),
                  GestureDetector(
                    onTap: () {
                      _showCityPickerDialog(context, true);
                    },
                    child: AbsorbPointer(
                      child: Row(
                        children: [
                          const Icon(
                            Icons.directions_bus_outlined,
                            size: 24,
                            color: Colors.black54,
                          ),
                          const SizedBox(width: 10),
                          Expanded(
                            child: Container(
                              height: 30,
                              padding: const EdgeInsets.symmetric(vertical: 5),
                              decoration: const BoxDecoration(
                                border: Border(
                                  bottom: BorderSide(color: Colors.black54),
                                ),
                              ),
                              child: Align(
                                alignment: Alignment.centerLeft,
                                child: Text(
                                  _selectedDariCity ?? 'Pilih Kota Asal',
                                  style: TextStyle(
                                    fontSize: 16,
                                    color:
                                        _selectedDariCity == null
                                            ? Colors.grey
                                            : Colors.black,
                                  ),
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ),
                            ),
                          ),
                          const Icon(
                            Icons.arrow_drop_down,
                            color: Colors.black54,
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),
                  const Text(
                    'Ke',
                    style: TextStyle(color: Colors.black87, fontSize: 16),
                  ),
                  GestureDetector(
                    onTap: () {
                      _showCityPickerDialog(context, false);
                    },
                    child: AbsorbPointer(
                      child: Row(
                        children: [
                          const Icon(
                            Icons.directions_bus_outlined,
                            size: 24,
                            color: Colors.black54,
                          ),
                          const SizedBox(width: 10),
                          Expanded(
                            child: Container(
                              height: 30,
                              padding: const EdgeInsets.symmetric(vertical: 5),
                              decoration: const BoxDecoration(
                                border: Border(
                                  bottom: BorderSide(color: Colors.black54),
                                ),
                              ),
                              child: Align(
                                alignment: Alignment.centerLeft,
                                child: Text(
                                  _selectedKeCity ?? 'Pilih Kota Tujuan',
                                  style: TextStyle(
                                    fontSize: 16,
                                    color:
                                        _selectedKeCity == null
                                            ? Colors.grey
                                            : Colors.black,
                                  ),
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ),
                            ),
                          ),
                          const Icon(
                            Icons.arrow_drop_down,
                            color: Colors.black54,
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),
                  const Text(
                    'Tanggal Keberangkatan',
                    style: TextStyle(color: Colors.black87, fontSize: 16),
                  ),
                  GestureDetector(
                    onTap: () {
                      _selectDepartureDate(context);
                    },
                    child: AbsorbPointer(
                      child: Row(
                        children: [
                          const Icon(
                            Icons.calendar_today_outlined,
                            size: 24,
                            color: Colors.black54,
                          ),
                          const SizedBox(width: 10),
                          Expanded(
                            child: Container(
                              height: 30,
                              padding: const EdgeInsets.symmetric(vertical: 5),
                              decoration: const BoxDecoration(
                                border: Border(
                                  bottom: BorderSide(color: Colors.black54),
                                ),
                              ),
                              child: Align(
                                alignment: Alignment.centerLeft,
                                child: Text(
                                  _selectedDepartureDate == null
                                      ? 'Pilih Tanggal'
                                      : DateFormat(
                                        'EEEE, dd MMMM yyyy',
                                        'id_ID',
                                      ).format(_selectedDepartureDate!),
                                  style: TextStyle(
                                    fontSize: 16,
                                    color:
                                        _selectedDepartureDate == null
                                            ? Colors.grey
                                            : Colors.black,
                                  ),
                                ),
                              ),
                            ),
                          ),
                          const Icon(
                            Icons.arrow_drop_down,
                            color: Colors.black54,
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),
                  const Text(
                    'Jumlah Kursi',
                    style: TextStyle(color: Colors.black87, fontSize: 16),
                  ),
                  GestureDetector(
                    onTap: () {
                      _showSeatPickerDialog(context);
                    },
                    child: AbsorbPointer(
                      child: Row(
                        children: [
                          const Icon(
                            Icons.event_seat_outlined,
                            size: 24,
                            color: Colors.black54,
                          ),
                          const SizedBox(width: 10),
                          Expanded(
                            child: Container(
                              height: 30,
                              padding: const EdgeInsets.symmetric(vertical: 5),
                              decoration: const BoxDecoration(
                                border: Border(
                                  bottom: BorderSide(color: Colors.black54),
                                ),
                              ),
                              child: Align(
                                alignment: Alignment.centerLeft,
                                child:
                                    _jumlahKursiTerpilih > 0
                                        ? Text(
                                          _detailKursiTerpilih.isNotEmpty
                                              ? (_detailKursiTerpilih.length > 2
                                                  ? '${_detailKursiTerpilih.take(2).join(', ')}... (${_detailKursiTerpilih.length} Kursi)'
                                                  : '${_detailKursiTerpilih.join(', ')} (${_detailKursiTerpilih.length} Kursi)')
                                              : '${_jumlahKursiTerpilih} Kursi',
                                          style: const TextStyle(
                                            fontSize: 16,
                                            color: Colors.black,
                                          ),
                                          overflow: TextOverflow.ellipsis,
                                        )
                                        : const Text(
                                          'Pilih Jumlah Kursi',
                                          style: TextStyle(
                                            fontSize: 16,
                                            color: Colors.grey,
                                          ),
                                        ),
                              ),
                            ),
                          ),
                          const Icon(
                            Icons.arrow_drop_down,
                            color: Colors.black54,
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 30),
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: () {
                        if (_selectedDariCity == null ||
                            _selectedKeCity == null ||
                            _selectedDepartureDate == null ||
                            (_jumlahKursiTerpilih == 0 &&
                                _detailKursiTerpilih.isEmpty)) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content: Text('Harap lengkapi semua pilihan!'),
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
                                  jumlahPenumpang:
                                      _detailKursiTerpilih.isNotEmpty
                                          ? _detailKursiTerpilih.length
                                          : _jumlahKursiTerpilih,
                                ),
                          ),
                        );
                      },
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
                  const Expanded(
                    child: SizedBox(),
                  ), // Untuk mengisi sisa ruang jika konten sedikit
                ],
              ),
            ),
          ),
        ],
      ),
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
        child: SharedBottomNavBar(
          // Menggunakan widget SharedBottomNavBar
          currentIndex: _currentIndex,
          onItemTapped: _handleBottomNavTapped,
        ),
      ),
    );
  }
}
