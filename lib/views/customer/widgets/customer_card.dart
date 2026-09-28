import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../../../core/constants/app_colors.dart';
import '../../../models/customer_model.dart';
import '../customer_details_screen.dart';

class CustomerCard extends StatelessWidget {
  final CustomerModel customer;

  const CustomerCard({super.key, required this.customer});

  Color _getAvatarColor(String name) {
    final colors = [
      const Color(0xFF2563EB), // Blue
      const Color(0xFF0D9488), // Teal
      const Color(0xFF7C3AED), // Purple
      const Color(0xFFD97706), // Amber
      const Color(0xFF059669), // Emerald
      const Color(0xFFE11D48), // Rose
    ];
    final hash = name.codeUnits.fold(0, (prev, curr) => prev + curr);
    return colors[hash % colors.length];
  }

  String _getInitials(String name) {
    if (name.trim().isEmpty) return '?';
    final parts = name.trim().split(RegExp(r'\s+'));
    if (parts.length == 1) {
      return parts[0].substring(0, parts[0].length >= 2 ? 2 : 1).toUpperCase();
    }
    return '${parts[0][0]}${parts[1][0]}'.toUpperCase();
  }

  @override
  Widget build(BuildContext context) {
    final currencyFormatter = NumberFormat.currency(
      locale: 'en_US',
      symbol: '৳ ',
      decimalDigits: 2,
    );

    final avatarBg = _getAvatarColor(customer.name);
    final initials = _getInitials(customer.name);

    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
      decoration: BoxDecoration(
        color: AppColors.cardBg,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.border),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.02),
            offset: const Offset(0, 2),
            blurRadius: 8,
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        borderRadius: BorderRadius.circular(16),
        child: InkWell(
          borderRadius: BorderRadius.circular(16),
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (_) => CustomerDetailsScreen(customer: customer),
              ),
            );
          },
          child: Padding(
            padding: const EdgeInsets.all(14),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Avatar / Image
                ClipRRect(
                  borderRadius: BorderRadius.circular(12),
                  child: customer.fullImageUrl != null
                      ? Image.network(
                          customer.fullImageUrl!,
                          width: 48,
                          height: 48,
                          fit: BoxFit.cover,
                          errorBuilder: (ctx, err, stack) => _buildInitialsAvatar(avatarBg, initials),
                        )
                      : _buildInitialsAvatar(avatarBg, initials),
                ),
                const SizedBox(width: 14),

                // Main Info
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Expanded(
                            child: Text(
                              customer.name,
                              style: const TextStyle(
                                fontSize: 15,
                                fontWeight: FontWeight.w600,
                                color: AppColors.textPrimary,
                              ),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                          const SizedBox(width: 6),
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 7, vertical: 3),
                            decoration: BoxDecoration(
                              color: AppColors.primary.withValues(alpha: 0.08),
                              borderRadius: BorderRadius.circular(6),
                            ),
                            child: Text(
                              'Type ${customer.custType}',
                              style: const TextStyle(
                                fontSize: 11,
                                fontWeight: FontWeight.w600,
                                color: AppColors.primary,
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 6),

                      // Phone if available
                      if (customer.phone.isNotEmpty)
                        Padding(
                          padding: const EdgeInsets.only(bottom: 4),
                          child: Row(
                            children: [
                              const Icon(Icons.phone_outlined, size: 14, color: AppColors.textMuted),
                              const SizedBox(width: 5),
                              Text(
                                customer.phone,
                                style: const TextStyle(
                                  fontSize: 13,
                                  color: AppColors.textSecondary,
                                ),
                              ),
                            ],
                          ),
                        ),

                      // Address if available
                      if (customer.primaryAddress.isNotEmpty)
                        Row(
                          children: [
                            const Icon(Icons.location_on_outlined, size: 14, color: AppColors.textMuted),
                            const SizedBox(width: 5),
                            Expanded(
                              child: Text(
                                customer.primaryAddress,
                                style: const TextStyle(
                                  fontSize: 12,
                                  color: AppColors.textMuted,
                                ),
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                          ],
                        ),

                      const SizedBox(height: 10),
                      // Total Due badge
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Text(
                            'Outstanding Due:',
                            style: TextStyle(
                              fontSize: 12,
                              color: AppColors.textSecondary,
                            ),
                          ),
                          Text(
                            currencyFormatter.format(customer.totalDue),
                            style: TextStyle(
                              fontSize: 13,
                              fontWeight: FontWeight.w700,
                              color: customer.totalDue > 0 ? AppColors.danger : AppColors.success,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildInitialsAvatar(Color bg, String initials) {
    return Container(
      width: 48,
      height: 48,
      decoration: BoxDecoration(
        color: bg.withValues(alpha: 0.12),
        borderRadius: BorderRadius.circular(12),
      ),
      alignment: Alignment.center,
      child: Text(
        initials,
        style: TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.w700,
          color: bg,
        ),
      ),
    );
  }
}
