class AwardListModel {
  int? statusCode;
  String? message;
  bool? success;
  Result? result;

  AwardListModel({this.statusCode, this.message, this.success, this.result});

  factory AwardListModel.fromJson(Map<String, dynamic> json) {
    return AwardListModel(
      statusCode: json['statusCode'] as int?,
      message: json['message'] as String?,
      success: json['success'] as bool?,
      result: json['result'] != null ? Result.fromJson(json['result']) : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {'statusCode': statusCode, 'message': message, 'success': success, if (result != null) 'result': result!.toJson()};
  }
}

class Result {
  int? totalRecords;
  List<AwardList>? data;
  bool? nextPageExists;
  int? nextPage;

  Result({this.totalRecords, this.data, this.nextPageExists, this.nextPage});

  factory Result.fromJson(Map<String, dynamic> json) {
    return Result(
      totalRecords: json['totalRecords'] as int?,
      data: (json['data'] as List<dynamic>?)?.map((v) => AwardList.fromJson(v as Map<String, dynamic>)).toList(),
      nextPageExists: json['nextPageExists'] as bool?,
      nextPage: json['nextPage'] as int?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'totalRecords': totalRecords,
      if (data != null) 'data': data!.map((v) => v.toJson()).toList(),
      'nextPageExists': nextPageExists,
      'nextPage': nextPage,
    };
  }
}

class AwardList {
  String? id;
  int? viewCount;
  String? imageName;
  String? imageUrl;
  String? webUrl;
  String? createdAt;
  List<String>? favouriteData; // Changed to List<String>
  bool? favourite;

  AwardList({this.id, this.viewCount, this.imageName, this.imageUrl, this.webUrl, this.createdAt, this.favouriteData, this.favourite});

  factory AwardList.fromJson(Map<String, dynamic> json) {
    return AwardList(
      id: json['_id'] as String?,
      viewCount: json['viewCount'] as int?,
      imageName: json['imageName'] as String?,
      imageUrl: json['imageUrl'] as String?,
      webUrl: json['webUrl'] as String?,
      createdAt: json['createdAt'] as String?,
      favouriteData: (json['favouriteData'] as List<dynamic>?)?.map((e) => e.toString()).toList(),
      favourite: json['favourite'] as bool?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      '_id': id,
      'viewCount': viewCount,
      'imageName': imageName,
      'imageUrl': imageUrl,
      'webUrl': webUrl,
      'createdAt': createdAt,
      if (favouriteData != null) 'favouriteData': favouriteData,
      'favourite': favourite,
    };
  }
}
