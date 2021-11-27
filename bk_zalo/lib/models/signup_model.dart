class GetUserModel {
  late final String code;
  late final String message;
  late final dynamic data;

  GetUserModel({
    required this.code,
    required this.message,
    required this.data,
  });

  factory GetUserModel.fromJson(Map<String, dynamic> json) {
    return GetUserModel(
      code: json['code'],
      message: json['message'],
      data: json['data'] ?? {},
    );
  }

  Map<String, dynamic> toJson({
    required String phone,
  }) {
    Map<String, dynamic> map = {
      'phone': phone,
    };

    return map;
  }
}

class SignupRequestModel {
  late String phone;
  late String passwd;

  SignupRequestModel() {}

  Map<String, dynamic> toJson() {
    Map<String, dynamic> map = {
      'phone': phone.trim(),
      'passwd': passwd.trim(),
    };

    return map;
  }
}

class SignupResponseModel {
  late final String code;
  late final String message;
  late final dynamic data;

  SignupResponseModel({
    required this.code,
    required this.message,
    required this.data,
  });

  factory SignupResponseModel.fromJson(Map<String, dynamic> json) {
    return SignupResponseModel(
      code: json['code'],
      message: json['message'],
      data: json['data'],
    );
  }
}
