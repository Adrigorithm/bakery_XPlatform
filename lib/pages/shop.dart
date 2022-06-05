import 'dart:convert';
import 'dart:io';

import 'package:bakery_xplatform/entities/good.dart';
import 'package:bakery_xplatform/shared/widgets.dart';
import 'package:flutter/material.dart';

class ShopPage extends StatefulWidget {
  ShopPage({Key? key}) : super(key: key);

  // 'Interface', defining its corresponding builder dependencies
  final List<Good> goods = _loadGoods();
  final String goodSelected = "";

  // Initialising state machine to affect shopping list appearance on changes
  @override
  State<ShopPage> createState() => _ShopPageState();

  static List<Good> _loadGoods() {
    return Goods.fromJson(
            jsonDecode(File("testdata/goods.json").readAsStringSync()))
        .goods;
  }
}

class _ShopPageState extends State<ShopPage> {
  String filter = "";
  List<Good> goodsFilterred = List.empty();

  void _applyFilter(String goodSelection) {
    setState(() {
      filter = goodSelection;
    });
  }

  @override
  Widget build(BuildContext context) {
    // This method builds the page layout

    goodsFilterred = widget.goods
        .where((good) => good.name.toLowerCase().contains(filter))
        .toList();

    return Scaffold(
        appBar: SharedWidgets().appBar,
        body: Column(
          children: [
            Autocomplete<Good>(
              optionsBuilder: (textEditingValue) {
                if (textEditingValue.text.isEmpty) {
                  return const Iterable<Good>.empty();
                }
                return widget.goods.where((good) => good.name
                    .toLowerCase()
                    .contains(textEditingValue.text.trim().toLowerCase()));
              },
              displayStringForOption: (Good good) => good.name,
              initialValue: TextEditingValue(text: filter),
              onSelected: (Good goodSelection) {
                _applyFilter(goodSelection.name);
              },
            ),
            Expanded(
                child: CustomScrollView(slivers: [
              SliverList(
                delegate: SliverChildBuilderDelegate(
                  (context, index) {
                    return _getGoodsWidget(goodsFilterred[index]);
                  },
                  childCount: goodsFilterred.length,
                ),
              )
            ])),
          ],
        ) // This trailing comma makes auto-formatting nicer for build methods.
        );
  }

  Widget _getGoodsWidget(Good good) {
    return Column(children: [
      Text(good.name),
      Image.file(File(good.imageUri), height: 300),
      Text(good.price.toString())
    ]);
  }
}
