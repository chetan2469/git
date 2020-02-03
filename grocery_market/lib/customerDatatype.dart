class CustomerDataType{
  int id;
  String name;
  String address;
  int mobile;

  CustomerDataType({this.id,this.name,this.address,this.mobile});
    
    CustomerDataType.fromMap(Map<String, dynamic> map) {
    id = map['id'];
    name = map['name'];
    address = map['address'];
    mobile = map['mobile'];
  }
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'address': address,
      'mobile': mobile
    };
  }
}
