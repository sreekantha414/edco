import '../../Categories/Model/CategoriesModel.dart';

class SearchModel {
  SearchModel({
    this.statusCode,
    this.message,
    this.success,
    this.result,
  });

  SearchModel.fromJson(dynamic json) {
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
  Result({
    this.totalRecords,
    this.data,
    this.nextPageExists,
    this.nextPage,
  });

  Result.fromJson(dynamic json) {
    totalRecords = json['totalRecords'];
    if (json['data'] != null) {
      data = [];
      json['data'].forEach((v) {
        data?.add(SearchList.fromJson(v));
      });
    }
    nextPageExists = json['nextPageExists'];
    nextPage = json['nextPage'];
  }
  int? totalRecords;
  List<SearchList>? data;
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

class SearchList {
  SearchList({
    this.id,
    this.imageName,
    this.imageDescription,
    this.imageUrl,
    this.webUrl,
    this.categoryData,
  });

  SearchList.fromJson(dynamic json) {
    id = json['_id'];
    imageName = json['imageName'];
    imageDescription = json['imageDescription'];
    imageUrl = json['imageUrl'];
    webUrl = json['webUrl'];
    categoryData = json['categoryData'] != null ? Categories.fromJson(json['categoryData']) : null;
  }
  String? id;
  String? imageName;
  String? imageDescription;
  String? imageUrl;
  String? webUrl;
  Categories? categoryData;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['_id'] = id;
    map['imageName'] = imageName;
    map['imageDescription'] = imageDescription;
    map['imageUrl'] = imageUrl;
    map['webUrl'] = webUrl;
    if (categoryData != null) {
      map['categoryData'] = categoryData?.toJson();
    }
    return map;
  }
}
