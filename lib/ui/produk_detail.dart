import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:tokokita/bloc/bid_bloc.dart';
import 'package:tokokita/bloc/produk_bloc.dart';
import 'package:tokokita/model/bid.dart';
import 'package:tokokita/model/produk.dart';
import 'package:tokokita/ui/produk_form.dart';
import 'package:tokokita/ui/produk_page.dart';
import 'package:tokokita/ui/widget/produk_gambar.dart';
import 'package:tokokita/ui/widget/warning_dialog.dart';

List<Bid> _bids = [];
bool _isLoadingBids = true;
int? _currentUserId;
Bid? _myBid;
final _bidTextboxController = TextEditingController();
int _highestBidValue = 0;

class ProdukDetail extends StatefulWidget {
  Produk? produk;
  int? userId;

  ProdukDetail({Key? key, this.produk, this.userId}) : super(key: key);

  @override
  _ProdukDetailState createState() => _ProdukDetailState();
}

class _ProdukDetailState extends State<ProdukDetail> {
  @override
  void initState() {
    super.initState();
    _loadBids();
  }

  @override
  Widget build(BuildContext context) {
    bool isLargeScreen = MediaQuery.widthOf(context) > 800;

    return Scaffold(
      appBar: AppBar(backgroundColor: Color(0xFFfaf5ee)),

      backgroundColor: Color(0xFFfaf5ee),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: isLargeScreen
              ? SingleChildScrollView(
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          mainAxisSize: MainAxisSize.max,
                          children: [
                            GambarProduk(
                              produk: widget.produk!,
                              width: 400,
                              height: 400,
                            ),
                            _productDescription(),
                          ],
                        ),
                      ),

                      Expanded(
                        child: Container(
                          alignment: Alignment.center,
                          decoration: BoxDecoration(
                            color: Color(0xFFf2ece4),
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: Padding(
                            padding: const EdgeInsets.all(40.0),
                            child: _bidSection(),
                          ),
                        ),
                      ),
                    ],
                  ),
                )
              : SingleChildScrollView(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    mainAxisSize: MainAxisSize.max,
                    children: [
                      GambarProduk(
                        produk: widget.produk!,
                        width: 300,
                        height: 300,
                      ),
                      Padding(
                        padding: const EdgeInsets.all(20.0),
                        child: _productDescription(),
                      ),
                      const SizedBox(height: 20),

                      Container(
                        padding: const EdgeInsets.symmetric(
                          vertical: 60.0,
                          horizontal: 50.0,
                        ),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10),
                          color: Color(0xFFf2ece4),
                        ),
                        child: _bidSection(),
                      ),
                    ],
                  ),
                ),
        ),
      ),
    );
  }

  Widget _productDescription() {
    return Row(
      spacing: 20,
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              widget.produk!.namaProduk!,
              style: const TextStyle(
                color: Colors.black,
                fontSize: 40,
                fontWeight: FontWeight.w500,
              ),
            ),
            Text(
              widget.produk!.kodeProduk!,
              style: const TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.w500,
                color: Color(0xFF1C1C1C),
              ),
            ),
          ],
        ),
        if (_currentUserId == 1) _tombolHapusEdit(),
      ],
    );
  }

  Widget _tombolHapusEdit() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.end,
      mainAxisSize: MainAxisSize.min,
      spacing: 10,
      children: [
        GestureDetector(
          onTap: () => {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => ProdukForm(produk: widget.produk!),
              ),
            ),
          },
          child: Icon(Icons.edit_outlined, color: Color(0xFFC2652A)),
        ),

        GestureDetector(
          onTap: () => confirmHapus(),
          child: Icon(Icons.delete_outline, color: Colors.red),
        ),
      ],
    );
  }

  void confirmHapus() {
    AlertDialog alertDialog = AlertDialog(
      content: const Text("Yakin ingin menghapus data ini?"),
      actions: [
        OutlinedButton(
          child: const Text("Ya"),
          onPressed: () {
            Navigator.pop(context);

            ProdukBloc.deleteProduk(id: widget.produk!.id)
                .then((value) {
                  Navigator.of(context).pushReplacement(
                    MaterialPageRoute(builder: (context) => const ProdukPage()),
                  );
                })
                .catchError((error) {
                  showDialog(
                    context: context,
                    builder: (BuildContext context) => const WarningDialog(
                      description: "Hapus data gagal, silahkan coba lagi",
                    ),
                  );
                });
          },
        ),
        OutlinedButton(
          child: const Text("Batal"),
          onPressed: () => Navigator.pop(context),
        ),
      ],
    );

    showDialog(builder: (context) => alertDialog, context: context);
  }

  Widget _bidSection() {
    if (_isLoadingBids) {
      return const Padding(
        padding: EdgeInsets.all(20),
        child: Center(child: CircularProgressIndicator()),
      );
    }

    return ConstrainedBox(
      constraints: BoxConstraints(maxWidth: 400),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        mainAxisAlignment: MainAxisAlignment.center,
        mainAxisSize: MainAxisSize.max,
        spacing: 5,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                (_highestBidValue > 0) ? "Tawaran Tertinggi :" : "Harga Awal",
                style: TextStyle(fontSize: 17),
              ),
              Text(
                NumberFormat('#,##0', 'id_ID').format(
                  (_highestBidValue > 0)
                      ? _highestBidValue
                      : widget.produk!.hargaProduk!,
                ),
                style: TextStyle(fontSize: 30),
              ),
            ],
          ),

          if (_myBid != null) ...[
            Text(
              "Anda sudah mengajukan bid sebesar: Rp ${_myBid!.bidValue}",
              style: const TextStyle(fontSize: 12),
            ),
          ] else
            SizedBox(height: 10),

          TextFormField(
            controller: _bidTextboxController,
            keyboardType: TextInputType.number,
            decoration: InputDecoration(
              border: OutlineInputBorder(),

              filled: true,
              fillColor: Colors.white,

              hintText: (MediaQuery.widthOf(context) > 800)
                  ? "Harus lebih tinggi dari Rp ${_highestBidValue > 0 ? _highestBidValue : widget.produk?.hargaProduk}"
                  : "> ${_highestBidValue > 0 ? _highestBidValue : widget.produk?.hargaProduk}",
            ),
          ),

          if (_myBid == null)
            ElevatedButton(
              onPressed: _submitBid,
              style: ElevatedButton.styleFrom(
                backgroundColor: Color(0xFFc2652a),
                foregroundColor: Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadiusGeometry.circular(5),
                ),
              ),
              child: Text("Ajukan"),
            )
          else
            Row(
              spacing: 5,
              children: [
                Expanded(
                  child: ElevatedButton(
                    onPressed: _submitBid,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Color(0xFFc2652a),
                      foregroundColor: Colors.white,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadiusGeometry.circular(5),
                      ),
                    ),
                    child: Text("tawarkan"),
                  ),
                ),
                OutlinedButton(
                  onPressed: _hapusBid,
                  style: OutlinedButton.styleFrom(
                    backgroundColor: Colors.white,
                    foregroundColor: Colors.red,
                    side: BorderSide(color: Colors.red),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadiusGeometry.circular(5),
                    ),
                  ),

                  child: Icon(Icons.delete_outline),
                ),
              ],
            ),
        ],
      ),
    );
  }

  void _submitBid() async {
    if (_bidTextboxController.text.isEmpty) {
      _showWarningSnackBar("Masukkan penawaran");
      return;
    }

    int inputBid = int.parse(_bidTextboxController.text);
    int hargaAwal = widget.produk!.hargaProduk ?? 0;

    // VALIDASI 1: Jika belum ada bid, input harus di atas harga awal produk
    if (_highestBidValue == 0 && inputBid <= hargaAwal) {
      _showWarningSnackBar(
        "Penawaran harus lebih tinggi dari harga awal produk (Rp $hargaAwal)",
      );
      return;
    }

    // VALIDASI 2: Jika sudah ada bid, input baru harus melampaui bid tertinggi saat ini
    if (_highestBidValue > 0 && inputBid <= _highestBidValue) {
      _showWarningSnackBar(
        "Penawaran harus lebih tinggi dari bid terbesar saat ini (Rp $_highestBidValue)",
      );
      return;
    }

    setState(() {
      _isLoadingBids = true;
    });

    try {
      if (_myBid == null) {
        Bid newBid = Bid(
          produkId: widget.produk!.id,
          memberId: _currentUserId,
          bidValue: inputBid,
        );
        await BidBloc.addBid(bid: newBid);
      } else {
        _myBid!.bidValue = inputBid;
        await BidBloc.updateBid(bid: _myBid!);
      }
    } catch (e) {
      print("Error submit bid: $e");
    }

    _loadBids(); // Muat ulang untuk kalkulasi ulang bid terbesar
  }

  void _hapusBid() async {
    if (_myBid == null) return;

    setState(() {
      _isLoadingBids = true;
    });

    try {
      await BidBloc.deleteBid(id: _myBid!.id!);
    } catch (e) {
      print("Error delete bid: $e");
    }

    _loadBids(); // Muat ulang data agar bid terbesar turun ke penawar di bawahnya
  }

  // Helper untuk menampilkan pesan validasi
  void _showWarningSnackBar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: Colors.redAccent,
        behavior: SnackBarBehavior.floating,
      ),
    );
  }

  void _loadBids() async {
    _currentUserId = widget.userId;
    try {
      _bids = await BidBloc.getBidsByProduk(widget.produk!.id!);

      if (_bids.isNotEmpty) {
        Bid highestBid = _bids.reduce(
          (curr, next) =>
              (curr.bidValue ?? 0) > (next.bidValue ?? 0) ? curr : next,
        );
        _highestBidValue = highestBid.bidValue ?? 0;
      } else {
        _highestBidValue = 0; // Belum ada yang nge-bid
      }

      try {
        _myBid = _bids.firstWhere((bid) => bid.memberId == _currentUserId);
        _bidTextboxController.text = _myBid!.bidValue.toString();
      } catch (e) {
        _myBid = null;
        _bidTextboxController.clear();
      }
    } catch (e) {
      print("Gagal mengambil data bid: $e");
    }

    setState(() {
      _isLoadingBids = false;
    });
  }
}
