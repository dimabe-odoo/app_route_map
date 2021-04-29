

import 'package:apk_route_map/models/product_model.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class RouteMapLineModel{

  RouteMapLineModel({
    this.id,
    this.destiny = '',
    this.address = '',
    this.isDelivered = false,
    this.state = '',
    this.observationsCompany = '',
    this.observationsDriver = '',
    this.destinyGPS = const LatLng(0.0,0.0),
    this.productToDelivery = const []
});

  int id;
  bool isDelivered;
  String destiny;
  String address;
  String state;
  String observationsDriver;
  String observationsCompany;
  LatLng destinyGPS;
  List<ProductModel> productToDelivery;
}