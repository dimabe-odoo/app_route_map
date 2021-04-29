import 'package:apk_route_map/models/route_map_line_model.dart';
import 'package:apk_route_map/models/route_map_model.dart';
import 'package:apk_route_map/pages/details_order_page.dart';
import 'package:apk_route_map/preferences/user_preferences.dart';
import 'package:apk_route_map/services/route_map_service.dart';
import 'package:async_builder/async_builder.dart';
import 'package:expand_widget/expand_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:flutter_swiper/flutter_swiper.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:getwidget/components/appbar/gf_appbar.dart';
import 'package:getwidget/components/badge/gf_icon_badge.dart';
import 'package:getwidget/components/button/gf_button.dart';
import 'package:getwidget/components/button/gf_button_bar.dart';
import 'package:getwidget/components/button/gf_icon_button.dart';
import 'package:getwidget/components/card/gf_card.dart';
import 'package:getwidget/components/list_tile/gf_list_tile.dart';
import 'package:getwidget/components/loader/gf_loader.dart';
import 'package:getwidget/getwidget.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:infinite_listview/infinite_listview.dart';
import 'package:location/location.dart';
import 'package:map_launcher/map_launcher.dart';

import 'detail_route_map_page.dart';
import 'login_page.dart';

class HomePage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => HomePageState();
}

class HomePageState extends State<HomePage> {
  final _prefs = new UserPreference();
  Future<List<RouteMapModel>> routes;

  @override
  void initState() {
    routes = RouteMapService().getRouteMaps();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    routes = RouteMapService().getRouteMaps();
    return Scaffold(appBar: appBar(context), body: body(context, routes));
  }

  Widget body(BuildContext context, Future<List<RouteMapModel>> route) {
    return AsyncBuilder(
      future: route,
      waiting: (context) => GFLoader(),
      error: (context, error, stackTrace) => Center(
        child: Text("No tiene hojas de ruta activas"),
      ),
      builder: (context, List<RouteMapModel> value) {
        return list(context, value);
      },
    );
  }

  Widget list(BuildContext context, List<RouteMapModel> route) {
    return ListView.separated(
        itemBuilder: (context, index) {
          return GFAccordion(
            title: route[index].name,
            contentChild: ButtonBar(
              alignment: MainAxisAlignment.center,
              children: <Widget>[
                GFButton(
                  onPressed: () {
                    setState(() {
                      Navigator.pushAndRemoveUntil(
                          context,
                          MaterialPageRoute(
                            builder: (context) => DetailRouteMapPage(
                              routeMapId: route[index].id,
                              name: route[index].name,
                            ),
                          ),
                          (route) => false);
                    });
                  },
                  child: Text("Detalle"),
                  icon: Icon(FontAwesomeIcons.infoCircle),
                )
              ],
            ),
          );
        },
        separatorBuilder: (context, index) => Divider(),
        itemCount: route.length);
  }

  Widget appBar(BuildContext context) {
    return GFAppBar(
      actions: [
        GFIconButton(
            icon: Icon(FontAwesomeIcons.signOutAlt),
            onPressed: () {
              setState(() {
                _prefs.clearSession();
                Navigator.of(context).pushAndRemoveUntil(MaterialPageRoute(builder: (context) => LoginPage(),), (route) => false);
              });
            })
      ],
      title: GFListTile(
        title: Text(
          "Bienvenido ${_prefs.name}",
        ),
      ),
    );
  }

}