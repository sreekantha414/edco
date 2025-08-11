class FavoriteListModel {
  FavoriteListModel({this.statusCode, this.message, this.success, this.result});

  FavoriteListModel.fromJson(dynamic json) {
    statusCode = json['statusCode'];
    message = json['message'];
    success = json['success'];
    result = json['result'] != null ? Result.fromJson(json['result']) : null;
  }
  int? statusCode;
  String? message;
  bool? success;
  Result? result;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['statusCode'] = statusCode;
    map['message'] = message;
    map['success'] = success;
    if (result != null) {
      map['result'] = result?.toJson();
    }
    return map;
  }
}

class Result {
  Result({this.totalRecords, this.data, this.nextPageExists, this.nextPage});

  Result.fromJson(dynamic json) {
    totalRecords = json['totalRecords'];
    if (json['data'] != null) {
      data = [];
      json['data'].forEach((v) {
        data?.add(FavoriteList.fromJson(v));
      });
    }
    nextPageExists = json['nextPageExists'];
    nextPage = json['nextPage'];
  }
  int? totalRecords;
  List<FavoriteList>? data;
  bool? nextPageExists;
  int? nextPage;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['totalRecords'] = totalRecords;
    if (data != null) {
      map['data'] = data?.map((v) => v.toJson()).toList();
    }
    map['nextPageExists'] = nextPageExists;
    map['nextPage'] = nextPage;
    return map;
  }
}

class FavoriteList {
  FavoriteList({this.id, this.imageName, this.imageUrl, this.favouriteCreatedAt, this.favourite});

  FavoriteList.fromJson(dynamic json) {
    id = json['_id'];
    imageName = json['imageName'];
    imageUrl = json['imageUrl'];
    favouriteCreatedAt = json['favouriteCreatedAt'] != null ? json['favouriteCreatedAt'].cast<String>() : [];
    favourite = json['favourite'];
  }
  String? id;
  String? imageName;
  String? imageUrl;
  List<String>? favouriteCreatedAt;
  bool? favourite;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['_id'] = id;
    map['imageName'] = imageName;
    map['imageUrl'] = imageUrl;
    map['favouriteCreatedAt'] = favouriteCreatedAt;
    map['favourite'] = favourite;
    return map;
  }
}
