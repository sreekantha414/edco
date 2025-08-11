class AwardDetailModel {
  AwardDetailModel({this.statusCode, this.message, this.success, this.result});

  AwardDetailModel.fromJson(dynamic json) {
    statusCode = json['statusCode'];
    message = json['message'];
    success = json['success'];
    if (json['result'] != null) {
      result = [];
      json['result'].forEach((v) {
        result?.add(Result.fromJson(v));
      });
    }
  }
  int? statusCode;
  String? message;
  bool? success;
  List<Result>? result;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['statusCode'] = statusCode;
    map['message'] = message;
    map['success'] = success;
    if (result != null) {
      map['result'] = result?.map((v) => v.toJson()).toList();
    }
    return map;
  }
}

class Result {
  Result({this.id, this.viewCount, this.imageName, this.imageDescription, this.imageUrl, this.webUrl, this.createdAt, this.favourite});

  Result.fromJson(dynamic json) {
    id = json['_id'];
    viewCount = json['viewCount'];
    imageName = json['imageName'];
    imageDescription = json['imageDescription'];
    imageUrl = json['imageUrl'];
    webUrl = json['webUrl'];
    createdAt = json['createdAt'];
    favourite = json['favourite'];
  }
  String? id;
  int? viewCount;
  String? imageName;
  String? imageDescription;
  String? imageUrl;
  String? webUrl;
  String? createdAt;
  bool? favourite;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['_id'] = id;
    map['viewCount'] = viewCount;
    map['imageName'] = imageName;
    map['imageDescription'] = imageDescription;
    map['imageUrl'] = imageUrl;
    map['webUrl'] = webUrl;
    map['createdAt'] = createdAt;
    map['favourite'] = favourite;
    return map;
  }
}
