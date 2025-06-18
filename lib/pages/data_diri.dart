import 'package:flutter/material.dart';
import 'app_color.dart';

class DataDiriScreen extends StatelessWidget {
  final Map<String, dynamic> currentUser;

  const DataDiriScreen({Key? key, required this.currentUser}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Data Diri'),
        backgroundColor: mainBlue,
        titleTextStyle: const TextStyle(
          fontSize: 20,
          fontWeight: FontWeight.bold,
          color: Colors.white,
        ),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new, color: Colors.white),
          onPressed: () => Navigator.of(context).pop(),
        ),
      ),
      body: ListView(
        padding: const EdgeInsets.all(16.0),
        children: [
          Card(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12.0),
            ),
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                children: [
                  _buildInfoRow(
                    context,
                    Icons.badge_outlined,
                    'Nama Lengkap',
                    currentUser['nama_lengkap'] ?? '-',
                  ),
                  const Divider(color: Colors.black12),
                  _buildInfoRow(
                    context,
                    Icons.email_outlined,
                    'Email',
                    currentUser['email'] ?? '-',
                  ),
                  const Divider(color: Colors.black12),
                  _buildInfoRow(
                    context,
                    Icons.phone_iphone_outlined,
                    'No. Handphone',
                    currentUser['no_handphone'] ?? '-',
                  ),
                  const Divider(color: Colors.black12),
                  _buildInfoRow(
                    context,
                    Icons.location_city_outlined,
                    'Alamat',
                    currentUser['alamat'] ?? '-',
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildInfoRow(
    BuildContext context,
    IconData icon,
    String label,
    String value,
  ) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 12.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, color: mainBlue.withOpacity(0.8), size: 22),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  label,
                  style: TextStyle(fontSize: 14, color: Colors.grey[600]),
                ),
                const SizedBox(height: 4),
                Text(
                  value.isNotEmpty ? value : '-',
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                    color: Colors.black87,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
