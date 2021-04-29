import 'dart:io';

import 'package:accordion/accordion.dart';
import 'package:adaptive_dialog/adaptive_dialog.dart';
import 'package:apk_route_map/models/route_map_line_model.dart';
import 'package:apk_route_map/models/route_map_model.dart';
import 'package:apk_route_map/pages/details_order_page.dart';
import 'package:apk_route_map/services/route_map_service.dart';
import 'package:apk_route_map/utils/utils.dart';
import 'package:async_builder/async_builder.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_absolute_path/flutter_absolute_path.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:geolocator/geolocator.dart';
import 'package:getwidget/components/accordian/gf_accordian.dart';
import 'package:getwidget/components/appbar/gf_appbar.dart';
import 'package:getwidget/components/badge/gf_icon_badge.dart';
import 'package:getwidget/components/button/gf_button.dart';
import 'package:getwidget/components/button/gf_button_bar.dart';
import 'package:getwidget/components/card/gf_card.dart';
import 'package:getwidget/components/list_tile/gf_list_tile.dart';
import 'package:getwidget/getwidget.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:http/http.dart';
import 'package:image_picker/image_picker.dart';
import 'package:map_launcher/map_launcher.dart';
import 'package:multi_image_picker/multi_image_picker.dart';
import 'package:smart_select/smart_select.dart';

import 'home_page.dart';

class DetailRouteMapPage extends StatefulWidget {
  final int routeMapId;
  final String name;

  DetailRouteMapPage({Key key, this.routeMapId, this.name}) : super(key: key);

  @override
  State<StatefulWidget> createState() => DetailRouteMapPageState();
}

class DetailRouteMapPageState extends State<DetailRouteMapPage> {
  LatLng current;
  Future<List<S2Choice<String>>> choices;
  var choice = '';
  Color blue = new Color(0xff2651a4);
  Color yellow = new Color(0xffc0b726);
  TextEditingController observationsController = TextEditingController();
  Color red = new Color(0xffa02c2b);
  Color green = new Color(0xff09831a);
  Future<RouteMapModel> routeMap;
  List<File> files;

  @override
  void initState() {
    routeMap = RouteMapService().getRouteMap(widget.routeMapId);
    choices = RouteMapService().getState();
    _getUserLocation();
    super.initState();
  }

  void _getUserLocation() async {
    var position = await GeolocatorPlatform.instance
        .getCurrentPosition(desiredAccuracy: LocationAccuracy.high);
    setState(() {
      current = LatLng(position.latitude, position.longitude);
    });
  }

  @override
  Widget build(BuildContext context) {
    routeMap = RouteMapService().getRouteMap(widget.routeMapId);
    return Scaffold(
      appBar: appbar(context, widget.name),
      body: body(context, routeMap),
    );
  }

  Widget appbar(BuildContext context, String name) {
    return GFAppBar(
      leading: GFIconButton(
          color: Color(0xff1f418b),
          icon: Icon(FontAwesomeIcons.backward),
          onPressed: () {
            setState(() {
              Navigator.of(context).pushAndRemoveUntil(
                  MaterialPageRoute(
                    builder: (context) => HomePage(),
                  ),
                  (route) => false);
            });
          }),
      title: GFListTile(
        title: Text("Detalle Hoja ${name}"),
      ),
    );
  }

  Widget body(BuildContext context, Future<RouteMapModel> model) {
    return AsyncBuilder(
      future: model,
      waiting: (context) => GFLoader(),
      builder: (context, RouteMapModel value) {
        return GFCard(
          boxFit: BoxFit.fill,
          elevation: 5.0,
          title: GFListTile(
            titleText: "Detalle de ${widget.name}",
            avatar: GFIconBadge(
              child: Icon(FontAwesomeIcons.map),
            ),
            subtitle: value.sell != null
                ? Text("Sello:  ${value.sell}")
                : Text("No tiene Sello"),
          ),
          content: list(context, value.lines, current),
        );
      },
    );
  }

  Widget list(
      BuildContext context, List<RouteMapLineModel> lines, LatLng current) {
    return Container(
      height: MediaQuery.of(context).size.height * 0.70,
      width: MediaQuery.of(context).size.width,
      child: Accordion(
        maxOpenSections: 1,
        headerTextStyle: TextStyle(
            fontSize: 15, color: Colors.white, fontWeight: FontWeight.bold),
        children: getAccordionSection(lines, current),
        flipRightIconIfOpen: true,
      ),
    );
  }

