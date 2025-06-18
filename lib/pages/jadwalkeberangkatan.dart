import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:bussgo/services/jadwal_service.dart';
import 'package:bussgo/models/jadwal_from_api.dart';
import 'package:bussgo/pages/detail_tiket.dart';
import 'app_color.dart';

class JadwalKeberangkatanScreen extends StatefulWidget {
  final String kotaAsal;
  final String kotaTujuan;
  final DateTime tanggalKeberangkatan;
  final int jumlahPenumpang;
  final Map<String, dynamic> currentUser;

  const JadwalKeberangkatanScreen({
    Key? key,
    required this.kotaAsal,
    required this.kotaTujuan,
    required this.tanggalKeberangkatan,
    required this.jumlahPenumpang,
    required this.currentUser,
  }) : super(key: key);

  @override
  State<JadwalKeberangkatanScreen> createState() =>
      _JadwalKeberangkatanScreenState();
}

class _JadwalKeberangkatanScreenState extends State<JadwalKeberangkatanScreen> {
  late Future<List<JadwalFromApi>> _futureJadwal;

  @override
  void initState() {
    super.initState();
    _loadJadwal();
  }

  void _loadJadwal() {
    String tanggalFormatted = DateFormat(
      'yyyy-MM-dd',
    ).format(widget.tanggalKeberangkatan);
    setState(() {
      _futureJadwal = JadwalService.cariJadwal(
        asal: widget.kotaAsal,
        tujuan: widget.kotaTujuan,
        tanggal: tanggalFormatted,
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    String formattedDate = DateFormat(
      'EEEE, dd MMMM yyyy',
      'id_ID',
    ).format(widget.tanggalKeberangkatan);
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
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "Pilih Jadwal Keberangkatan",
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: Colors.grey[800],
              ),
            ),
            Text(
              formattedDate,
              style: TextStyle(fontSize: 16, color: Colors.grey[700]),
            ),
            const SizedBox(height: 20),
            Expanded(
              child: FutureBuilder<List<JadwalFromApi>>(
                future: _futureJadwal,
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(child: CircularProgressIndicator());
                  }
                  if (snapshot.hasError) {
                    return Center(
                      child: Text('Gagal memuat jadwal: ${snapshot.error}'),
                    );
                  }
                  if (!snapshot.hasData || snapshot.data!.isEmpty) {
                    return const Center(
                      child: Text(
                        'Maaf, jadwal untuk rute dan tanggal ini tidak ditemukan.',
                      ),
                    );
                  }
                  final daftarJadwal = snapshot.data!;
                  return ListView.builder(
                    itemCount: daftarJadwal.length,
                    itemBuilder: (context, index) {
                      final jadwal = daftarJadwal[index];
                      final bool isAvailable =
                          jadwal.kursiTersedia >= widget.jumlahPenumpang;
                      return Card(
                        elevation: 2.0,
                        margin: const EdgeInsets.only(bottom: 16.0),
                        color: Colors.white,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(15.0),
                        ),
                        child: InkWell(
                          borderRadius: BorderRadius.circular(15.0),
                          onTap:
                              isAvailable
                                  ? () {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder:
                                            (context) => DetailPerjalananScreen(
                                              kotaAsal: widget.kotaAsal,
                                              kotaTujuan: widget.kotaTujuan,
                                              tanggalKeberangkatan:
                                                  widget.tanggalKeberangkatan,
                                              jadwalTerpilih: jadwal,
                                              jumlahPenumpang:
                                                  widget.jumlahPenumpang,
                                              currentUser: widget.currentUser,
                                            ),
                                      ),
                                    );
                                  }
                                  : null,
                          child: Padding(
                            padding: const EdgeInsets.all(16.0),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  jadwal.bus['nama'] ?? 'N/A',
                                  style: const TextStyle(
                                    fontSize: 17,
                                    fontWeight: FontWeight.bold,
                                    color: mainBlue,
                                  ),
                                ),
                                const SizedBox(height: 10),
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    _buildInfoColumn(
                                      "Berangkat",
                                      jadwal.jamBerangkat,
                                    ),
                                    _buildInfoColumn(
                                      "Sampai",
                                      jadwal.jamSampai,
                                    ),
                                    _buildInfoColumn(
                                      "IDR",
                                      NumberFormat.decimalPattern(
                                        'id',
                                      ).format(jadwal.harga),
                                      isPrice: true,
                                    ),
                                  ],
                                ),
                                const SizedBox(height: 12),
                                Center(
                                  child: Text(
                                    isAvailable
                                        ? "Pesan Sekarang!"
                                        : "Kursi Tidak Cukup",
                                    style: TextStyle(
                                      fontSize: 14,
                                      fontWeight: FontWeight.bold,
                                      color:
                                          isAvailable
                                              ? Colors.green.shade700
                                              : Colors.red.shade700,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      );
                    },
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildInfoColumn(String title, String value, {bool isPrice = false}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(title, style: TextStyle(fontSize: 12, color: Colors.grey[700])),
        const SizedBox(height: 2),
        Text(
          value,
          style: TextStyle(
            fontSize: isPrice ? 18 : 16,
            fontWeight: FontWeight.bold,
            color: isPrice ? Colors.green[700] : Colors.black87,
          ),
        ),
      ],
    );
  }
}
