class Side{
  int? id;
  String? name;
  int? price;
  int? quantity;

  Side({this.name, this.price, this.quantity});
  Side.fromJson(Map<dynamic, dynamic> json){
    name = json["name"];
    price = json["price"];
    quantity = json["quantity"];
  }

  Map<String, dynamic> toJson(){
    return {
      "name": name,
      "price": price,
      "quantity": quantity,
    };
  }
}