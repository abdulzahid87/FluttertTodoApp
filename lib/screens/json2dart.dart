import 'dart:convert';
void main() {
  String objText = '''{"productID": 1, "productName": "Chicken Biryani","category": "Biryanis","price": 300}''';

  Food user = Food.fromJson(jsonDecode(objText));

  print(user);
}



class Food {
  int productID;
  String productName;
  String category;
  int price;

  Food(this.productID, this.productName, this.category, this.price);

  factory Food.fromJson(dynamic json) {
    return Food(json['productID'] as int, json['productName'] as String,
        json['category'] as String, json['price'] as int);
  }

  @override
  String toString() {
    return '{ ${this.productID}, ${this.productName},${this.category}, ${this.price},}';
  }
}