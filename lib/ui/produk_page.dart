import 'package:flutter/material.dart';
import 'package:tokokita/bloc/bid_bloc.dart';
import 'package:tokokita/bloc/logout_bloc.dart';
import 'package:tokokita/bloc/produk_bloc.dart';
import 'package:tokokita/helpers/user_info.dart';
import 'package:tokokita/model/bid.dart';
import 'package:tokokita/model/produk.dart';
import 'package:tokokita/ui/login_page.dart';
import 'package:tokokita/ui/produk_detail.dart';
import 'package:tokokita/ui/produk_form.dart';
import 'package:intl/intl.dart';
import 'package:tokokita/ui/widget/produk_gambar.dart';

class ProdukPage extends StatefulWidget {
  const ProdukPage({super.key});

  @override
  _ProdukPageState createState() => _ProdukPageState();
}

class _ProdukPageState extends State<ProdukPage> {
  String search = '';
  int? _userId;

  @override
  void initState() {
    super.initState();
    _loadUserId();
  }

  Future<void> _loadUserId() async {
    final id = await UserInfo().getUserID();
    setState(() {
      _userId = id;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color(0xFFFAF5EE),
        toolbarHeight: 80,
        title: Expanded(
          child: Align(
            alignment: Alignment.center,
            child: Padding(
              padding: const EdgeInsets.fromLTRB(0, 0, 20, 0),
              child: ConstrainedBox(
                constraints: BoxConstraints(maxWidth: 500),
                child: TextField(
                  decoration: InputDecoration(
                    filled: true,
                    fillColor: Color(0xFFe6e0d6),
                    prefixIcon: Icon(Icons.search_outlined),

                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(100),
                      borderSide: BorderSide.none,
                    ),
                    hintText: "Search Produk",
                  ),

                  onChanged: (text) {
                    setState(() {
                      search = text;
                    });
                  },
                ),
              ),
            ),
          ),
        ),

        actions: [
          if (_userId == 1)
            Padding(
              padding: const EdgeInsets.only(right: 20.0),
              child: GestureDetector(
                child: const Icon(Icons.add, size: 26.0),
                onTap: () async {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => ProdukForm()),
                  );
                },
              ),
            ),
        ],
      ),
      drawer: Drawer(
        width: 200,
        backgroundColor: Color(0xFFf2ece4),
        child: ListView(
          children: [
            ListTile(
              title: const Text('Logout'),
              trailing: const Icon(Icons.logout),
              onTap: () async {
                await LogoutBloc.logout().then(
                  (value) => {
                    Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(builder: (context) => LoginPage()),
                    ),
                  },
                );
              },
            ),
          ],
        ),
      ),

      backgroundColor: Color(0xFFFAF5EE),
      body: Padding(
        padding: EdgeInsetsGeometry.symmetric(horizontal: 35),
        child: Column(
          spacing: 20,
          children: [
            Align(
              alignment: Alignment.centerLeft,
              child: Text("Katalog Barang", style: TextStyle(fontSize: 35)),
            ),

            Expanded(
              child: FutureBuilder<List>(
                future: ProdukBloc.getProduks(),
                builder: (context, snapshot) {
                  if (snapshot.hasError) {
                    print(snapshot.error);
                  }

                  List? allProduk = snapshot.data ?? [];
                  List filteredProduk = allProduk.where((produk) {
                    String nama = produk.namaProduk.toString();
                    return nama.toLowerCase().contains(search.toLowerCase());
                  }).toList();

                  return snapshot.hasData
                      ? ListProduk(list: filteredProduk, userId: _userId)
                      : const Center(child: CircularProgressIndicator());
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class ListProduk extends StatelessWidget {
  final List? list;
  final int? userId;

  const ListProduk({super.key, this.list, required this.userId});

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        int columns = constraints.maxWidth <= 800
            ? (constraints.maxWidth / 200).floor()
            : 4;

        return GridView.builder(
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: columns > 0 ? columns : 1,
            crossAxisSpacing: 20,
            mainAxisSpacing: 20,
            childAspectRatio: 3 / 4,
          ),

          itemCount: list == null ? 0 : list!.length,
          itemBuilder: (context, i) {
            return ItemProduk(produk: list![i], userId: userId);
          },
        );
      },
    );
  }
}

class ItemProduk extends StatelessWidget {
  final Produk produk;
  final int? userId;

  const ItemProduk({super.key, required this.produk, required this.userId});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => ProdukDetail(produk: produk, userId: userId),
          ),
        );
      },
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(15),
        ),
        child: Padding(
          padding: const EdgeInsets.all(15.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              GambarProduk(produk: produk),
              Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  produk.namaProduk!,
                  style: const TextStyle(fontSize: 24, fontWeight: FontWeight.w400, height: 1.33),
                ),
              ),
              Divider(thickness: 1, color: const Color(0x33D8D0C8)),
              
              FutureBuilder<List<Bid>>(
                future: BidBloc.getBidsByProduk(produk.id!),
                builder: (context, snapshot) {
                  int highestBid = 0;
                  if (snapshot.hasData && snapshot.data!.isNotEmpty) {
                    highestBid = snapshot.data!
                        .map((b) => b.bidValue ?? 0)
                        .reduce((curr, next) => curr > next ? curr : next);
                  }

                  return Column(
                    children: [
                      Align(
                        alignment: Alignment.centerLeft,
                        child: Text(
                          highestBid > 0 ? 'Tawaran Tertinggi :' : 'Harga Awal :',
                          style: const TextStyle(fontSize: 16, fontFamily: 'EB Garamond'),
                        ),
                      ),
                      Align(
                        alignment: Alignment.centerRight,
                        child: Text(
                          NumberFormat('#,##0', 'id_ID').format(highestBid > 0 ? highestBid : produk.hargaProduk),
                          style: const TextStyle(
                            color: Color(0xFFC2652A),
                            fontSize: 18,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ],
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}