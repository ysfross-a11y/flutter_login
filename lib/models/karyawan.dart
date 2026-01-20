class Karyawan {
  int? id;
  String nama;
  String posisi;
  double gaji;

  Karyawan(
      {this.id, required this.nama, required this.posisi, required this.gaji});

  factory Karyawan.fromJson(Map<String, dynamic> json) {
    return Karyawan(
      id: int.parse(json['id'].toString()),
      nama: json['nama'],
      posisi: json['posisi'],
      gaji: double.parse(json['gaji'].toString()),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'nama': nama,
      'posisi': posisi,
      'gaji': gaji,
    };
  }
}
