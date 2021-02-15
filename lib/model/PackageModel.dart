import 'package:flutter/cupertino.dart';

class PackageModel{
  int id;
  String description;
  double price;
  bool upfront;
  int categoryId;
  String categoryName;

  PackageModel({
    this.id,
    @required this.description,
    @required this.price,
    @required this.upfront,
    @required this.categoryId,
    this.categoryName});

  PackageModel.fromMap(Map<dynamic, dynamic> map){
    id = map['packid'];
    description = map['packDescribe'];
    price = map['totalAmount'];
    upfront = map['prepaidOnly'];
    categoryId = map['catid'];
    categoryName = map['catname'];
  }

  Map toMap() => {
    "packDescribe": description,
    "catid": categoryId,
    "totalAmount": price,
    "prepaidOnly": upfront
  };
}