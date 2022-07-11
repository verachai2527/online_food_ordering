import 'dart:convert';

class ProductModel {
  final String name;
  final String detail;
  final String imagePath;
  final int type;
  final double price;
  final String code;
  String documentID;
  bool favoriteFlag;
  ProductModel({
    this.name = "",
    this.detail = "",
    this.imagePath = "",
    this.type = 0,
    this.price = 0.0,
    this.code = "",
    this.documentID = "",
    this.favoriteFlag = false,
  });
  void setDocumentID(String documentID) {
    this.documentID = documentID;
  }

  ProductModel copyWith({
    String? name,
    String? detail,
    String? imagePath,
    int? type,
    double? price,
    String? code,
  }) {
    return ProductModel(
      name: name ?? this.name,
      detail: detail ?? this.detail,
      imagePath: imagePath ?? this.imagePath,
      type: type ?? this.type,
      price: price ?? this.price,
      code: code ?? this.code,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'Name': name,
      'Detail': detail,
      'ImagePath': imagePath,
      'Type': type,
      'price': price,
      'code': code,
    };
  }

  factory ProductModel.fromMap(Map<String, dynamic>? map) {
    return ProductModel(
      name: map!['Name'] ?? '',
      detail: map['Detail'] ?? '',
      code: map['code'] ?? '',
      imagePath: map['ImagePath'] ?? '',
      type: map['Type']?.toInt() ?? 0,
      price: map['price']?.toDouble() ?? 0.0,
    );
  }

  String toJson() => json.encode(toMap());

  factory ProductModel.fromJson(String source) =>
      ProductModel.fromMap(json.decode(source));

  @override
  String toString() {
    return 'ProductModel(name: $name, detail: $detail, imagePath: $imagePath, type: $type, price: $price, code: $code)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is ProductModel &&
        other.name == name &&
        other.detail == detail &&
        other.imagePath == imagePath &&
        other.type == type &&
        other.price == price &&
        other.code == code;
  }

  @override
  int get hashCode {
    return name.hashCode ^
        detail.hashCode ^
        imagePath.hashCode ^
        type.hashCode ^
        price.hashCode ^
        code.hashCode;
  }
}
