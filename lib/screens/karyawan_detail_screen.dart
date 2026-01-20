import 'package:flutter/material.dart';
import '../models/karyawan.dart';
import 'package:google_fonts/google_fonts.dart';

class KaryawanDetailScreen extends StatelessWidget {
  final Karyawan karyawan;

  const KaryawanDetailScreen({required this.karyawan, Key? key})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Detail Karyawan",
          style: GoogleFonts.poppins(fontWeight: FontWeight.bold),
        ),
        backgroundColor: Colors.blueAccent,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Card(
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
          elevation: 4,
          child: Padding(
            padding: const EdgeInsets.all(20.0),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "Nama: ${karyawan.nama}",
                  style: GoogleFonts.poppins(
                      fontSize: 20, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 12),
                Text(
                  "Posisi: ${karyawan.posisi}",
                  style: GoogleFonts.poppins(fontSize: 18),
                ),
                const SizedBox(height: 12),
                Text(
                  "Gaji: Rp ${karyawan.gaji.toStringAsFixed(0)}",
                  style: GoogleFonts.poppins(fontSize: 18),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
