import 'package:agenda_esp_on/utils/prefs.dart';
import 'dart:convert' as convert;

class User {
  String email = '';
  String senha = '';
  String token = '';

  User({required this.email, required this.senha, required this.token});

  User.fromJson(Map<String, dynamic> json) {
    email = json['email'];
    senha = json['senha'];
    token = json['token'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['email'] = this.email;
    data['senha'] = this.senha;
    data['token'] = this.token;
    return data;
  }

  static void clear(){
    Prefs.setString("user.prefs", "");
  }

  void save() {
    Map map = toJson();
    String json = convert.json.encode(map);
    Prefs.setString("user.prefs", json);
  }

  static Future<User?> get() async {
    String json = await Prefs.getString("user.prefs");
    if(json.isEmpty) {
      return null;
    }
    Map<String, String> map = convert.json.decode(json);
    User user = User.fromJson(map);
    return user;
  }

  @override
  String toString() {
    return 'User{email: $email, senha: $senha, token: $token}';
  }
}