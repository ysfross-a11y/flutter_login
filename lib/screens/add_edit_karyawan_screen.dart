import 'package:flutter/material.dart';
import '../models/karyawan.dart';
import '../services/api_service.dart';
import 'package:google_fonts/google_fonts.dart';

class AddEditKaryawanScreen extends StatefulWidget {
  final Karyawan? karyawan;
  const AddEditKaryawanScreen({this.karyawan, Key? key}) : super(key: key);

  @override
  State<AddEditKaryawanScreen> createState() => _AddEditKaryawanScreenState();
}

class _AddEditKaryawanScreenState extends State<AddEditKaryawanScreen> {
  final _namaController = TextEditingController();
  final _posisiController = TextEditingController();
  final _gajiController = TextEditingController();
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    if (widget.karyawan != null) {
      _namaController.text = widget.karyawan!.nama;
      _posisiController.text = widget.karyawan!.posisi;
      _gajiController.text = widget.karyawan!.gaji.toString();
    }
  }

  void save() async {
    if (_namaController.text.isEmpty ||
        _posisiController.text.isEmpty ||
        _gajiController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
            content: Text("Semua field harus diisi"),
            backgroundColor: Colors.redAccent),
      );
      return;
    }

    setState(() => _isLoading = true);

    final k = Karyawan(
      id: widget.karyawan?.id,
      nama: _namaController.text,
      posisi: _posisiController.text,
      gaji: double.parse(_gajiController.text),
    );

    bool success;
    if (widget.karyawan == null) {
      success = await ApiService.addKaryawan(k);
    } else {
      success = await ApiService.updateKaryawan(k);
    }

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(success ? "Berhasil disimpan" : "Gagal menyimpan"),
        backgroundColor: success ? Colors.green : Colors.red,
      ),
    );

    setState(() => _isLoading = false);

    if (success) Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          widget.karyawan == null ? "Tambah Karyawan" : "Edit Karyawan",
          style: GoogleFonts.poppins(),
        ),
        backgroundColor: Colors.blueAccent,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Column(
          children: [
            TextField(
              controller: _namaController,
              decoration: const InputDecoration(
                  labelText: 'Nama', prefixIcon: Icon(Icons.person)),
            ),
            const SizedBox(height: 12),
            TextField(
              controller: _posisiController,
              decoration: const InputDecoration(
                  labelText: 'Posisi', prefixIcon: Icon(Icons.work)),
            ),
            const SizedBox(height: 12),
            TextField(
              controller: _gajiController,
              decoration: const InputDecoration(
                  labelText: 'Gaji', prefixIcon: Icon(Icons.attach_money)),
              keyboardType: TextInputType.number,
            ),
            const SizedBox(height: 24),
            ElevatedButton(
              onPressed: _isLoading ? null : save,
              style: ElevatedButton.styleFrom(
                minimumSize: const Size.fromHeight(50),
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12)),
              ),
              child: _isLoading
                  ? const CircularProgressIndicator(color: Colors.white)
                  : Text(widget.karyawan == null ? "Tambah" : "Simpan",
                      style: const TextStyle(fontSize: 18)),
            )
          ],
        ),
      ),
    );
  }
}
