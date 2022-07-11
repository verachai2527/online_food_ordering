class ProductTypeManagement {
  String showTypeString(int type) {
    String typeString = "";
    switch (type) {
      case 0:
        typeString = "";
        break;
      case 10:
        typeString = "Drink";
        break;
      case 20:
        typeString = "Sweet";
        break;
      case 30:
        typeString = "Food";
        break;
      default:
    }

    return typeString;
  }
}
