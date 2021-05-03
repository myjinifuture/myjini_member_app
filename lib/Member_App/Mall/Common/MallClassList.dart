class MallAPIClass {
  String message;
  String success;
  List data = [];

  MallAPIClass({this.message, this.success, this.data});

  factory MallAPIClass.fromJson(Map<String, dynamic> json) {
    return MallAPIClass(
        message: json['Message'] as String,
        success: json['IsSuccess'] as String,
        data: json['Data'] as List);
  }
}

class AddToCartClass {
  String productId;
  AddToCartClass(this.productId);

  Map<String, dynamic> toMap() {
    var map = <String, dynamic>{
      'productId': productId,
    };
    return map;
  }

  AddToCartClass.fromMap(Map<String, dynamic> map) {
    productId = map['productId'];
  }
}
