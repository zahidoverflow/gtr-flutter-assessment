import 'package:flutter_test/flutter_test.dart';
import 'package:gtr_customer_app/models/customer_model.dart';

void main() {
  group('CustomerModel Tests', () {
    test('Correctly parses JSON with all fields', () {
      final json = {
        'Id': 101,
        'Name': 'Test Corporation',
        'Email': 'contact@test.com',
        'Phone': '01700000000',
        'PrimaryAddress': 'Dhaka, Bangladesh',
        'SecoundaryAddress': 'Uttara',
        'Notes': 'High priority VIP client',
        'CustType': 'VIP',
        'ImagePath': 'images/cust101.png',
        'IsInActive': false,
        'TotalDue': 15000.50,
        'LastSalesDate': '2026-09-20',
        'LastInvoiceNo': 'INV-9021',
        'LastSoldProduct': 'Software License',
        'TotalSalesValue': 50000.0,
        'TotalCollection': 35000.0,
      };

      final customer = CustomerModel.fromJson(json);

      expect(customer.id, 101);
      expect(customer.name, 'Test Corporation');
      expect(customer.email, 'contact@test.com');
      expect(customer.phone, '01700000000');
      expect(customer.primaryAddress, 'Dhaka, Bangladesh');
      expect(customer.totalDue, 15000.50);
      expect(customer.fullImageUrl, 'https://www.hisabplus.com/images/cust101.png');
      expect(customer.isInactive, false);
    });

    test('Handles null fields with graceful fallbacks', () {
      final json = {
        'Id': null,
        'Name': null,
        'Email': null,
        'Phone': null,
        'PrimaryAddress': null,
        'TotalDue': null,
        'ImagePath': null,
      };

      final customer = CustomerModel.fromJson(json);

      expect(customer.id, 0);
      expect(customer.name, 'Unnamed Customer');
      expect(customer.email, '');
      expect(customer.phone, '');
      expect(customer.primaryAddress, '');
      expect(customer.totalDue, 0.0);
      expect(customer.fullImageUrl, null);
    });
  });
}
