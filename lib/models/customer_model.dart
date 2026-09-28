import '../core/constants/api_constants.dart';

class CustomerModel {
  final int id;
  final String name;
  final String email;
  final String phone;
  final String primaryAddress;
  final String secondaryAddress;
  final String? notes;
  final String custType;
  final String? imagePath;
  final bool isInactive;
  final double totalDue;
  final String? lastSalesDate;
  final String? lastInvoiceNo;
  final String? lastSoldProduct;
  final double totalSalesValue;
  final double totalCollection;

  CustomerModel({
    required this.id,
    required this.name,
    required this.email,
    required this.phone,
    required this.primaryAddress,
    required this.secondaryAddress,
    this.notes,
    required this.custType,
    this.imagePath,
    this.isInactive = false,
    this.totalDue = 0.0,
    this.lastSalesDate,
    this.lastInvoiceNo,
    this.lastSoldProduct,
    this.totalSalesValue = 0.0,
    this.totalCollection = 0.0,
  });

  String? get fullImageUrl {
    if (imagePath == null || imagePath!.trim().isEmpty) return null;
    final path = imagePath!.trim();
    if (path.startsWith('http://') || path.startsWith('https://')) {
      return path;
    }
    // Remove leading slash if needed
    final cleanPath = path.startsWith('/') ? path.substring(1) : path;
    return '${ApiConstants.imageBaseUrl}$cleanPath';
  }

  factory CustomerModel.fromJson(Map<String, dynamic> json) {
    return CustomerModel(
      id: json['Id'] as int? ?? 0,
      name: json['Name'] as String? ?? 'Unnamed Customer',
      email: json['Email'] as String? ?? '',
      phone: json['Phone'] as String? ?? '',
      primaryAddress: json['PrimaryAddress'] as String? ?? '',
      secondaryAddress: json['SecoundaryAddress'] as String? ?? '',
      notes: json['Notes'] as String?,
      custType: json['CustType'] as String? ?? 'Regular',
      imagePath: json['ImagePath'] as String?,
      isInactive: json['IsInActive'] as bool? ?? false,
      totalDue: (json['TotalDue'] as num?)?.toDouble() ?? 0.0,
      lastSalesDate: json['LastSalesDate'] as String?,
      lastInvoiceNo: json['LastInvoiceNo'] as String?,
      lastSoldProduct: json['LastSoldProduct'] as String?,
      totalSalesValue: (json['TotalSalesValue'] as num?)?.toDouble() ?? 0.0,
      totalCollection: (json['TotalCollection'] as num?)?.toDouble() ?? 0.0,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'Id': id,
      'Name': name,
      'Email': email,
      'Phone': phone,
      'PrimaryAddress': primaryAddress,
      'SecoundaryAddress': secondaryAddress,
      'Notes': notes,
      'CustType': custType,
      'ImagePath': imagePath,
      'IsInActive': isInactive,
      'TotalDue': totalDue,
      'LastSalesDate': lastSalesDate,
      'LastInvoiceNo': lastInvoiceNo,
      'LastSoldProduct': lastSoldProduct,
      'TotalSalesValue': totalSalesValue,
      'TotalCollection': totalCollection,
    };
  }
}
