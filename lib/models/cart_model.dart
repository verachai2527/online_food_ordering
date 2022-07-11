import 'dart:convert';

class CartModel {
  final String userID;
  final String productID;
  String cartID;
  final String name;
  final String imagePath;
  final double price;
  DateTime paymentDate;
  final int productType;
  int quantity;
  double totalPrice;
  int paymentStatus;
  CartModel({
    required this.userID,
    required this.productID,
    required this.name,
    required this.imagePath,
    required this.price,
    required this.paymentDate,
    required this.productType,
    required this.quantity,
    required this.totalPrice,
    required this.paymentStatus,
    this.cartID = '',
  });

  CartModel copyWith({
    String? userID,
    String? productID,
    String? name,
    String? imagePath,
    double? price,
    DateTime? paymentDate,
    int? productType,
    int? quantity,
    double? totalPrice,
    int? paymentStatus,
  }) {
    return CartModel(
      userID: userID ?? this.userID,
      productID: productID ?? this.productID,
      name: name ?? this.name,
      imagePath: imagePath ?? this.imagePath,
      price: price ?? this.price,
      paymentDate: paymentDate ?? this.paymentDate,
      productType: productType ?? this.productType,
      quantity: quantity ?? this.quantity,
      totalPrice: totalPrice ?? this.totalPrice,
      paymentStatus: paymentStatus ?? this.paymentStatus,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'UserID': userID,
      'ProductID': productID,
      'Name': name,
      'ImagePath': imagePath,
      'Price': price,
      'PaymentDate': paymentDate.millisecondsSinceEpoch,
      'ProductType': productType,
      'Quantity': quantity,
      'TotalPrice': totalPrice,
      'PaymentStatus': paymentStatus,
    };
  }

  factory CartModel.fromMap(Map<String, dynamic> map) {
    return CartModel(
      userID: map['UserID'] ?? '',
      productID: map['ProductID'] ?? '',
      name: map['Name'] ?? '',
      imagePath: map['ImagePath'] ?? '',
      price: map['Price']?.toDouble() ?? 0.0,
      paymentDate: DateTime.fromMillisecondsSinceEpoch(map['PaymentDate']),
      productType: map['ProductType'] ?? '',
      quantity: map['Quantity']?.toInt() ?? 0,
      totalPrice: map['TotalPrice']?.toDouble() ?? 0.0,
      paymentStatus: map['PaymentStatus']?.toInt() ?? 0,
    );
  }

  String toJson() => json.encode(toMap());

  factory CartModel.fromJson(String source) =>
      CartModel.fromMap(json.decode(source));

  @override
  String toString() {
    return 'CartModel(UserID: $userID, ProductID: $productID, Name: $name, ImagePath: $imagePath, Price: $price, PaymentDate: $paymentDate, ProductType: $productType, Quantity: $quantity, TotalPrice: $totalPrice, PaymentStatus: $paymentStatus)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is CartModel &&
        other.userID == userID &&
        other.productID == productID &&
        other.name == name &&
        other.imagePath == imagePath &&
        other.price == price &&
        other.paymentDate == paymentDate &&
        other.productType == productType &&
        other.quantity == quantity &&
        other.totalPrice == totalPrice &&
        other.paymentStatus == paymentStatus;
  }

  @override
  int get hashCode {
    return userID.hashCode ^
        productID.hashCode ^
        name.hashCode ^
        imagePath.hashCode ^
        price.hashCode ^
        paymentDate.hashCode ^
        productType.hashCode ^
        quantity.hashCode ^
        totalPrice.hashCode ^
        paymentStatus.hashCode;
  }
}
