import 'package:flutter/material.dart';
import 'package:tokokita/bloc/login_bloc.dart';
import 'package:tokokita/helpers/user_info.dart';
import 'package:tokokita/ui/produk_page.dart';
import 'package:tokokita/ui/registrasi_page.dart';
import 'package:tokokita/ui/widget/warning_dialog.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({Key? key}) : super(key: key);

  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _formKey = GlobalKey<FormState>();
  bool _isLoading = false;

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
              Expanded(flex: 1, child: _formLogin()),
            ],
          ),
        ),
      ),
    );
  }

  // form login
  Widget _formLogin() {
    return Center(
      child: Transform.translate(
        offset: Offset(0, -50),
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(30.0),
            child: Form(
              key: _formKey,
              child: ConstrainedBox(
                constraints: BoxConstraints(maxWidth: 300),
                child: Column(
                  spacing: 15,
                  children: [
                    Text(
                      'Welcome',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 26,
                        color: Color(0xFF1C1C1C),
                      ),
                    ),
                    const SizedBox(height: 30),
                    _emailTextField(),
                    _passwordTextField(),
                    SizedBox(
                      width: double.infinity,
                      height: 40,
                      child: _buttonLogin(),
                    ),
                    const SizedBox(height: 10),
                    _menuRegistrasi(),
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

  //Membuat Textbox email
  Widget _emailTextField() {
    return TextFormField(
      decoration: const InputDecoration(
        labelText: "email",
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
        return null;
      },
    );
  }

  //Membuat Textbox password
  Widget _passwordTextField() {
    return TextFormField(
      decoration: const InputDecoration(
        labelText: "password",
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
        if (value!.isEmpty) {
          return "Password harus diisi";
        }
        return null;
      },
    );
  }

  //Membuat Tombol Login
  Widget _buttonLogin() {
    return ElevatedButton(
      style: ElevatedButton.styleFrom(
        backgroundColor: Color(0xFFc2652a),
        foregroundColor: Colors.white,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadiusGeometry.circular(5),
        ),
      ),
      onPressed: () {
        var validate = _formKey.currentState!.validate();
        if (validate) {
          if (!_isLoading) _submit();
        }
      },
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [Text("Login"), Icon(Icons.arrow_forward_outlined)],
      ),
    );
  }

  void _submit() {
    _formKey.currentState!.save();
    setState(() {
      _isLoading = true;
    });
    LoginBloc.login(
      email: _emailTextboxController.text,
      password: _passwordTextboxController.text,
    ).then(
      (value) async {
        await UserInfo().setToken(value.token.toString());
        await UserInfo().setUserID(int.parse(value.userID.toString()));
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => const ProdukPage()),
        );
      },
      onError: (error) {
        print(error);
        showDialog(
          context: context,
          barrierDismissible: false,
          builder: (BuildContext context) => const WarningDialog(
            description: "Login gagal, silahkan coba lagi",
          ),
        );
      },
    );
    setState(() {
      _isLoading = false;
    });
  }

  // Membuat menu untuk membuka halaman registrasi
  Widget _menuRegistrasi() {
    return Center(
      child: GestureDetector(
        child: const Text(
          "Registrasi",
          style: TextStyle(color: Color(0xFFc2652a)),
        ),
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const RegistrasiPage()),
          );
        },
      ),
    );
  }
}
