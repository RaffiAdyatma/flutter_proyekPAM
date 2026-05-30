class ApiUrl {
  static const String baseUrl = 'http://localhost/toko_api/public';

  static const String registrasi = '$baseUrl/registrasi';
  static const String login = '$baseUrl/login';
  static const String listProduk = '$baseUrl/produk';
  static const String createProduk = '$baseUrl/produk';
  static const String gambar = '$baseUrl/uploads/';

  static String updateProduk(int id) {
    return '$baseUrl/produk/$id/update';
  }

  static String showProduk(int id) {
    return '$baseUrl/produk/$id';
  }

  static String deleteProduk(int id) {
    return '$baseUrl/produk/$id';
  }

  // Tambahkan di bawah endpoint produk
  static const String createBid = '$baseUrl/bid';
  
  static String listBid(int produkId) {
    return '$baseUrl/bid/produk/$produkId';
  }

  static String updateBid(int id) {
    return '$baseUrl/bid/$id';
  }

  static String deleteBid(int id) {
    return '$baseUrl/bid/$id';
  }
}
