import 'dart:convert';
import 'dart:io';

import 'package:http/http.dart' as http;
import 'package:tokokita/helpers/api.dart';
import 'package:tokokita/helpers/api_url.dart';
import 'package:tokokita/model/produk.dart';

class ProdukBloc {
  static Future<List<Produk>> getProduks() async {
    String apiUrl = ApiUrl.listProduk;
    var response = await Api().get(apiUrl);
    var jsonObj = json.decode(response.body);
    List<dynamic> listProduk = (jsonObj as Map<String, dynamic>)['data'];
    List<Produk> produks = [];
    for (int i = 0; i < listProduk.length; i++) {
      produks.add(Produk.fromJson(listProduk[i]));
    }
    return produks;
  }

  static Future addProduk({Produk? produk, File? imageFile}) async {
    try {
      var request = http.MultipartRequest('POST', Uri.parse(ApiUrl.createProduk));
      
      // Kirim data teks
      request.fields['kode_produk'] = produk!.kodeProduk!;
      request.fields['nama_produk'] = produk.namaProduk!;
      request.fields['harga'] = produk.hargaProduk.toString();

      // Kirim file gambar jika dipilih
      if (imageFile != null) {
        request.files.add(
          await http.MultipartFile.fromPath('gambar', imageFile.path),
        );
      }

      var streamedResponse = await request.send();
      var response = await http.Response.fromStream(streamedResponse);

      return response.statusCode == 200;
    } catch (e) {
      return false;
    }
  }

  static Future<bool> updateProduk({required Produk produk, File? imageFile}) async {
    try {
      // Mengarah ke URL update API (misal: /produk/ubah/id)
      var request = http.MultipartRequest('POST', Uri.parse(ApiUrl.updateProduk(produk.id!)));
      
      request.fields['kode_produk'] = produk.kodeProduk!;
      request.fields['nama_produk'] = produk.namaProduk!;
      request.fields['harga'] = produk.hargaProduk.toString();

      // Jika user memilih gambar BARU, kirim file barunya
      if (imageFile != null) {
        request.files.add(
          await http.MultipartFile.fromPath('gambar', imageFile.path),
        );
      }

      var streamedResponse = await request.send();
      var response = await http.Response.fromStream(streamedResponse);

      return response.statusCode == 200;
    } catch (e) {
      return false;
    }
  }

  static Future<bool> deleteProduk({int? id}) async {
  String apiUrl = ApiUrl.deleteProduk(id!);
  var response = await Api().delete(apiUrl);

  // Jika response.statusCode adalah 200, 201, atau 204, anggap sukses
  if (response.statusCode == 200 || response.statusCode == 204) {
    return true; 
  } else {
    // Jika tidak, lemparkan error untuk ditangkap oleh catchError
    throw Exception("Gagal menghapus: Server mengembalikan ${response.statusCode}");
  }
}
}
