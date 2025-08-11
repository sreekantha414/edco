class EditProfileModel {
  int? statusCode;
  String? message;
  bool? success;
  dynamic? result;

  EditProfileModel({this.statusCode, this.message, this.success, this.result});

  factory EditProfileModel.fromJson(Map<String, dynamic> json) {
    return EditProfileModel(
      statusCode: json['statusCode'] as int?,
      message: json['message'] as String?,
      success: json['success'] as bool?,
      result: json['result'] as dynamic?,
    );
  }

  Map<String, dynamic> toJson() {
    return {'statusCode': statusCode, 'message': message, 'success': success, if (result != null) 'result': result!.toJson()};
  }
}
