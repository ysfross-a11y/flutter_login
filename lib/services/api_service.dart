import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/admin.dart';
import '../models/karyawan.dart';

class ApiService {
  static const String baseUrl = "http://10.0.2.2/flutter_mysql_admin/backend";

// LOGIN ADMIN
  static Future<bool> loginAdmin(Admin admin) async {
    try {
      final response = await http.post(
        Uri.parse('$baseUrl/admin.php'),
        headers: {"Content-Type": "application/json"},
        body: jsonEncode({
          "username": admin.username.trim(),
          "password": admin.password.trim(),
        }),
      );

      print("STATUS CODE: ${response.statusCode}");
      print("RESPONSE BODY: ${response.body}");

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        return data['success'] == true;
      } else {
        return false;
      }
    } catch (e) {
      print("LOGIN ERROR: $e");
      return false;
    }
  }

  // GET DATA KARYAWAN
  static Future<List<Karyawan>> getKaryawan() async {
    try {
      final response = await http.get(Uri.parse('$baseUrl/karyawan.php'));
      if (response.statusCode == 200) {
        final List jsonData = json.decode(response.body);
        return jsonData.map((e) => Karyawan.fromJson(e)).toList();
      } else {
        return [];
      }
    } catch (e) {
      print("Get Karyawan error: $e");
      return [];
    }
  }

  // TAMBAH KARYAWAN
  static Future<bool> addKaryawan(Karyawan k) async {
    try {
      final response = await http.post(
        Uri.parse('$baseUrl/karyawan.php'),
        headers: {"Content-Type": "application/json"},
        body: jsonEncode(k.toJson()),
      );
      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        return data['success'] ?? false;
      } else {
        return false;
      }
    } catch (e) {
      print("Add Karyawan error: $e");
      return false;
    }
  }

  // UPDATE KARYAWAN
  static Future<bool> updateKaryawan(Karyawan k) async {
    try {
      final response = await http.put(
        Uri.parse('$baseUrl/karyawan.php'),
        headers: {"Content-Type": "application/json"},
        body: jsonEncode(k.toJson()),
      );
      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        return data['success'] ?? false;
      } else {
        return false;
      }
    } catch (e) {
      print("Update Karyawan error: $e");
      return false;
    }
  }

  // DELETE KARYAWAN
  static Future<bool> deleteKaryawan(int id) async {
    try {
      final response = await http.delete(
        Uri.parse('$baseUrl/karyawan.php?id=$id'),
      );
      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        return data['success'] ?? false;
      } else {
        return false;
      }
    } catch (e) {
      print("Delete Karyawan error: $e");
      return false;
    }
  }
}
