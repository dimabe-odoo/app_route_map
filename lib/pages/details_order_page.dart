import 'dart:io';

import 'package:apk_route_map/models/product_model.dart';
import 'package:apk_route_map/models/route_map_line_model.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:getwidget/components/appbar/gf_appbar.dart';
import 'package:getwidget/components/list_tile/gf_list_tile.dart';
import 'package:getwidget/getwidget.dart';


class DetailsOrderPage extends StatefulWidget {
  final RouteMapLineModel line;

  DetailsOrderPage({Key key, this.line}) : super(key: key);

  @override
  State<StatefulWidget> createState() => DetailsOrderPageState();
}

class DetailsOrderPageState extends State<DetailsOrderPage> {
  TextEditingController observationController = new TextEditingController();

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: appBar(context, widget.line),
      body: body(context, widget.line),
    );
  }

  Widget body(BuildContext context, RouteMapLineModel line) {
    return GFCard(
      title: GFListTile(
        title: Text("Detalle Pedido"),
      ),
      content: Column(
        children: [
          productList(context, line.productToDelivery),
        ],
      ),
    );
  }

  Widget productList(BuildContext context, List<ProductModel> products) {
    return ListView.separated(
        scrollDirection: Axis.vertical,
        shrinkWrap: true,
        itemBuilder: (context, index) {
          return GFListTile(
            titleText: products[index].name,
            subtitle: Text(products[index].qty.toString()),
          );
        },
        separatorBuilder: (context, index) => Divider(),
        itemCount: products.length);
  }


  
  

  Widget appBar(BuildContext context, RouteMapLineModel line) {
    return GFAppBar(
      title: GFListTile(
        title: Text(
          line.destiny,
          style: TextStyle(color: Colors.white, fontSize: 20),
        ),
      ),
    );
  }
}
