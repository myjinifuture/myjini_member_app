class SaveDataClass {
  String Message;
  bool IsSuccess;
  String Data;
  List Content;

  SaveDataClass({this.Message, this.IsSuccess, this.Data, this.Content});

  factory SaveDataClass.fromJson(Map<String, dynamic> json) {
    return SaveDataClass(
      Message: json['Message'] as String,
      IsSuccess: json['IsSuccess'] as bool,
      Data: json['Data'] as String,
      Content: json['Data'] as List,
    );
  }
}