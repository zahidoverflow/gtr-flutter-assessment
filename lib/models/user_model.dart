class UserModel {
  final String userName;
  final String token;
  final int userId;
  final int comId;
  final String email;
  final String companyName;
  final String roleName;
  final String? empImagePath;
  final String currencySymbol;

  UserModel({
    required this.userName,
    required this.token,
    required this.userId,
    required this.comId,
    required this.email,
    required this.companyName,
    required this.roleName,
    this.empImagePath,
    this.currencySymbol = '৳',
  });

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      userName: json['UserName'] as String? ?? '',
      token: json['Token'] as String? ?? '',
      userId: json['UserId'] as int? ?? 0,
      comId: json['ComId'] as int? ?? 1,
      email: json['Email'] as String? ?? '',
      companyName: json['CompanyName'] as String? ?? '',
      roleName: json['RoleName'] as String? ?? '',
      empImagePath: json['EmpImagePath'] as String?,
      currencySymbol: json['CurrencySymbol'] as String? ?? '৳',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'UserName': userName,
      'Token': token,
      'UserId': userId,
      'ComId': comId,
      'Email': email,
      'CompanyName': companyName,
      'RoleName': roleName,
      'EmpImagePath': empImagePath,
      'CurrencySymbol': currencySymbol,
    };
  }
}
