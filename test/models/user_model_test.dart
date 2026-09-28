import 'package:flutter_test/flutter_test.dart';
import 'package:gtr_customer_app/models/user_model.dart';

void main() {
  group('UserModel Tests', () {
    test('Correctly deserializes user login response', () {
      final json = {
        'UserName': 'admin',
        'Token': 'test_jwt_token_xyz',
        'UserId': 130,
        'ComId': 1,
        'Email': 'admin@gmail.com',
        'CompanyName': 'Dominate Software',
        'RoleName': 'Admin',
        'CurrencySymbol': '৳',
      };

      final user = UserModel.fromJson(json);

      expect(user.userName, 'admin');
      expect(user.token, 'test_jwt_token_xyz');
      expect(user.userId, 130);
      expect(user.comId, 1);
      expect(user.companyName, 'Dominate Software');
      expect(user.currencySymbol, '৳');
    });
  });
}