  List<AccordionSection> getAccordionSection(
      List<RouteMapLineModel> lines, LatLng current) {
    List<AccordionSection> sections = [];
    for (var line in lines) {
      print(line.state);
      sections.add(AccordionSection(
          rightIcon: line.state == 'ok'
              ? Icon(FontAwesomeIcons.check,color: Colors.white)
              : line.state == 'parcial'
              ? Icon(Icons.adjust_sharp,color: Colors.white)
              : line.state == 'to_delivered'
              ? Icon(FontAwesomeIcons.caretDown,color: Colors.white)
              : Icon(FontAwesomeIcons.times,color: Colors.white),
          flipRightIconIfOpen: line.state == 'to_delivered',
          headerBackgroundColor: line.state == 'ok'
              ? green
              : line.state == 'parcial'
                  ? yellow
                  : line.state == 'to_delivered'
                      ? blue
                      : red,
          headerBorderRadius: 20.0,
          headerText: line.destiny,
          contentBorderRadius: 20.0,
          content: GFButtonBar(
            children: <Widget>[
              GFButton(
                onPressed: () {},
                text: "Detalle",
                color: blue,
              ),
              GFButton(
                onPressed: () {},
                text: "GPS",
                color: blue,
              ),
              GFButton(
                  color: blue,
                  onPressed: () {
                    setState(() {
                      showDialog(
                        context: context,
                        builder: (context) => alertDialog(line, current),
                      );
                    });
                  },
                  text: "Finalizar")
            ],
          )));
    }
    return sections;
  }

  Widget alertDialog(RouteMapLineModel model, LatLng current) {
    return AlertDialog(
      title: Text("Seleccione el estado de la entrega"),
      content: Wrap(
        children: <Widget>[
          selectState(),
          TextFormField(
            validator: (value) {
              if(choice != 'ok' && value == ''){
                return "Debe ingresar una observacione";
              }
              return null;
            },
            maxLines: 5,
            controller: observationsController,
            decoration:
                InputDecoration.collapsed(hintText: "Ingresar Observaciones"),
          ),
          GFButton(
            icon: Icon(
              Icons.camera_alt_outlined,
              color: Colors.white,
            ),
            text: "Fotos",
            onPressed: () {
              setState(() {
                getImageFile().then((value) => files = value);
              });
            },
          )
        ],
      ),
      actions: <Widget>[
        GFButton(
            text: "Cancelar",
            onPressed: () {
              setState(() {});
            }),
        GFButton(
            text: "Confirmar",
            onPressed: () {
              setState(() {
                makeDone(model, current, observationsController.text, choice);
              });
            })
      ],
    );
  }

  Widget selectState() {
    return AsyncBuilder(
      future: choices,
      waiting: (context) => Loader(),
      builder: (context, value) {
        return SmartSelect.single(
          onChange: (value) {
            setState(() {
              choice = value.value;
            });
          },
          value: choice,
          choiceItems: value,
          title: "Seleccione el estado",
        );
      },
    );
  }

  void makeDone(RouteMapLineModel line, LatLng current, String observations,
      String state) {
    var isComplete = false;
    RouteMapService()
        .makeDone(
            line.id, current.latitude, current.longitude, state, observations)
        .then((value) {
      if (value['isCompleted']) {
        isComplete = value['isComplete'];
      }
    }).whenComplete(() => !isComplete
            ? Navigator.of(context).pushAndRemoveUntil(
                MaterialPageRoute(
                  builder: (context) => DetailRouteMapPage(
                    routeMapId: widget.routeMapId,
                    name: widget.name,
                  ),
                ),
                (route) => false)
            : Navigator.of(context).pushAndRemoveUntil(
                MaterialPageRoute(
                  builder: (context) => HomePage(),
                ),
                (route) => false));
    line.state = 'done';
  }

  Widget accordionLine(RouteMapLineModel line) {
    return Accordion(
      maxOpenSections: 1,
      flipRightIconIfOpen: line.state != 'to_delivered',
      headerTextStyle: TextStyle(
          color: line.state != 'done' ? Colors.black : Colors.white,
          fontWeight: FontWeight.bold),
      leftIcon: line.state != 'to_delivered'
          ? Icon(Icons.check)
          : Icon(Icons.arrow_drop_down),
      children: [
        AccordionSection(
          headerText: line.destiny,
          content: buttonActions(line),
        )
      ],
    );
  }

  Widget buttonActions(RouteMapLineModel line) {
    return GFButtonBar(
      children: <Widget>[
        GFButton(
          text: "GPS",
          onPressed: () {},
        )
      ],
    );
  }

  Future<List<File>> getImageFile() async {
    var resultList =
        await MultiImagePicker.pickImages(enableCamera: true, maxImages: 500);
    List<File> listFiles = [];
    for (var result in resultList) {
      var path = await FlutterAbsolutePath.getAbsolutePath(result.identifier);
      listFiles.add(File(path));
    }
    return listFiles;
  }

  void showMap(LatLng current, LatLng destiny) async {
    final availableMaps = await MapLauncher.installedMaps;
    availableMaps.first.showDirections(
        destination: Coords(destiny.latitude, destiny.longitude),
        directionsMode: DirectionsMode.driving);
  }
}
