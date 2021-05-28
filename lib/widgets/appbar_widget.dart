import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_slider_drawer/flutter_slider_drawer.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:getwidget/components/appbar/gf_appbar.dart';
import 'package:getwidget/components/avatar/gf_avatar.dart';
import 'package:getwidget/components/button/gf_button.dart';
import 'package:getwidget/components/drawer/gf_drawer.dart';
import 'package:getwidget/components/drawer/gf_drawer_header.dart';
import 'package:getwidget/components/list_tile/gf_list_tile.dart';

import 'menu_widget.dart';

class AppbarWidget extends StatelessWidget {
  final String name;

  const AppbarWidget({Key key, this.name}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GFAppBar(
      title: GFListTile(
        title: Text("Bienvenido $name"),
      ),
    );
  }
}
