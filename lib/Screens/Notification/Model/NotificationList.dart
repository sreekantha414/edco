class NotificationList {
  NotificationList({this.statusCode, this.message, this.success, this.result});

  NotificationList.fromJson(dynamic json) {
    statusCode = json['statusCode'];
    message = json['message'];
    success = json['success'];
    result = json['result'] != null ? Notification.fromJson(json['result']) : null;
  }
  int? statusCode;
  String? message;
  bool? success;
  Notification? result;

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

class Notification {
  Notification({this.totalRecords, this.data, this.nextPageExists, this.nextPage});

  Notification.fromJson(dynamic json) {
    totalRecords = json['totalRecords'];
    if (json['data'] != null) {
      data = [];
      json['data'].forEach((v) {
        data?.add(Data.fromJson(v));
      });
    }
    nextPageExists = json['nextPageExists'];
    nextPage = json['nextPage'];
  }
  int? totalRecords;
  List<Data>? data;
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

class Data {
  Data({this.id, this.imageName, this.imageUrl, this.createdAt});

  Data.fromJson(dynamic json) {
    id = json['_id'];
    imageName = json['imageName'];
    imageUrl = json['imageUrl'];
    createdAt = json['createdAt'];
  }
  String? id;
  String? imageName;
  String? imageUrl;
  String? createdAt;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['_id'] = id;
    map['imageName'] = imageName;
    map['imageUrl'] = imageUrl;
    map['createdAt'] = createdAt;
    return map;
  }
}
