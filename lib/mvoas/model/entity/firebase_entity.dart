import 'package:flutter/material.dart';
import 'package:zavrsnirad/logger/logger.dart';

class ItemE {
  final String itemName;

  const ItemE({
    @required this.itemName,
  });
}

class ItemsE {
  final List<String> items;

  const ItemsE({
    @required this.items,
  });

  factory ItemsE.fromMap(map) {
    var itemMap = map['items'];
    logger.info(itemMap);
    List<String> _items = List();

    itemMap.keys.forEach((itemName) {
      _items.add(itemName);
    });
    return ItemsE(items: _items);
  }
}
