import 'package:apk_route_map/models/route_map_line_model.dart';

class RouteMapModel {

  RouteMapModel({
    this.id,
    this.sell = '',
    this.lines = const [],
    this.state = '',
    this.name = '',
    this.type = ''
});

  int id;
  String name;
  String sell;
  List<RouteMapLineModel> lines;
  String state;
  String type;

}