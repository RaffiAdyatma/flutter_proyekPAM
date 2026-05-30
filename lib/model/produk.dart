class Produk {
  int? id;
  String? kodeProduk;
  String? namaProduk;
  int? hargaProduk;
  String? gambar;

  Produk({this.id, this.kodeProduk, this.namaProduk, this.hargaProduk, this.gambar});

  factory Produk.fromJson(Map<String, dynamic> obj) {
    return Produk(
      id: obj['id'] is int ? obj['id'] : int.tryParse(obj['id'].toString()),
      kodeProduk: obj['kode_produk'],
      namaProduk: obj['nama_produk'],
      hargaProduk: obj['harga'] is int
          ? obj['harga']
          : int.tryParse(obj['harga'].toString()),
      gambar: obj['gambar'],
    );
  }
}
