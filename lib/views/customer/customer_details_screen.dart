import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../../core/constants/app_colors.dart';
import '../../models/customer_model.dart';

class CustomerDetailsScreen extends StatelessWidget {
  final CustomerModel customer;

  const CustomerDetailsScreen({super.key, required this.customer});

  @override
  Widget build(BuildContext context) {
    final currencyFormatter = NumberFormat.currency(
      locale: 'en_US',
      symbol: '৳ ',
      decimalDigits: 2,
    );

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: const Text(
          'Customer Profile',
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.w700),
        ),
        backgroundColor: Colors.white,
        foregroundColor: AppColors.textPrimary,
        elevation: 0,
        centerTitle: true,
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(1),
          child: Container(color: AppColors.border, height: 1),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            // Header Profile Card
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(20),
                border: Border.all(color: AppColors.border),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.02),
                    blurRadius: 10,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: Column(
                children: [
                  // Large Avatar
                  ClipRRect(
                    borderRadius: BorderRadius.circular(20),
                    child: customer.fullImageUrl != null
                        ? Image.network(
                            customer.fullImageUrl!,
                            width: 80,
                            height: 80,
                            fit: BoxFit.cover,
                            errorBuilder: (ctx, err, stack) => _buildInitialsAvatar(customer.name),
                          )
                        : _buildInitialsAvatar(customer.name),
                  ),
                  const SizedBox(height: 14),
                  Text(
                    customer.name,
                    textAlign: TextAlign.center,
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w700,
                      color: AppColors.textPrimary,
                    ),
                  ),
                  const SizedBox(height: 6),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                        decoration: BoxDecoration(
                          color: AppColors.primary.withValues(alpha: 0.08),
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Text(
                          'ID: #${customer.id}',
                          style: const TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.w600,
                            color: AppColors.primary,
                          ),
                        ),
                      ),
                      const SizedBox(width: 8),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                        decoration: BoxDecoration(
                          color: customer.isInactive
                              ? AppColors.danger.withValues(alpha: 0.08)
                              : AppColors.success.withValues(alpha: 0.08),
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Text(
                          customer.isInactive ? 'Inactive' : 'Active',
                          style: TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.w600,
                            color: customer.isInactive ? AppColors.danger : AppColors.success,
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),

            // Financial Summary Cards
            Row(
              children: [
                Expanded(
                  child: _buildFinancialCard(
                    title: 'Total Due',
                    amount: currencyFormatter.format(customer.totalDue),
                    icon: Icons.account_balance_wallet_outlined,
                    color: customer.totalDue > 0 ? AppColors.danger : AppColors.success,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: _buildFinancialCard(
                    title: 'Collections',
                    amount: currencyFormatter.format(customer.totalCollection),
                    icon: Icons.payments_outlined,
                    color: AppColors.success,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            _buildFinancialCard(
              title: 'Total Sales Value',
              amount: currencyFormatter.format(customer.totalSalesValue),
              icon: Icons.shopping_bag_outlined,
              color: AppColors.primary,
              isFullWidth: true,
            ),
            const SizedBox(height: 16),

            // Contact Information
            _buildSectionCard(
              title: 'Contact Information',
              icon: Icons.contact_phone_outlined,
              children: [
                _buildInfoRow('Phone', customer.phone.isNotEmpty ? customer.phone : 'Not provided', Icons.phone),
                const Divider(height: 20, color: AppColors.divider),
                _buildInfoRow('Email', customer.email.isNotEmpty ? customer.email : 'Not provided', Icons.email_outlined),
                const Divider(height: 20, color: AppColors.divider),
                _buildInfoRow('Primary Address', customer.primaryAddress.isNotEmpty ? customer.primaryAddress : 'Not specified', Icons.location_on_outlined),
                if (customer.secondaryAddress.isNotEmpty) ...[
                  const Divider(height: 20, color: AppColors.divider),
                  _buildInfoRow('Secondary Address', customer.secondaryAddress, Icons.home_outlined),
                ],
              ],
            ),
            const SizedBox(height: 16),

            // Sales & Transaction Insights
            _buildSectionCard(
              title: 'Sales & Activity',
              icon: Icons.receipt_long_outlined,
              children: [
                _buildInfoRow('Customer Type', customer.custType, Icons.category_outlined),
                const Divider(height: 20, color: AppColors.divider),
                _buildInfoRow('Last Invoice No', customer.lastInvoiceNo?.isNotEmpty == true ? customer.lastInvoiceNo! : 'N/A', Icons.tag),
                const Divider(height: 20, color: AppColors.divider),
                _buildInfoRow('Last Sales Date', customer.lastSalesDate?.isNotEmpty == true ? customer.lastSalesDate! : 'N/A', Icons.calendar_today_outlined),
                const Divider(height: 20, color: AppColors.divider),
                _buildInfoRow('Last Sold Item', customer.lastSoldProduct?.isNotEmpty == true ? customer.lastSoldProduct! : 'N/A', Icons.inventory_2_outlined),
              ],
            ),

            if (customer.notes != null && customer.notes!.trim().isNotEmpty) ...[
              const SizedBox(height: 16),
              _buildSectionCard(
                title: 'Customer Notes',
                icon: Icons.notes_outlined,
                children: [
                  Text(
                    customer.notes!,
                    style: const TextStyle(
                      fontSize: 14,
                      color: AppColors.textSecondary,
                      height: 1.5,
                    ),
                  ),
                ],
              ),
            ],
            const SizedBox(height: 24),
          ],
        ),
      ),
    );
  }

  Widget _buildInitialsAvatar(String name) {
    final initials = name.trim().isNotEmpty
        ? name.trim().split(RegExp(r'\s+')).take(2).map((e) => e.isNotEmpty ? e[0] : '').join().toUpperCase()
        : '?';

    return Container(
      width: 80,
      height: 80,
      decoration: BoxDecoration(
        color: AppColors.primary.withValues(alpha: 0.12),
        borderRadius: BorderRadius.circular(20),
      ),
      alignment: Alignment.center,
      child: Text(
        initials,
        style: const TextStyle(
          fontSize: 28,
          fontWeight: FontWeight.w700,
          color: AppColors.primary,
        ),
      ),
    );
  }

  Widget _buildFinancialCard({
    required String title,
    required String amount,
    required IconData icon,
    required Color color,
    bool isFullWidth = false,
  }) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.border),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: color.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(icon, size: 22, color: color),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w500,
                    color: AppColors.textSecondary,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  amount,
                  style: TextStyle(
                    fontSize: isFullWidth ? 16 : 14,
                    fontWeight: FontWeight.w700,
                    color: color,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSectionCard({
    required String title,
    required IconData icon,
    required List<Widget> children,
  }) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.border),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(icon, size: 18, color: AppColors.primary),
              const SizedBox(width: 8),
              Text(
                title,
                style: const TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.w700,
                  color: AppColors.textPrimary,
                ),
              ),
            ],
          ),
          const SizedBox(height: 14),
          ...children,
        ],
      ),
    );
  }

  Widget _buildInfoRow(String label, String value, IconData icon) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Icon(icon, size: 16, color: AppColors.textMuted),
        const SizedBox(width: 10),
        SizedBox(
          width: 120,
          child: Text(
            label,
            style: const TextStyle(
              fontSize: 13,
              color: AppColors.textSecondary,
              fontWeight: FontWeight.w500,
            ),
          ),
        ),
        Expanded(
          child: Text(
            value,
            style: const TextStyle(
              fontSize: 13,
              color: AppColors.textPrimary,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
      ],
    );
  }
}
