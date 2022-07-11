import 'dart:convert';

class FavoriteModel {
  final String userID;
  final String productID;
  FavoriteModel({
    required this.userID,
    required this.productID,
  });

  FavoriteModel copyWith({
    String? userID,
    String? productID,
  }) {
    return FavoriteModel(
      userID: userID ?? this.userID,
      productID: productID ?? this.productID,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'UserID': userID,
      'ProductID': productID,
    };
  }

  factory FavoriteModel.fromMap(Map<String, dynamic> map) {
    return FavoriteModel(
      userID: map['UserID'] ?? '',
      productID: map['ProductID'] ?? '',
    );
  }

  String toJson() => json.encode(toMap());

  factory FavoriteModel.fromJson(String source) =>
      FavoriteModel.fromMap(json.decode(source));

  @override
  String toString() => 'FavoriteModel(UserID: $userID, ProductID: $productID)';

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is FavoriteModel &&
        other.userID == userID &&
        other.productID == productID;
  }

  @override
  int get hashCode => userID.hashCode ^ productID.hashCode;
}
