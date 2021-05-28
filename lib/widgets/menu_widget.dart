import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:getwidget/components/avatar/gf_avatar.dart';

class MenuWidget extends StatelessWidget {
  final Function(String) onItemClick;
  final String name;

  const MenuWidget({Key key, this.onItemClick, this.name = ''})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    var colors = const Color(0xff1f418b);
    return Container(
      color: colors,
      padding: const EdgeInsets.only(top: 30),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          SizedBox(
            height: 30,
          ),
          GFAvatar(
            radius: 65,
            backgroundColor: Colors.grey,
            child: GFAvatar(
              radius: 60,
              backgroundImage: AssetImage('assets/img/truck.png'),
            ),
          ),
          SizedBox(
            height: 20,
          ),
          Text(
            name,
            style: TextStyle(
              color: Colors.black,
              fontWeight: FontWeight.bold,
              fontSize: 30,
            ),
          ),
          SizedBox(
            height: 20,
          ),
          sliderItem("Cerrar Sesion", FontAwesomeIcons.signOutAlt),
          sliderItem("Cambiar Contraseña",FontAwesomeIcons.userLock)
        ],
      ),
    );
  }

  Widget sliderItem(String title, IconData icons) =>
      ListTile(
        title: Text(
          title,
          style: TextStyle(
              color: Colors.black
          ),
        ),
        leading: Icon(icons, color: Colors.black),
        onTap: () {
          onItemClick(title);
        },
      );
}