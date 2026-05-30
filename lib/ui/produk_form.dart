import 'dart:io';
import 'package:image_picker/image_picker.dart';
import 'package:flutter/material.dart';
import 'package:tokokita/bloc/produk_bloc.dart';
import 'package:tokokita/model/produk.dart';
import 'package:tokokita/ui/produk_page.dart';
import 'package:tokokita/ui/widget/warning_dialog.dart';

class ProdukForm extends StatefulWidget {
  Produk? produk;

  ProdukForm({super.key, this.produk});

  @override
  _ProdukFormState createState() => _ProdukFormState();
}

class _ProdukFormState extends State<ProdukForm> {
  final _formKey = GlobalKey<FormState>();
  bool _isLoading = false;
  String judul = "TAMBAH PRODUK";
  String tombolSubmit = "SIMPAN";

  final _kodeProdukTextboxController = TextEditingController();
  final _namaProdukTextboxController = TextEditingController();
  final _hargaProdukTextboxController = TextEditingController();

  // Variabel Gambar
  File? _selectedImage;
  final ImagePicker _picker = ImagePicker();
  String? _currentImageUrl; 
  
  // URL folder penyimpanan gambar di backend API Anda
  final String urlFolderGambar = "http://localhost/toko_api/public/uploads/";

  @override
  void initState() {
    super.initState();
    isUpdate();
  }

  void isUpdate() {
    if (widget.produk != null) {
      setState(() {
        judul = "UBAH PRODUK";
        tombolSubmit = "UBAH";
        _kodeProdukTextboxController.text = widget.produk!.kodeProduk!;
        _namaProdukTextboxController.text = widget.produk!.namaProduk!;
        _hargaProdukTextboxController.text = widget.produk!.hargaProduk
            .toString();
        _currentImageUrl = widget.produk!.gambar;
      });
    } else {
      judul = "TAMBAH PRODUK";
      tombolSubmit = "SIMPAN";
    }
  }

