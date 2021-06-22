import 'dart:convert';
import 'dart:io';

import 'package:apk_route_map/models/product_model.dart';
import 'package:apk_route_map/models/route_map_line_model.dart';
import 'package:apk_route_map/models/route_map_model.dart';
import 'package:apk_route_map/preferences/user_preferences.dart';
import 'package:apk_route_map/services/base_service.dart';
import 'package:flutter/services.dart';

import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:http/http.dart' as http;
import 'package:dio/dio.dart';
import 'package:image_picker/image_picker.dart';
import 'package:smart_select/smart_select.dart';

class RouteMapService extends BaseService {
  final _prefs = new UserPreference();

  Future<List<RouteMapModel>> getRouteMaps() async {
    final endpoint = Uri.parse('${url}/api/route_maps');
    final data = {
      "params": {"driver_id": _prefs.driver}
    };
    final resp = await http.post(endpoint,
        headers: {
          'content-type': "Application/json",
          'Authorization': "Bearer ${_prefs.token}"
        },
        body: json.encode(data));
    if (isSuccessCode(resp.statusCode)) {
      List<RouteMapModel> routes = [];
      var decodedResponse = <String, dynamic>{};
      decodedResponse = json.decode(resp.body);
      if (decodedResponse.containsKey('result')) {
        for (var item in decodedResponse['result']) {
          routes.add(RouteMapModel(
              id: item['id'], name: item['display_name'], type: item['type_of_map']));
        }
        return routes;
      }
    }
  }

  Future<RouteMapModel> getRouteMap(int Id) async {
    final endpoint = Uri.parse('${url}/api/route_map');
    final data = {
      'params': {'map_id': Id}
    };
    final resp = await http.post(endpoint,
        headers: {
          'content-type': 'Application/json',
          'Authorization': 'Bearer ${_prefs.token}'
        },
        body: json.encode(data));
    if (isSuccessCode(resp.statusCode)) {
      var decodedResponse = <String, dynamic>{};
      decodedResponse = json.decode(resp.body);
      if (decodedResponse.containsKey('result')) {
        RouteMapModel model = new RouteMapModel();
        model.name = decodedResponse['result']['display_name'];
        model.sell = decodedResponse['result']['sell'] != false ? decodedResponse['result']['sell'] : '';
        model.lines = getRouteMapLineModel(decodedResponse['result']['dispatch_ids']);
        return model;
      }
    }
  }

  String fileToBase64(File file) {
    List<int> imageBytes = file.readAsBytesSync();
    String base64image = base64Encode(imageBytes);
    return base64image;
  }

  List<RouteMapLineModel> getRouteMapLineModel(dynamic lines) {
    List<RouteMapLineModel> list = [];
    for (var map in lines) {
    var destinyGps = LatLng(map[0]['partner_latitude'], map[0]['partner_longitude']);
    print(map);
    list.add(RouteMapLineModel(
           id: map[0]['id'],
           destiny: map[0]['partner_id'][1],
           state: map[0]['state'],
           destinyGPS: destinyGps,
           address: map[0]['address_to_delivery'] != false ? map[0]['address_to_delivery'] : '',type: map[0]['picking_code']));
     }
    return list;
  }

  List<ProductModel> getProductModel(dynamic products) {
    List<ProductModel> list = [];
    for (var product in products) {
      list.add(ProductModel(name: product['ProductName'], qty: product['Qty']));
    }
    return list;
  }

  Future<Map<String, dynamic>> makeDone(
      int lineId,
      dynamic latitude,
      dynamic longitude,
      String state,
      String observations,
      List<String> files) async {
    final endpoint = Uri.parse("${url}/api/done");
    List<String> fileB64 = getListBase64(files);
    final data = {
      "params": {
        "line_id": lineId,
        'latitude': latitude,
        'longitude': longitude,
        'state': state,
        'observations': observations,
        'files': fileB64.length > 0 ? fileB64 : [],
      }
    };
    final resp = await http.post(endpoint,
        headers: {
          'content-type': 'Application/json',
          'Authorization': 'Bearer ' + _prefs.token
        },
        body: json.encode(data));
    var decodedResponse = <String, dynamic>{};
    var resultResponse = <String, dynamic>{};
    decodedResponse = json.decode(resp.body);
    resultResponse = decodedResponse['result'];
    if (resultResponse.keys.contains('is_Completed')) {
      return {
        'ok': true,
        'isCompleted': true,
        'message': resultResponse['message']
      };
    } else {
      return {
        'ok': true,
        'isCompleted': false,
        'message': resultResponse['message']
      };
    }
  }

  Future<List<S2Choice<String>>> getState() async {
    final endpoint = Uri.parse('${url}/api/states');
    final params = {};
    final resp = await http.post(endpoint,
        headers: {
          "content-type": 'Application/json',
          'Authorization': "Bearer " + _prefs.token
        },
        body: json.encode(params));
    if (isSuccessCode(resp.statusCode)) {
      List<S2Choice<String>> choices = [];
      var decodedResponse = <String, dynamic>{};
      decodedResponse = json.decode(resp.body);
      if (decodedResponse.containsKey('result')) {
        for (var dec in decodedResponse['result']) {
          choices.add(S2Choice(value: dec['value'], title: dec['name']));
        }
        return choices;
      }
    }
  }

  List<String> getListBase64(List<String> filesPath) {
    if (filesPath != null || filesPath.length != 0) {
      List<String> listBase64 = [];
      for (var file in filesPath) {
        var fileObject = File(file);
        listBase64.add(fileToBase64(fileObject));
      }
      return listBase64;
    }
    return [];
  }
}
