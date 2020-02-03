class ItemDataType{
  int id;
  String name;
  int price;

  ItemDataType({this.id,this.name,this.price});

  ItemDataType.fromMap(Map<String, dynamic> map) {
    id = map['id'];
    name = map['name'];
    price = map['price'];
  }
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'price': price,
    };
  }
}