class ProductSize{
  String? name;
  int? quantity;

  ProductSize({this.name, this.quantity});
  ProductSize.fromJson(Map<String, dynamic> json){
    name = json["name"];
    quantity = json["quantity"];
  }

  Map<String, dynamic> toJson(){
    return {
      "name": name,
      "quantity": quantity,
    };
  }
}