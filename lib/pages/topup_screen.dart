import 'package:flutter/material.dart';
import 'package:bussgo/services/topup_services.dart';
import 'app_color.dart';
import 'package:intl/intl.dart';

class TopUpScreen extends StatefulWidget {
  const TopUpScreen({Key? key}) : super(key: key);

  @override
  State<TopUpScreen> createState() => _TopUpScreenState();
}

class _TopUpScreenState extends State<TopUpScreen> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _amountController = TextEditingController();
  bool _isLoading = false;

  Future<void> _submitRequest() async {
    if (_formKey.currentState!.validate()) {
      setState(() {
        _isLoading = true;
      });

      try {
        await TopUpService.requestTopUp(amount: _amountController.text);
        if (!mounted) return;

        showDialog(
          context: context,
          builder:
              (context) => AlertDialog(
                title: const Text('Permintaan Terkirim'),
                content: const Text(
                  'Permintaan top up Anda telah berhasil dikirim dan akan segera diproses oleh admin.',
                ),
                actions: [
                  TextButton(
                    onPressed: () => Navigator.of(context).pop(),
                    child: const Text('OK'),
                  ),
                ],
              ),
        ).then((_) => Navigator.of(context).pop());
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            backgroundColor: Colors.red,
            content: Text(e.toString().replaceFirst('Exception: ', '')),
          ),
        );
      } finally {
        if (mounted) {
          setState(() {
            _isLoading = false;
          });
        }
      }
    }
  }

  @override
  void dispose() {
    _amountController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Request Top Up Saldo',
          style: TextStyle(color: Colors.white),
        ),
        backgroundColor: mainBlue,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Navigator.of(context).pop(),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Instruksi Permintaan Top Up',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 8),
              const Text(
                'Fitur ini digunakan untuk mengajukan permintaan penambahan saldo kepada admin. Silakan hubungi admin secara langsung untuk proses transfer dana.\n\nAdmin akan menyetujui permintaan Anda setelah konfirmasi diterima.',
                style: TextStyle(fontSize: 14, color: Colors.black54),
              ),
              const SizedBox(height: 24),
              TextFormField(
                controller: _amountController,
                keyboardType: const TextInputType.numberWithOptions(
                  decimal: false,
                ),
                decoration: InputDecoration(
                  labelText: 'Jumlah Top Up',
                  prefixText: 'Rp ',
                  border: const OutlineInputBorder(),
                  hintText: 'Contoh: 50000',
                ),
                validator: (value) {
                  if (value == null || value.isEmpty)
                    return 'Jumlah tidak boleh kosong';
                  if (int.tryParse(value) == null) return 'Harus berupa angka';
                  if (int.parse(value) < 10000)
                    return 'Minimum top up adalah Rp 10.000';
                  return null;
                },
              ),
              const SizedBox(height: 32),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: _isLoading ? null : _submitRequest,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: mainBlue,
                    padding: const EdgeInsets.symmetric(vertical: 16),
                  ),
                  child:
                      _isLoading
                          ? const SizedBox(
                            height: 24,
                            width: 24,
                            child: CircularProgressIndicator(
                              color: Colors.white,
                            ),
                          )
                          : const Text(
                            'Kirim Permintaan Top Up',
                            style: TextStyle(color: Colors.white, fontSize: 16),
                          ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
