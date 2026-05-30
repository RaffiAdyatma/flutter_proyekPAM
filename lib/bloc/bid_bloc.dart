import 'dart:convert';
import 'package:tokokita/helpers/api.dart';
import 'package:tokokita/helpers/api_url.dart';
import 'package:tokokita/model/bid.dart';

class BidBloc {
  // Get List Bid per Produk
  static Future<List<Bid>> getBidsByProduk(int produkId) async {
    String apiUrl = ApiUrl.listBid(produkId);
    var response = await Api().get(apiUrl);
    var jsonObj = json.decode(response.body);
    List<dynamic> listBid = (jsonObj as Map<String, dynamic>)['data'];
    List<Bid> bids = [];
    for (int i = 0; i < listBid.length; i++) {
      bids.add(Bid.fromJson(listBid[i]));
    }
    return bids;
  }

  // Tambah Bid Baru
  static Future addBid({required Bid bid}) async {
    String apiUrl = ApiUrl.createBid;
    var body = {
      "produk_id": bid.produkId.toString(),
      "member_id": bid.memberId.toString(),
      "bid_value": bid.bidValue.toString()
    };
    var response = await Api().post(apiUrl, body);
    var jsonObj = json.decode(response.body);
    return jsonObj['status'];
  }

  // Ubah Bid
  static Future<bool> updateBid({required Bid bid}) async {
    String apiUrl = ApiUrl.updateBid(bid.id!);
    var body = {
      "bid_value": bid.bidValue.toString()
    };
    var response = await Api().post(apiUrl, body);
    var jsonObj = json.decode(response.body);
    return jsonObj['data'];
  }

  // Hapus Bid
  static Future<bool> deleteBid({required int id}) async {
    String apiUrl = ApiUrl.deleteBid(id);
    var response = await Api().delete(apiUrl);
    var jsonObj = json.decode(response.body);
    return (jsonObj as Map<String, dynamic>)['data'];
  }
}