  Future<void> _pickImage() async {
    final XFile? pickedFile = await _picker.pickImage(
      source: ImageSource.gallery,
      imageQuality: 80,
    );
    if (pickedFile != null) {
      setState(() {
        _selectedImage = File(pickedFile.path);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(judul), backgroundColor: Color(0xFFFAF5EE)),

      backgroundColor: Color(0xFFFAF5EE),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(30.0),
          child: Form(
            key: _formKey,
            child: Center(
              child: ConstrainedBox(
                constraints: BoxConstraints(maxWidth: 400),
                child: Container(
                  padding: EdgeInsets.all(40),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(15)
                    ),
                  child: Column(
                    spacing: 30,
                    children: [
                      _kodeProdukTextField(),
                      _namaProdukTextField(),
                      _hargaProdukTextField(),
                      _imagePickerField(),
                      _buttonSubmit(),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  //Membuat Textbox Kode Produk
  Widget _kodeProdukTextField() {
    return TextFormField(
      decoration: const InputDecoration(
        labelText: "Kode Produk",
        border: OutlineInputBorder(),
        fillColor: Color(0xFFFAF5EE),
        filled: true,

        enabledBorder: OutlineInputBorder(
          borderSide: BorderSide(color: Color(0xFFf2ece4))
        ),

        focusedBorder: OutlineInputBorder(
          borderSide: BorderSide(color: Color(0xFFf2ece4))
        ),

        focusColor: Color(0xFFf2ece4)
      ),
      keyboardType: TextInputType.text,
      controller: _kodeProdukTextboxController,
      validator: (value) {
        if (value!.isEmpty) {
          return "Kode Produk harus diisi";
        }
        return null;
      },
    );
  }

  //Membuat Textbox Nama Produk
  Widget _namaProdukTextField() {
    return TextFormField(
      decoration: const InputDecoration(
        labelText: "Nama Produk",
        border: OutlineInputBorder(),
        fillColor: Color(0xFFFAF5EE),
        filled: true,

        enabledBorder: OutlineInputBorder(
          borderSide: BorderSide(color: Color(0xFFf2ece4))
        ),

        focusedBorder: OutlineInputBorder(
          borderSide: BorderSide(color: Color(0xFFf2ece4))
        ),

        focusColor: Color(0xFFf2ece4)
      ),
      keyboardType: TextInputType.text,
      controller: _namaProdukTextboxController,
      validator: (value) {
        if (value!.isEmpty) {
          return "Nama Produk harus diisi";
        }
        return null;
      },
    );
  }

  //Membuat Textbox Harga Produk
  Widget _hargaProdukTextField() {
    return TextFormField(
      decoration: const InputDecoration(
        labelText: "Harga Awal",
        border: OutlineInputBorder(),
        fillColor: Color(0xFFFAF5EE),
        filled: true,

        enabledBorder: OutlineInputBorder(
          borderSide: BorderSide(color: Color(0xFFf2ece4))
        ),

        focusedBorder: OutlineInputBorder(
          borderSide: BorderSide(color: Color(0xFFf2ece4))
        ),

        focusColor: Color(0xFFf2ece4)
      ),
      
      keyboardType: TextInputType.number,
      controller: _hargaProdukTextboxController,
      validator: (value) {
        if (value!.isEmpty) {
          return "Harga harus diisi";
        }
        return null;
      },
    );
  }

  Widget _imagePickerField() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text("Gambar Produk", style: TextStyle(fontWeight: FontWeight.bold)),
        const SizedBox(height: 8),
        InkWell(
          onTap: _pickImage,
          child: Container(
            height: 160,
            width: double.infinity,
            decoration: BoxDecoration(
              color: const Color(0xFFFAF5EE),
              borderRadius: BorderRadius.circular(8),
              border: Border.all(color: const Color(0xFFf2ece4), width: 1.5),
            ),
            child: _selectedImage != null
                ? ClipRRect(
                    borderRadius: BorderRadius.circular(8),
                    child: Image.file(_selectedImage!, fit: BoxFit.cover),
                  )
                : (_currentImageUrl != null && _currentImageUrl!.isNotEmpty
                    ? ClipRRect(
                        borderRadius: BorderRadius.circular(8),
                        child: Image.network(urlFolderGambar + _currentImageUrl!, fit: BoxFit.cover),
                      )
                    : const Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(Icons.add_a_photo_outlined, size: 32, color: Color(0xFFc2652a)),
                          SizedBox(height: 8),
                          Text("Pilih Gambar Produk", style: TextStyle(color: Colors.grey, fontSize: 12)),
                        ],
                      )),
          ),
        ),
      ],
    );
  }

  //Membuat Tombol Simpan/Ubah
  Widget _buttonSubmit() {
    return OutlinedButton(
      style: OutlinedButton.styleFrom(
        backgroundColor: Color(0xFFc2652a),
        foregroundColor: Colors.white,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadiusGeometry.circular(5),
        ),
      ),

      child: Text(tombolSubmit, style: TextStyle(fontSize: 16)),

      onPressed: () {
        var validate = _formKey.currentState!.validate();
        if (validate) {
          if (!_isLoading) {
            if (widget.produk != null) {
              //kondisi update produk
              ubah();
            } else {
              //kondisi tambah produk
              simpan();
            }
          }
        }
      },
    );
  }

  void simpan() {
    setState(() {
      _isLoading = true;
    });
    Produk createProduk = Produk(id: null);
    createProduk.kodeProduk = _kodeProdukTextboxController.text;
    createProduk.namaProduk = _namaProdukTextboxController.text;
    createProduk.hargaProduk = int.parse(_hargaProdukTextboxController.text);

    ProdukBloc.addProduk(produk: createProduk, imageFile: _selectedImage).then((value) {
      Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (_) => const ProdukPage()));
    }, onError: (err) {
      showDialog(context: context, builder: (_) => const WarningDialog(description: "Simpan gagal"));
    }).whenComplete(() => setState(() => _isLoading = false));
    setState(() {
      _isLoading = false;
    });
  }

  void ubah() {
    setState(() => _isLoading = true);
    Produk updateProduk = Produk(
      id: widget.produk!.id,
      kodeProduk: _kodeProdukTextboxController.text,
      namaProduk: _namaProdukTextboxController.text,
      hargaProduk: int.parse(_hargaProdukTextboxController.text),
    );

    ProdukBloc.updateProduk(produk: updateProduk, imageFile: _selectedImage).then((value) {
      Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (_) => const ProdukPage()));
    }, onError: (err) {
      showDialog(context: context, builder: (_) => const WarningDialog(description: "Ubah data gagal"));
    }).whenComplete(() => setState(() => _isLoading = false));
  }
}
