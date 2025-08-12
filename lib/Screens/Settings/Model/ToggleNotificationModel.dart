class ToggleNotificationModel {
  ToggleNotificationModel({this.statusCode, this.message, this.success, this.result});

  ToggleNotificationModel.fromJson(dynamic json) {
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
    this.id,
    this.social,
    this.meta,
    this.profileImage,
    this.bio,
    this.gender,
    this.country,
    this.timezone,
    this.status,
    this.loggedIn,
    this.verified,
    this.notificationEnabled,
    this.isDelete,
    this.email,
    this.password,
    this.name,
    this.registerationDate,
    this.createdAt,
    this.updatedAt,
    this.v,
  });

  Result.fromJson(dynamic json) {
    id = json['_id'];
    social = json['social'] != null ? Social.fromJson(json['social']) : null;
    meta = json['meta'] != null ? Meta.fromJson(json['meta']) : null;
    profileImage = json['profileImage'];
    bio = json['bio'];
    gender = json['gender'];
    country = json['country'];
    timezone = json['timezone'];
    status = json['status'];
    loggedIn = json['loggedIn'];
    verified = json['verified'];
    notificationEnabled = json['notificationEnabled'];
    isDelete = json['isDelete'];
    email = json['email'];
    password = json['password'];
    name = json['name'];
    registerationDate = json['registerationDate'];
    createdAt = json['createdAt'];
    updatedAt = json['updatedAt'];
    v = json['__v'];
  }
  String? id;
  Social? social;
  Meta? meta;
  String? profileImage;
  String? bio;
  String? gender;
  String? country;
  String? timezone;
  int? status;
  bool? loggedIn;
  bool? verified;
  bool? notificationEnabled;
  bool? isDelete;
  String? email;
  String? password;
  String? name;
  String? registerationDate;
  String? createdAt;
  String? updatedAt;
  int? v;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['_id'] = id;
    if (social != null) {
      map['social'] = social?.toJson();
    }
    if (meta != null) {
      map['meta'] = meta?.toJson();
    }
    map['profileImage'] = profileImage;
    map['bio'] = bio;
    map['gender'] = gender;
    map['country'] = country;
    map['timezone'] = timezone;
    map['status'] = status;
    map['loggedIn'] = loggedIn;
    map['verified'] = verified;
    map['notificationEnabled'] = notificationEnabled;
    map['isDelete'] = isDelete;
    map['email'] = email;
    map['password'] = password;
    map['name'] = name;
    map['registerationDate'] = registerationDate;
    map['createdAt'] = createdAt;
    map['updatedAt'] = updatedAt;
    map['__v'] = v;
    return map;
  }
}

class Meta {
  Meta({this.tokenData});

  Meta.fromJson(dynamic json) {
    tokenData = json['tokenData'] != null ? TokenData.fromJson(json['tokenData']) : null;
  }
  TokenData? tokenData;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    if (tokenData != null) {
      map['tokenData'] = tokenData?.toJson();
    }
    return map;
  }
}

class TokenData {
  TokenData({this.token, this.tokenExpiryDate});

  TokenData.fromJson(dynamic json) {
    token = json['token'];
    tokenExpiryDate = json['tokenExpiryDate'];
  }
  String? token;
  dynamic tokenExpiryDate;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['token'] = token;
    map['tokenExpiryDate'] = tokenExpiryDate;
    return map;
  }
}

class Social {
  Social({this.facebookToken, this.facebookLogin, this.googleToken, this.googleLogin});

  Social.fromJson(dynamic json) {
    facebookToken = json['facebookToken'];
    facebookLogin = json['facebookLogin'];
    googleToken = json['googleToken'];
    googleLogin = json['googleLogin'];
  }
  String? facebookToken;
  bool? facebookLogin;
  String? googleToken;
  bool? googleLogin;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['facebookToken'] = facebookToken;
    map['facebookLogin'] = facebookLogin;
    map['googleToken'] = googleToken;
    map['googleLogin'] = googleLogin;
    return map;
  }
}
