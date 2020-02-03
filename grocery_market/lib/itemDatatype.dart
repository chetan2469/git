class ItemDataType {
  String itemName,itemrice,itemUnite,itemQuantity;


  ItemDataType({this.itemUnite,this.itemName,this.itemQuantity,this.itemrice});

  ItemDataType.fromMap(Map<String, dynamic> map) {
    itemName = map['itemName'];
    itemQuantity = map['itemQuanity'];
    itemrice =map['itemrice'];
    itemUnite = map['itemUnite'];
  }
  Map<String, dynamic> toMap() {
    return {
      'itemName':itemName,
      'itemQuantity':itemQuantity,
      'itemrice':itemrice,
      'itemUnite':itemUnite
    };
  }
}
