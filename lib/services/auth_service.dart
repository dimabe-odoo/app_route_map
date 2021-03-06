import 'dart:convert';
import 'package:apk_route_map/preferences/user_preferences.dart';

import 'base_service.dart';
import 'package:http/http.dart' as http;

class AuthService extends BaseService {
  final _prefs = new UserPreference();

  Future<Map<String, dynamic>> login(String email, String password) async {
    final endpoint = Uri.parse("$url/api/login");
    final data = {
      'params': {'user': email, 'password': password}
    };

    final resp = await http.post(endpoint,
        headers: {'content-type': 'Application/json'}, body: json.encode(data));

    if (isSuccessCode(resp.statusCode)) {
      var decodedResponse = <String,dynamic>{};
      decodedResponse = json.decode(resp.body);
      if(decodedResponse.containsKey('result')){
        _prefs.token = decodedResponse['result']['token'];
        _prefs.name = decodedResponse['result']['name'];
        _prefs.email = decodedResponse['result']['login'];
        _prefs.driver = decodedResponse['result']['partner_id'][0];
        return {'ok': true, 'message': 'Conectado correctamente'};
      }else if(decodedResponse.containsKey('error')){
        return {'ok': false, 'message': "Credenciales inválidas"};
      }
      return {'ok': false, 'message': "Credenciales inválidas"};
    }


    Future<Map<String, dynamic>> changePassword(String email) async {
      final endpoint = Uri.parse("$url/api/reset_password");
      final data = {
        "params": {"email": email}
      };
      final resp = await http.post(endpoint,
          headers: {'content-type': 'Application/json'},
          body: json.encode(data));
      if (isSuccessCode(resp.statusCode)) {
        var decodedResponse = <String, dynamic>{};
        decodedResponse = json.decode(resp.body);
        if (decodedResponse.containsKey('result')) {
          return {'ok': true, 'message': 'Conectado correctamente'};
        }
      }
      return {'ok': false, 'message': 'Credenciales inválidas'};
    }
  }
}