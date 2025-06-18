import 'package:bussgo/services/jadwal_service.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:bussgo/models/jadwal_from_api.dart';
// import 'jadwalkeberangkatan.dart';
import 'perjalanan_screen.dart';
import 'app_color.dart';

class DetailPerjalananScreen extends StatefulWidget {
  final String kotaAsal;
  final String kotaTujuan;
  final DateTime tanggalKeberangkatan;
  final JadwalFromApi jadwalTerpilih;
  final int jumlahPenumpang;
  final Map<String, dynamic> currentUser;

  const DetailPerjalananScreen({
    Key? key,
    required this.kotaAsal,
    required this.kotaTujuan,
    required this.tanggalKeberangkatan,
    required this.jadwalTerpilih,
    required this.jumlahPenumpang,
    required this.currentUser,
  }) : super(key: key);

  @override
  State<DetailPerjalananScreen> createState() => _DetailPerjalananScreenState();
}

class _DetailPerjalananScreenState extends State<DetailPerjalananScreen> {
  List<String> _kursiPilihan = [];
  bool _isLoadingKursi = false;
  bool _termsAccepted = false;

  Future<void> _showSeatPickerDialog() async {
    setState(() {
      _isLoadingKursi = true;
    });

    try {
      final kursiTerisi = await JadwalService.getKursiTerisi(
        widget.jadwalTerpilih.id,
      );
      if (!mounted) return;
      setState(() {
        _isLoadingKursi = false;
      });

      List<String> tempSelectedSeats = List.from(_kursiPilihan);
      final result = await showDialog<List<String>>(
        context: context,
        barrierDismissible: false,
        builder: (BuildContext context) {
          return StatefulBuilder(
            builder: (context, setDialogState) {
              Widget buildSeat(String label, {bool isDriver = false}) {
                final bool isTaken = kursiTerisi.contains(label);
                final bool isSelected = tempSelectedSeats.contains(label);
                Color seatColor =
                    isDriver
                        ? Colors.black54
                        : (isTaken
                            ? Colors.grey.shade500
                            : (isSelected
                                ? selectedSeatColor
                                : availableSeatColor));

                return GestureDetector(
                  onTap:
                      isTaken || isDriver
                          ? null
                          : () {
                            setDialogState(() {
                              if (isSelected) {
                                tempSelectedSeats.remove(label);
                              } else {
                                if (tempSelectedSeats.length <
                                    widget.jumlahPenumpang) {
                                  tempSelectedSeats.add(label);
                                } else {
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    SnackBar(
                                      content: Text(
                                        'Anda hanya bisa memilih ${widget.jumlahPenumpang} kursi.',
                                      ),
                                      duration: const Duration(seconds: 1),
                                    ),
                                  );
                                }
                              }
                            });
                          },
                  child: Container(
                    width: 45,
                    height: 40,
                    margin: const EdgeInsets.all(4),
                    decoration: BoxDecoration(
                      color: seatColor,
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(color: Colors.black26),
                    ),
                    child: Center(
                      child:
                          isDriver
                              ? const Icon(
                                Icons.directions_bus,
                                color: Colors.white,
                                size: 20,
                              )
                              : Text(
                                label,
                                style: TextStyle(
                                  color:
                                      isTaken || isSelected
                                          ? Colors.white
                                          : Colors.black87,
                                  fontWeight:
                                      isSelected
                                          ? FontWeight.bold
                                          : FontWeight.normal,
                                ),
                              ),
                    ),
                  ),
                );
              }

              List<Widget> seatLayoutWidgets = [
                Padding(
                  padding: const EdgeInsets.only(
                    bottom: 16.0,
                    left: 8.0,
                    right: 8.0,
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [buildSeat("S", isDriver: true)],
                  ),
                ),
              ];

              int totalKursi =
                  int.tryParse(
                    widget.jadwalTerpilih.bus['kapasitas_kursi']?.toString() ??
                        '0',
                  ) ??
                  0;
              int seatCounter = 1;
              while (seatCounter <= totalKursi) {
                seatLayoutWidgets.add(
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 2.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        if (seatCounter <= totalKursi)
                          buildSeat((seatCounter++).toString())
                        else
                          const SizedBox(width: 49),
                        if (seatCounter <= totalKursi)
                          buildSeat((seatCounter++).toString())
                        else
                          const SizedBox(width: 49),
                        const SizedBox(width: 30), // Lorong Bus
                        if (seatCounter <= totalKursi)
                          buildSeat((seatCounter++).toString()),
                        if (seatCounter <= totalKursi)
                          buildSeat((seatCounter++).toString())
                        else
                          const SizedBox(width: 49),
                      ],
                    ),
                  ),
                );
              }

              return AlertDialog(
                title: Center(
                  child: Text(
                    'Pilih Kursi (${tempSelectedSeats.length}/${widget.jumlahPenumpang})',
                  ),
                ),
                content: SizedBox(
                  width: double.maxFinite,
                  child: SingleChildScrollView(
                    child: Column(children: seatLayoutWidgets),
                  ),
                ),
                actions: [
                  TextButton(
                    onPressed: () => Navigator.of(context).pop(),
                    child: const Text('Batal'),
                  ),
                  ElevatedButton(
                    onPressed:
                        () => Navigator.of(context).pop(tempSelectedSeats),
                    child: const Text('Pilih'),
                  ),
                ],
              );
            },
          );
        },
      );
      if (result != null) {
        setState(() {
          _kursiPilihan = result;
        });
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          _isLoadingKursi = false;
        });
      }
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text(e.toString())));
    }
  }

  // Di dalam kelas _DetailPerjalananScreenState

  void _lanjutKePilihPembayaran() {
    if (_kursiPilihan.length != widget.jumlahPenumpang) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            'Harap pilih kursi sebanyak ${widget.jumlahPenumpang} buah.',
          ),
        ),
      );
      return;
    }

    // Hitung total harga di sini
    int totalHarga = widget.jadwalTerpilih.harga * widget.jumlahPenumpang;

    Navigator.push(
      context,
      MaterialPageRoute(
        builder:
            (context) => PilihPembayaranScreen(
              // --- PASTIKAN SEMUA PARAMETER INI DIKIRIM ---
              totalHarga: totalHarga,
              kotaAsal: widget.kotaAsal,
              kotaTujuan: widget.kotaTujuan,
              tanggalKeberangkatan: widget.tanggalKeberangkatan,
              jadwalTerpilih: widget.jadwalTerpilih,
              jumlahPenumpang: widget.jumlahPenumpang,
              kursiPilihan: _kursiPilihan, // Ini penting untuk dikirim
              currentUser: widget.currentUser, // Ini juga penting
            ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    String formattedDate = DateFormat(
      'EEEE, dd MMMM yyyy',
      'id_ID',
    ).format(widget.tanggalKeberangkatan);
    String jamPerjalanan =
        "${widget.jadwalTerpilih.jamBerangkat} - ${widget.jadwalTerpilih.jamSampai}";
    int totalHarga = widget.jadwalTerpilih.harga * widget.jumlahPenumpang;
    String formattedTotalHarga = NumberFormat.currency(
      locale: 'id_ID',
      symbol: 'IDR ',
      decimalDigits: 0,
    ).format(totalHarga);

    return Scaffold(
      backgroundColor: screenBgLightBlue,
      appBar: AppBar(
        backgroundColor: mainBlue,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Navigator.of(context).pop(),
        ),
        title: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              widget.kotaAsal,
              style: const TextStyle(color: Colors.white, fontSize: 18),
            ),
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 8.0),
              child: Icon(Icons.arrow_forward, color: Colors.white, size: 20),
            ),
            Text(
              widget.kotaTujuan,
              style: const TextStyle(color: Colors.white, fontSize: 18),
            ),
          ],
        ),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              "Detail Perjalanan",
              style: TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.bold,
                color: Color(0xFF0D47A1),
              ),
            ),
            const SizedBox(height: 16),
            _buildDetailCard(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    formattedDate,
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: Colors.black87,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    jamPerjalanan,
                    style: const TextStyle(fontSize: 15, color: Colors.black54),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),
            _buildDetailCard(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    "Info Kontak",
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF0D47A1),
                    ),
                  ),
                  const SizedBox(height: 12),
                  _buildInfoRow(
                    "Nama",
                    widget.currentUser['nama_lengkap'] ?? '-',
                  ),
                  _buildInfoRow("Email", widget.currentUser['email'] ?? '-'),
                  _buildInfoRow(
                    "No. Handphone",
                    widget.currentUser['no_handphone'] ?? '-',
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),
            _buildDetailCard(
              child: ListTile(
                contentPadding: EdgeInsets.zero,
                leading: const Icon(
                  Icons.event_seat,
                  color: mainBlue,
                  size: 32,
                ),
                title: const Text(
                  "Pilih Kursi",
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                ),
                subtitle: Text(
                  _kursiPilihan.isEmpty
                      ? 'Anda belum memilih kursi'
                      : 'Terpilih: ${_kursiPilihan.join(', ')}',
                ),
                trailing:
                    _isLoadingKursi
                        ? const SizedBox(
                          width: 24,
                          height: 24,
                          child: CircularProgressIndicator(strokeWidth: 2.5),
                        )
                        : const Icon(Icons.arrow_forward_ios),
                onTap: _isLoadingKursi ? null : _showSeatPickerDialog,
              ),
            ),
            const SizedBox(height: 20),
            _buildDetailCard(
              child: _buildInfoRow(
                "Total Harga",
                formattedTotalHarga,
                isBold: true,
                valueColor: mainBlue,
              ),
            ),
            const SizedBox(height: 20),
            _buildDetailCard(
              child: Column(
                children: [
                  CheckboxListTile(
                    title: const Text(
                      "Saya menyetujui Term and condition",
                      style: TextStyle(fontSize: 14, color: Colors.black54),
                    ),
                    value: _termsAccepted,
                    onChanged: (bool? value) {
                      setState(() {
                        _termsAccepted = value ?? false;
                      });
                    },
                    controlAffinity: ListTileControlAffinity.leading,
                    contentPadding: EdgeInsets.zero,
                    activeColor: mainBlue,
                  ),
                  const SizedBox(height: 10),
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed:
                          (_termsAccepted &&
                                  _kursiPilihan.length ==
                                      widget.jumlahPenumpang)
                              ? _lanjutKePilihPembayaran
                              : null,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: mainBlue,
                        padding: const EdgeInsets.symmetric(vertical: 15),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                      child: const Text(
                        "Pilih Metode Pembayaran",
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDetailCard({required Widget child}) {
    return Card(
      elevation: 2,
      shadowColor: Colors.black12,
      color: Colors.white,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12.0)),
      child: Padding(padding: const EdgeInsets.all(16.0), child: child),
    );
  }

  Widget _buildInfoRow(
    String label,
    String value, {
    bool isBold = false,
    Color? valueColor,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 110,
            child: Text(
              label,
              style: const TextStyle(fontSize: 14, color: Colors.black54),
            ),
          ),
          const Text(
            ": ",
            style: TextStyle(fontSize: 14, color: Colors.black54),
          ),
          Expanded(
            child: Text(
              value,
              style: TextStyle(
                fontSize: 14,
                fontWeight: isBold ? FontWeight.w600 : FontWeight.normal,
                color: valueColor ?? Colors.black87,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
