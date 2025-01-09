class UserModel {
  String? bAddress;
  String? hAddress;
  String? mallAddress;
  String? name;
  String? image;

  UserModel({this.bAddress, this.hAddress, this.name, this.mallAddress,this.image});

  UserModel.fromJson(Map<String, dynamic> json) {
    bAddress = json['business_address'];
    hAddress = json['home_address'];
    mallAddress = json['shopping_address'];
    name = json['name'];
    image = json['image'];
  }
}
