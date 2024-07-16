import 'dart:convert';

//removed final in front img,name etc for editsweet.dart
class Sweet {
  final String id;
  String image;
  String name;
  double price;
  bool avalibility;

  Sweet({
    required this.id,
    required this.image,
    required this.name,
    required this.price,
    required this.avalibility,
  });

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'id': id,
      'image': image,
      'name': name,
      'price': price,
      'avalibility': avalibility,
    };
  }

  factory Sweet.fromMap(Map<String, dynamic> map) {
    return Sweet(
      id: map['id'] as String,

      // image: base64Decode(['image'] as String), this was here before i have added map infront of it to make it as a decodable string

      image: map['image'],
      name: map['name'] as String,
      price: map['price'] as double,
      avalibility: map['avalibility'] as bool,
    );
  }

  String toJson() => json.encode(toMap());

  factory Sweet.fromJson(String source) =>
      Sweet.fromMap(json.decode(source) as Map<String, dynamic>);
}
