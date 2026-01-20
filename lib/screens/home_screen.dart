import 'package:flutter/material.dart';
import 'package:flutter_mysql_admin/models/karyawan.dart';
import 'package:flutter_mysql_admin/screens/add_edit_karyawan_screen.dart';
import 'package:flutter_mysql_admin/screens/karyawan_detail_screen.dart';
import 'package:flutter_mysql_admin/services/api_service.dart';
import 'package:google_fonts/google_fonts.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  List<Karyawan> _karyawanList = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    fetchKaryawan();
  }

  Future<void> fetchKaryawan() async {
    setState(() => _isLoading = true);
    try {
      final list = await ApiService.getKaryawan();
      setState(() => _karyawanList = list);
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Gagal memuat data karyawan"),
          backgroundColor: Colors.redAccent,
        ),
      );
    } finally {
      setState(() => _isLoading = false);
    }
  }

  void deleteKaryawan(int id) async {
    bool success = await ApiService.deleteKaryawan(id);
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          success ? "Karyawan berhasil dihapus" : "Gagal menghapus karyawan",
        ),
        backgroundColor: success ? Colors.green : Colors.red,
      ),
    );
    if (success) fetchKaryawan();
  }

  void openAddEditScreen([Karyawan? karyawan]) async {
    await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => AddEditKaryawanScreen(karyawan: karyawan),
      ),
    );
    fetchKaryawan(); // refresh data setelah tambah/edit
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Data Karyawan",
          style: GoogleFonts.poppins(fontWeight: FontWeight.bold),
        ),
        backgroundColor: Colors.blueAccent,
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: fetchKaryawan,
            tooltip: 'Refresh',
          ),
        ],
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : _karyawanList.isEmpty
              ? Center(
                  child: Text(
                    "Belum ada data karyawan",
                    style:
                        GoogleFonts.poppins(fontSize: 16, color: Colors.grey),
                  ),
                )
              : RefreshIndicator(
                  onRefresh: fetchKaryawan,
                  child: ListView.builder(
                    padding: const EdgeInsets.all(12),
                    itemCount: _karyawanList.length,
                    itemBuilder: (context, index) {
                      final k = _karyawanList[index];
                      return Card(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(16),
                        ),
                        elevation: 3,
                        shadowColor: Colors.black26,
                        margin: const EdgeInsets.symmetric(
                            vertical: 8, horizontal: 12),
                        child: ListTile(
                          onTap: () {
                            // Navigasi ke halaman detail
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (_) =>
                                    KaryawanDetailScreen(karyawan: k),
                              ),
                            );
                          },
                          contentPadding: const EdgeInsets.symmetric(
                              horizontal: 20, vertical: 12),
                          title: Text(
                            k.nama,
                            style: GoogleFonts.poppins(
                              fontWeight: FontWeight.w600,
                              fontSize: 18,
                              color: Colors.black87,
                            ),
                          ),
                          subtitle: Text(
                            "${k.posisi} | Gaji: Rp ${k.gaji.toStringAsFixed(0)}",
                            style: GoogleFonts.poppins(
                                fontSize: 14, color: Colors.black54),
                          ),
                          trailing: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              IconButton(
                                icon: const Icon(Icons.edit,
                                    color: Colors.blueAccent),
                                onPressed: () => openAddEditScreen(k),
                              ),
                              IconButton(
                                icon: const Icon(Icons.delete,
                                    color: Colors.redAccent),
                                onPressed: () => showDialog(
                                  context: context,
                                  builder: (_) => AlertDialog(
                                    title: const Text("Hapus Karyawan"),
                                    content: Text(
                                        "Apakah yakin ingin menghapus ${k.nama}?"),
                                    actions: [
                                      TextButton(
                                        onPressed: () => Navigator.pop(context),
                                        child: const Text("Batal"),
                                      ),
                                      TextButton(
                                        onPressed: () {
                                          Navigator.pop(context);
                                          deleteKaryawan(k.id!);
                                        },
                                        child: const Text("Hapus",
                                            style: TextStyle(
                                                color: Colors.redAccent)),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  ),
                ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => openAddEditScreen(),
        label: const Text("Tambah"),
        icon: const Icon(Icons.add),
        backgroundColor: Colors.blueAccent,
      ),
    );
  }
}
