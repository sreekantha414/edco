class LoginModel {
  LoginModel({this.statusCode, this.message, this.success, this.result});

  LoginModel.fromJson(dynamic json) {
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
    this.profileImage,
    this.bio,
    this.gender,
    this.country,
    this.timezone,
    this.status,
    this.loggedIn,
    this.verified,
    this.notificationEnabled,
    this.name,
    this.email,
    this.registerationDate,
    this.createdAt,
    this.updatedAt,
    this.authtoken,
  });

  Result.fromJson(dynamic json) {
    id = json['_id'];
    social = json['social'] != null ? Social.fromJson(json['social']) : null;
    profileImage = json['profileImage'];
    bio = json['bio'];
    gender = json['gender'];
    country = json['country'];
    timezone = json['timezone'];
    status = json['status'];
    loggedIn = json['loggedIn'];
    verified = json['verified'];
    notificationEnabled = json['notificationEnabled'];
    name = json['name'];
    email = json['email'];
    registerationDate = json['registerationDate'];
    createdAt = json['createdAt'];
    updatedAt = json['updatedAt'];
    authtoken = json['authtoken'];
  }
  String? id;
  Social? social;
  dynamic profileImage;
  dynamic bio;
  String? gender;
  String? country;
  String? timezone;
  int? status;
  bool? loggedIn;
  bool? verified;
  bool? notificationEnabled;
  String? name;
  String? email;
  String? registerationDate;
  String? createdAt;
  String? updatedAt;
  String? authtoken;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['_id'] = id;
    if (social != null) {
      map['social'] = social?.toJson();
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
    map['name'] = name;
    map['email'] = email;
    map['registerationDate'] = registerationDate;
    map['createdAt'] = createdAt;
    map['updatedAt'] = updatedAt;
    map['authtoken'] = authtoken;
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
