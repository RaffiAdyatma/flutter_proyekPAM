import 'package:flutter/material.dart';
import 'package:tokokita/helpers/api_url.dart';
import 'package:tokokita/model/produk.dart';

class GambarProduk extends StatelessWidget {
  final Produk produk;
  final double width;
  final double height;

  const GambarProduk({
    super.key,
    required this.produk,
    this.width = 100,
    this.height = 100,
  });

  @override
  Widget build(BuildContext context) {
    if (produk.gambar != null && produk.gambar!.isNotEmpty) {
      return Image.network(
        ApiUrl.gambar + produk.gambar!,
        width: width,
        height: height,
        fit: BoxFit.cover,
        errorBuilder: (context, error, stackTrace) {
          return const Icon(Icons.broken_image, size: 50, color: Colors.grey);
        },
      );
    } else {
      return const Icon(
        Icons.image_not_supported,
        size: 50,
        color: Colors.grey,
      );
    }
  }
}
