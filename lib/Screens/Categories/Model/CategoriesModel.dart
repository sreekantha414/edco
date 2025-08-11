class CategoriesModel {
  CategoriesModel({this.statusCode, this.message, this.success, this.result});

  CategoriesModel.fromJson(dynamic json) {
    statusCode = json['statusCode'];
    message = json['message'];
    success = json['success'];
    if (json['result'] != null) {
      result = [];
      json['result'].forEach((v) {
        result?.add(Categories.fromJson(v));
      });
    }
  }
  int? statusCode;
  String? message;
  bool? success;
  List<Categories>? result;

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

class Categories {
  Categories({this.id, this.uniqueId, this.categoryImage, this.categoryStatus, this.categoryName, this.createdAt, this.updatedAt, this.v});

  Categories.fromJson(dynamic json) {
    id = json['_id'];
    uniqueId = json['uniqueId'];
    categoryImage = json['categoryImage'];
    categoryStatus = json['categoryStatus'];
    categoryName = json['categoryName'];
    createdAt = json['createdAt'];
    updatedAt = json['updatedAt'];
    v = json['__v'];
  }
  String? id;
  String? uniqueId;
  String? categoryImage;
  String? categoryStatus;
  String? categoryName;
  String? createdAt;
  String? updatedAt;
  int? v;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['_id'] = id;
    map['uniqueId'] = uniqueId;
    map['categoryImage'] = categoryImage;
    map['categoryStatus'] = categoryStatus;
    map['categoryName'] = categoryName;
    map['createdAt'] = createdAt;
    map['updatedAt'] = updatedAt;
    map['__v'] = v;
    return map;
  }
}
