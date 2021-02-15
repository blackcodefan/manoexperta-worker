import 'package:flutter/foundation.dart';

class MarketConfigModel{
  bool payment;
  List<BankModel> banks;
  String callPrefix;
  bool identity;
  List<dynamic> categories;
  bool reference;
  bool package;
  String marketHandle;
  bool select;
  bool inquiries;
  String enrollAlert;
  String enrollOpen;

  MarketConfigModel.fromMap(Map data){
    payment = data['xp_payments'];
    banks = BankModel.fromList(data['xp_banklist']);
    callPrefix = data['xp_callprefix'];
    identity = data['xp_forceid'];
    categories = data['xp_categories'];
    reference = data['xp_referal'];
    package = data['xp_packs'];
    marketHandle = data['mktHandle'];
    select = data['xp_select'];
    inquiries = data['xp_inquiries'];
    enrollAlert = data['xp_enrollalert'];
    enrollOpen = data['xp_enrollopen'];
  }
}

class BankModel{
  final String name;
  final String id;
  BankModel({
    @required this.id,
    @required this.name
  }):assert(name != null && id != null);

  factory BankModel.fromJson(Map bank) => BankModel(id: bank['id'], name: bank['bank']);

  static List<BankModel> fromList(List banks){
    List<BankModel> _banks = [];
    banks.forEach((bank) {
      _banks.add(BankModel.fromJson(bank));
    });
    return _banks;
  }
}