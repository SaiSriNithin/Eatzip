// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

import 'package:sweet_shop/models/sweet_model.dart';

class SweetList {
  final List<Sweet> backendlist;

  SweetList({required this.backendlist});

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'backendlist': backendlist.map((x) => x.toMap()).toList(),
    };
  }

  factory SweetList.fromMap(Map<String, dynamic> map) {
    return SweetList(
      backendlist: List<Sweet>.from(
        (map['backendlist'] as List<int>).map<Sweet>(
          (x) => Sweet.fromMap(x as Map<String, dynamic>),
        ),
      ),
    );
  }

  String toJson() => json.encode(toMap());

  factory SweetList.fromJson(String source) =>
      SweetList.fromMap(json.decode(source) as Map<String, dynamic>);
}
