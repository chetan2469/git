class OrderDataType {
  int id;
  String name;
  int price,price1,price2,price3;
  String product,product1,product2,product3;
  int quantity,quantity1,quantity2,quantity3;
  String unit,unit1,unit2,unit3;

  OrderDataType({this.quantity1,this.quantity2,this.quantity3,this.unit,this.unit1,this.unit2,this.unit3,this.id,this.name,this.price,this.quantity,this.product,this.price1,this.price2,this.price3,this.product1,this.product2,this.product3});

  OrderDataType.fromMap(Map<String, dynamic> map) {
    id = map['id'];
    name = map['name'];
    price = map['price'];
    price1 = map['price1'];
    price2 = map['price2'];
    price3 = map['price3'];
    product = map['product'];
    product1 = map['product1'];
    product2 = map['product2'];
    product3 = map['product3'];
    quantity = map['quantity'];
    quantity1 = map['quantity1'];
    quantity2 = map['quantity2'];
    quantity3 = map['quantity3'];
  }
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'price': price,
      'price1': price1,
      'price2': price2,
      'price3': price3,
      'product':product,
      'product1':product1,
      'product2':product2,
      'product3':product3,
      'quantity':quantity,
      'quantity1':quantity1,
      'quantity2':quantity2,
      'quantity3':quantity3,
    };
  }
}
