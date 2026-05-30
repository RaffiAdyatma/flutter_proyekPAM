import 'package:flutter/material.dart';
import 'package:tokokita/bloc/registrasi_bloc.dart';
import 'package:tokokita/ui/widget/success_dialog.dart';
import 'package:tokokita/ui/widget/warning_dialog.dart';

class RegistrasiPage extends StatefulWidget {
  const RegistrasiPage({super.key});

  @override
  _RegistrasiPageState createState() => _RegistrasiPageState();
}

class _RegistrasiPageState extends State<RegistrasiPage> {
  final _formKey = GlobalKey<FormState>();
  bool _isLoading = false;

  final _namaTextboxController = TextEditingController();
  final _emailTextboxController = TextEditingController();
  final _passwordTextboxController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFFfaf5ee),
      body: Padding(
        padding: const EdgeInsets.all(40.0),
        child: Container(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(25),
          ),
          child: Row(
            children: [
              if (MediaQuery.widthOf(context) > 800)
                Expanded(flex: 1, child: _banner()),

              Expanded(child: _formRegistrasi()),
            ],
          ),
        ),
      ),
    );
  }

  Widget _formRegistrasi() {
    return Center(
      child: Transform.translate(
        offset: Offset(0, -50),
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Form(
              key: _formKey,
              child: ConstrainedBox(
                constraints: BoxConstraints(maxWidth: 300),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  spacing: 10,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      "Registrasi",
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 26,
                        color: Color(0xFF1C1C1C),
                      ),
                    ),
                    const SizedBox(height: 20),
                    _namaTextField(),
                    _emailTextField(),
                    _passwordTextField(),
                    _passwordKonfirmasiTextField(),
                    _buttonRegistrasi(),
                    _menuLogin(),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  // banner di kiri
  Widget _banner() {
    return Center(
      child: ConstrainedBox(
        constraints: BoxConstraints(maxWidth: 300),
        child: Image.asset('assets/logo.png'),
      ),
    );
  }

  //Membuat Textbox Nama
  Widget _namaTextField() {
    return TextFormField(
      decoration: const InputDecoration(
        labelText: "Nama",
        floatingLabelBehavior: FloatingLabelBehavior.always,
        hintText: "User Ruse",
        filled: true,
        fillColor: Color(0xFFFAF5EE),
        prefixIcon: Icon(Icons.person_outline),
        border: OutlineInputBorder(),
      ),
      keyboardType: TextInputType.text,
      controller: _namaTextboxController,
      validator: (value) {
        if (value!.length < 3) {
          return "Nama harus diisi minimal 3 karakter";
        }
        return null;
      },
    );
  }

  //Membuat Textbox email
  Widget _emailTextField() {
    return TextFormField(
      decoration: const InputDecoration(
        labelText: "Email",
        floatingLabelBehavior: FloatingLabelBehavior.always,
        hintText: "nama@email.com",
        filled: true,
        fillColor: Color(0xFFFAF5EE),
        prefixIcon: Icon(Icons.mail_outline),
        border: OutlineInputBorder(),
      ),
      keyboardType: TextInputType.emailAddress,
      controller: _emailTextboxController,
      validator: (value) {
        //validasi harus diisi
        if (value!.isEmpty) {
          return 'Email harus diisi';
        }
        //validasi email
        Pattern pattern =
            r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zAZ]{2,}))$';
        RegExp regex = RegExp(pattern.toString());
        if (!regex.hasMatch(value)) {
          return "Email tidak valid";
        }
        return null;
      },
    );
  }

  //Membuat Textbox password
  Widget _passwordTextField() {
    return TextFormField(
      decoration: const InputDecoration(
        labelText: "Password",
        floatingLabelBehavior: FloatingLabelBehavior.always,
        hintText: "••••••••",
        filled: true,
        fillColor: Color(0xFFFAF5EE),
        prefixIcon: Icon(Icons.lock_outline),
        border: OutlineInputBorder(),
      ),
      keyboardType: TextInputType.text,
      obscureText: true,
      controller: _passwordTextboxController,
      validator: (value) {
        //jika karakter yang dimasukkan kurang dari 6 karakter
        if (value!.length < 6) {
          return "Password harus diisi minimal 6 karakter";
        }
        return null;
      },
    );
  }

  //membuat textbox Konfirmasi Password
  Widget _passwordKonfirmasiTextField() {
    return TextFormField(
      decoration: const InputDecoration(
        labelText: "Konfirmasi Password",
        floatingLabelBehavior: FloatingLabelBehavior.always,
        hintText: "••••••••",
        filled: true,
        fillColor: Color(0xFFFAF5EE),
        prefixIcon: Icon(Icons.lock_reset_outlined),
        border: OutlineInputBorder(),
      ),
      keyboardType: TextInputType.text,
      obscureText: true,
      validator: (value) {
        //jika inputan tidak sama dengan password
        if (value != _passwordTextboxController.text) {
          return "Konfirmasi Password tidak sama";
        }
        return null;
      },
    );
  }

  //Membuat Tombol Registrasi
  Widget _buttonRegistrasi() {
    return ElevatedButton(
      style: ElevatedButton.styleFrom(
        backgroundColor: Color(0xFFc2652a),
        foregroundColor: Colors.white,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadiusGeometry.circular(5),
        ),
      ),
      child: ConstrainedBox(
        constraints: BoxConstraints(maxWidth: 200),
        child: const SizedBox(
          width: double.infinity,
          height: 40,
          child: Align(
            alignment: Alignment.center,
            child: Text(
              "Registrasi",
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 18),
            ),
          ),
        ),
      ),
      onPressed: () {
        var validate = _formKey.currentState!.validate();
        if (validate) {
          if (!_isLoading) _submit();
        }
      },
    );
  }

  void _submit() {
    _formKey.currentState!.save();
    setState(() {
      _isLoading = true;
    });
    RegistrasiBloc.registrasi(
      nama: _namaTextboxController.text,
      email: _emailTextboxController.text,
      password: _passwordTextboxController.text,
    ).then(
      (value) {
        showDialog(
          context: context,
          barrierDismissible: false,
          builder: (BuildContext context) => SuccessDialog(
            description: "Registrasi berhasil, silahkan login",
            okClick: () {
              Navigator.pop(context);
            },
          ),
        );
      },
      onError: (error) {
        showDialog(
          context: context,
          barrierDismissible: false,
          builder: (BuildContext context) => const WarningDialog(
            description: "Registrasi gagal, silahkan coba lagi",
          ),
        );
      },
    );
    setState(() {
      _isLoading = false;
    });
  }

  Widget _menuLogin() {
    return Center(
      child: GestureDetector(
        child: const Text(
          "Kembali ke Halaman Login",
          style: TextStyle(color: Color(0xFFc2652a)),
        ),
        onTap: () {
          Navigator.pop(context);
        },
      ),
    );
  }
}
