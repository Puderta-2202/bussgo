import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'tiket_saya.dart';
import 'jadwalkeberangkatan.dart';

const Color mainBlue = Color(0xFF1A9AEB);
const Color unselectableSeatColor = Color(0xFFA0A0A0);
const Color availableSeatColor = Color(0xFFD0D0D0);
const Color selectedSeatColor = mainBlue;

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _selectedIndex = 0;
  int _jumlahKursiTerpilih = 0;
  List<String> _detailKursiTerpilih = [];
  DateTime? _selectedDepartureDate;
  String? _selectedDariCity; // Variabel untuk kota asal
  String? _selectedKeCity; // Variabel untuk kota tujuan

  // Daftar kota di Sumatera Utara
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
    'Panyabungan',
    // Tambahkan kota lain jika perlu
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });

    if (index == 1) {
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => const TiketSayaPage()),
      );
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

            List<Widget> dialogSeatWidgets = [];
            dialogSeatWidgets.add(
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  buildSeat('Kernet', isSpecial: true, isSelectable: false),
                  buildSeat('CD', isSpecial: true, isSelectable: false),
                  const SizedBox(width: 20),
                  buildSeat('Sopir', isSpecial: true, isSelectable: false),
                ],
              ),
            );
            dialogSeatWidgets.add(const Divider(height: 20, thickness: 1));

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

    if (result != null) {
      setState(() {
        _detailKursiTerpilih = result;
        _jumlahKursiTerpilih = _detailKursiTerpilih.length;
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
    if (picked != null && picked != _selectedDepartureDate) {
      setState(() {
        _selectedDepartureDate = picked;
      });
    }
  }

  // Fungsi untuk menampilkan dialog pemilihan kota
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
            textAlign: TextAlign.center,
          ),
          contentPadding: const EdgeInsets.only(
            top: 10.0,
          ), // Mengurangi padding atas default
          content: SizedBox(
            width: double.maxFinite,
            height:
                MediaQuery.of(context).size.height *
                0.5, // Batasi tinggi dialog
            child: ListView.separated(
              shrinkWrap: true,
              itemCount: _kotaSumateraUtara.length,
              itemBuilder: (BuildContext context, int index) {
                return ListTile(
                  title: Text(_kotaSumateraUtara[index]),
                  onTap: () {
                    Navigator.of(context).pop(_kotaSumateraUtara[index]);
                  },
                );
              },
              separatorBuilder: (context, index) => const Divider(height: 1),
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

    if (selectedCity != null) {
      setState(() {
        if (isDariField) {
          _selectedDariCity = selectedCity;
        } else {
          _selectedKeCity = selectedCity;
        }
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          Container(
            // ... (Top Section - unchanged) ...
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
                          const Text(
                            'Rp 1.000.000',
                            style: TextStyle(
                              color: Colors.black,
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(width: 8),
                          Icon(
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
              padding: const EdgeInsets.all(20),
              decoration: const BoxDecoration(color: Color(0xFFE3F2FD)),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Dari (From) Field - MODIFIED
                  const Text(
                    'Dari',
                    style: TextStyle(color: Colors.black87, fontSize: 16),
                  ),
                  GestureDetector(
                    onTap: () {
                      _showCityPickerDialog(
                        context,
                        true,
                      ); // true untuk isDariField
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
                                  bottom: BorderSide(
                                    color: Colors.black54,
                                    width: 1.0,
                                  ),
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

                  // Ke (To) Field - MODIFIED
                  const Text(
                    'Ke',
                    style: TextStyle(color: Colors.black87, fontSize: 16),
                  ),
                  GestureDetector(
                    onTap: () {
                      _showCityPickerDialog(
                        context,
                        false,
                      ); // false untuk isDariField (artinya Ke)
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
                                  bottom: BorderSide(
                                    color: Colors.black54,
                                    width: 1.0,
                                  ),
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

                  // Tanggal Keberangkatan (Departure Date) Field - unchanged
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
                                  bottom: BorderSide(
                                    color: Colors.black54,
                                    width: 1.0,
                                  ),
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

                  // Jumlah Kursi (Number of Seats) Field - unchanged
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
                                  bottom: BorderSide(
                                    color: Colors.black54,
                                    width: 1.0,
                                  ),
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
                            _selectedDariCity!.isEmpty) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content: Text('Kota asal belum dipilih!'),
                            ),
                          );
                          return;
                        }
                        if (_selectedKeCity == null ||
                            _selectedKeCity!.isEmpty) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content: Text('Kota tujuan belum dipilih!'),
                            ),
                          );
                          return;
                        }
                        if (_selectedDepartureDate == null) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content: Text(
                                'Tanggal keberangkatan belum dipilih!',
                              ),
                            ),
                          );
                          return;
                        }
                        if (_jumlahKursiTerpilih == 0 &&
                            _detailKursiTerpilih.isEmpty) {
                          // Cek apakah kursi sudah dipilih
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content: Text('Jumlah kursi belum dipilih!'),
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
                                  // Menggunakan _jumlahKursiTerpilih atau panjang dari _detailKursiTerpilih
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
                  const Spacer(),
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
                          Icons.home_outlined,
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
              fontWeight: isActive ? FontWeight.bold : FontWeight.normal,
            ),
          ),
        ],
      ),
    );
  }
}
