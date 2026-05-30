class Login {
  int? code;
  bool? status;
  String? token;
  int? userID;
  String? userEmail;

  Login({this.code, this.status, this.token, this.userEmail, this.userID});

  factory Login.fromJson(Map<String, dynamic> obj) {
    return Login(
      code: obj['code'] is int
          ? obj['code']
          : int.tryParse(obj['code'].toString()),
      status: obj['status'],
      token: obj['data']['token'],
      userID: obj['data']['user']['id'] is int
          ? obj['data']['user']['id']
          : int.tryParse(obj['data']['user']['id'].toString()),
      userEmail: obj['data']['user']['email'],
    );
  }
}
