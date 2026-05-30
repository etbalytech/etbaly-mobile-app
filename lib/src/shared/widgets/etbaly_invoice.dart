import 'package:flutter/material.dart';
import '../../extensions/context_extension.dart';
import '../../theme/etbaly_colors.dart';
import '../../theme/theme.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

/// Etbaly Invoice Widget
/// Matches web version's invoice design with purple/gold theme
class EtbalyInvoice extends StatelessWidget {
  const EtbalyInvoice({
    super.key,
    required this.invoiceNumber,
    required this.invoiceDate,
    required this.clientName,
    required this.clientMobile,
    required this.clientWhatsApp,
    required this.clientEmail,
    required this.serviceName,
    required this.items,
    this.companyName,
  });

  final String invoiceNumber;
  final String invoiceDate;
  final String clientName;
  final String clientMobile;
  final String clientWhatsApp;
  final String clientEmail;
  final String serviceName;
  final List<InvoiceItem> items;
  final String? companyName;

  double get grandTotal {
    return items.fold(0, (sum, item) => sum + item.total);
  }

  Future<void> _exportAsImage(BuildContext context) async {
    try {
      // TODO: Implement actual image export using RepaintBoundary
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: const Text('Invoice export coming soon!'),
          backgroundColor: context.etbalyColors.gold,
        ),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Failed to export invoice'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  void _sendProofByEmail(BuildContext context) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: const Text('Email sending functionality coming soon!'),
        backgroundColor: context.etbalyColors.gold,
      ),
    );
  }

  void _sendProofByWhatsApp(BuildContext context) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: const Text('WhatsApp sending functionality coming soon!'),
        backgroundColor: context.etbalyColors.gold,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final etbalyColors = context.etbalyColors;
    final designTokens = context.designTokens;

    return Dialog(
      backgroundColor: Colors.transparent,
      child: Container(
        margin: EdgeInsets.all(20.r),
        decoration: BoxDecoration(
          color: etbalyColors.bgCard,
          borderRadius: BorderRadius.circular(designTokens.borderRadiusLarge),
          border: Border.all(
            color: etbalyColors.borderColor.withValues(alpha: 0.3),
            width: 1.w,
          ),
          boxShadow: [
            BoxShadow(
              color: etbalyColors.cardShadow,
              blurRadius: 20.r,
              offset: Offset(0.w, 8.h),
              spreadRadius: 0.r,
            ),
            BoxShadow(
              color: etbalyColors.primaryGlow,
              blurRadius: 32.r,
              offset: Offset(0.w, 8.h),
              spreadRadius: 0.r,
            ),
          ],
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Header
            _buildHeader(context, etbalyColors, designTokens),

            // Gold Bar
            Container(
              height: 4.h,
              margin: EdgeInsets.symmetric(horizontal: 24.w),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    etbalyColors.goldLight,
                    etbalyColors.gold,
                    etbalyColors.goldDark,
                  ],
                ),
                borderRadius: BorderRadius.circular(2.r),
              ),
            ),

            // Client Details
            _buildClientDetails(context, etbalyColors, designTokens),

            // Order Details Table
            _buildOrderTable(context, etbalyColors, designTokens),

            // Footer
            _buildFooter(context, etbalyColors, designTokens),

            // Actions
            _buildActions(context, etbalyColors, designTokens),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader(BuildContext context, EtbalyColorsExtension etbalyColors,
      AppDesignTokens designTokens) {
    return Padding(
      padding: EdgeInsets.all(24.r),
      child: Row(
        children: [
          // Logo/Icon
          Container(
            width: 48.w,
            height: 48.h,
            decoration: BoxDecoration(
              color: etbalyColors.badgeBg,
              borderRadius:
                  BorderRadius.circular(designTokens.borderRadiusSmall),
            ),
            child: Icon(
              Icons.receipt_long,
              color: etbalyColors.primary,
              size: 24.sp,
            ),
          ),
          SizedBox(width: 16.w),

          // Service Info
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  serviceName,
                  style: context.textTheme.headlineSmall?.copyWith(
                    color: etbalyColors.textMain,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(height: 4.h),
                Text(
                  'Etbaly Services',
                  style: context.textTheme.bodyMedium?.copyWith(
                    color: etbalyColors.textMuted,
                  ),
                ),
              ],
            ),
          ),

          // Invoice Meta
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(
                '#$invoiceNumber',
                style: context.textTheme.labelLarge?.copyWith(
                  color: etbalyColors.textMain,
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(height: 4.h),
              Text(
                invoiceDate,
                style: context.textTheme.bodySmall?.copyWith(
                  color: etbalyColors.textMuted,
                ),
              ),
              SizedBox(height: 4.h),
              Container(
                padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 4.h),
                decoration: BoxDecoration(
                  color: etbalyColors.gold.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(12.r),
                ),
                child: Text(
                  'Pending Payment',
                  style: context.textTheme.labelSmall?.copyWith(
                    color: etbalyColors.gold,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildClientDetails(BuildContext context,
      EtbalyColorsExtension etbalyColors, AppDesignTokens designTokens) {
    return Padding(
      padding: EdgeInsets.all(24.r),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Client Details',
            style: context.textTheme.titleMedium?.copyWith(
              color: etbalyColors.textMain,
              fontWeight: FontWeight.w600,
            ),
          ),
          SizedBox(height: 16.h),

          // Client Grid
          GridView.count(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            crossAxisCount: 2,
            childAspectRatio: 2.5,
            mainAxisSpacing: 12.r,
            crossAxisSpacing: 12.r,
            children: [
              _buildClientItem('Name', clientName, etbalyColors, context),
              _buildClientItem('Mobile', clientMobile, etbalyColors, context),
              _buildClientItem(
                  'WhatsApp', clientWhatsApp, etbalyColors, context),
              _buildClientItem('Email', clientEmail, etbalyColors, context),
              if (companyName != null)
                _buildClientItem(
                    'Company', companyName!, etbalyColors, context),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildClientItem(String label, String value,
      EtbalyColorsExtension etbalyColors, BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: context.textTheme.labelSmall?.copyWith(
            color: etbalyColors.textMuted,
            fontWeight: FontWeight.w500,
          ),
        ),
        SizedBox(height: 4.h),
        Text(
          value,
          style: context.textTheme.bodyMedium?.copyWith(
            color: etbalyColors.textMain,
            fontWeight: FontWeight.w500,
          ),
        ),
      ],
    );
  }

  Widget _buildOrderTable(BuildContext context,
      EtbalyColorsExtension etbalyColors, AppDesignTokens designTokens) {
    return Padding(
      padding: EdgeInsets.all(24.r),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Order Details',
            style: context.textTheme.titleMedium?.copyWith(
              color: etbalyColors.textMain,
              fontWeight: FontWeight.w600,
            ),
          ),
          SizedBox(height: 16.h),

          // Table
          DecoratedBox(
            decoration: BoxDecoration(
              color: etbalyColors.bgSubtle,
              borderRadius:
                  BorderRadius.circular(designTokens.borderRadiusMedium),
              border: Border.all(
                color: etbalyColors.borderSubtle,
                width: 1.w,
              ),
            ),
            child: Column(
              children: [
                // Table Header
                Container(
                  padding: EdgeInsets.all(16.r),
                  decoration: BoxDecoration(
                    color: etbalyColors.primary.withValues(alpha: 0.1),
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(12.r),
                      topRight: Radius.circular(12.r),
                    ),
                  ),
                  child: Row(
                    children: [
                      Expanded(
                        flex: 3,
                        child: Text(
                          'Service',
                          style: context.textTheme.labelSmall?.copyWith(
                            color: etbalyColors.primary,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      Expanded(
                        flex: 1,
                        child: Text(
                          'Qty',
                          textAlign: TextAlign.center,
                          style: context.textTheme.labelSmall?.copyWith(
                            color: etbalyColors.primary,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      Expanded(
                        flex: 2,
                        child: Text(
                          'Unit Price',
                          textAlign: TextAlign.end,
                          style: context.textTheme.labelSmall?.copyWith(
                            color: etbalyColors.primary,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      Expanded(
                        flex: 2,
                        child: Text(
                          'Total',
                          textAlign: TextAlign.end,
                          style: context.textTheme.labelSmall?.copyWith(
                            color: etbalyColors.primary,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),

                // Table Rows
                ...items
                    .map((item) => _buildTableRow(context, item, etbalyColors)),

                // Grand Total
                Container(
                  padding: EdgeInsets.all(16.r),
                  decoration: BoxDecoration(
                    color: etbalyColors.gold.withValues(alpha: 0.1),
                    borderRadius: BorderRadius.only(
                      bottomLeft: Radius.circular(12.r),
                      bottomRight: Radius.circular(12.r),
                    ),
                  ),
                  child: Row(
                    children: [
                      Expanded(
                        flex: 6,
                        child: Text(
                          'Grand Total',
                          style: context.textTheme.titleSmall?.copyWith(
                            color: etbalyColors.gold,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      Expanded(
                        flex: 2,
                        child: Text(
                          '${grandTotal.toStringAsFixed(2)} EGP',
                          textAlign: TextAlign.end,
                          style: context.textTheme.titleSmall?.copyWith(
                            color: etbalyColors.gold,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTableRow(BuildContext context, InvoiceItem item,
      EtbalyColorsExtension etbalyColors) {
    return Container(
      padding: EdgeInsets.all(16.r),
      decoration: BoxDecoration(
        border: Border(
          bottom: BorderSide(
            color: etbalyColors.borderSubtle,
            width: 1.w,
          ),
        ),
      ),
      child: Row(
        children: [
          Expanded(
            flex: 3,
            child: Text(
              item.name,
              style: context.textTheme.bodyMedium?.copyWith(
                color: etbalyColors.textMain,
              ),
            ),
          ),
          Expanded(
            flex: 1,
            child: Container(
              padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 4.h),
              decoration: BoxDecoration(
                color: etbalyColors.badgeBg,
                borderRadius: BorderRadius.circular(8.r),
              ),
              child: Text(
                '${item.quantity}',
                textAlign: TextAlign.center,
                style: context.textTheme.labelSmall?.copyWith(
                  color: etbalyColors.primary,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ),
          Expanded(
            flex: 2,
            child: Text(
              '${item.unitPrice.toStringAsFixed(2)} EGP',
              textAlign: TextAlign.end,
              style: context.textTheme.bodyMedium?.copyWith(
                color: etbalyColors.textMain,
              ),
            ),
          ),
          Expanded(
            flex: 2,
            child: Text(
              '${item.total.toStringAsFixed(2)} EGP',
              textAlign: TextAlign.end,
              style: context.textTheme.bodyMedium?.copyWith(
                color: etbalyColors.textMain,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFooter(BuildContext context, EtbalyColorsExtension etbalyColors,
      AppDesignTokens designTokens) {
    return Padding(
      padding: EdgeInsets.all(24.r),
      child: Row(
        children: [
          Icon(
            Icons.favorite,
            color: etbalyColors.gold,
            size: 16.sp,
          ),
          SizedBox(width: 8.w),
          Text(
            'Thank you for your trust — Etbaly Services',
            style: context.textTheme.bodySmall?.copyWith(
              color: etbalyColors.textMuted,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildActions(BuildContext context, EtbalyColorsExtension etbalyColors,
      AppDesignTokens designTokens) {
    return Padding(
      padding: EdgeInsets.all(24.r),
      child: Row(
        children: [
          Expanded(
            child: OutlinedButton.icon(
              onPressed: () => Navigator.of(context).pop(),
              icon: const Icon(Icons.close),
              label: const Text('Close'),
              style: OutlinedButton.styleFrom(
                foregroundColor: etbalyColors.textMuted,
                side: BorderSide(color: etbalyColors.borderColor),
                padding: EdgeInsets.symmetric(vertical: 12.h),
              ),
            ),
          ),
          SizedBox(width: 12.w),
          Expanded(
            child: ElevatedButton.icon(
              onPressed: () => _exportAsImage(context),
              icon: const Icon(Icons.image),
              label: const Text('Download Image'),
              style: ElevatedButton.styleFrom(
                backgroundColor: etbalyColors.gold,
                foregroundColor: Colors.black,
                padding: EdgeInsets.symmetric(vertical: 12.h),
              ),
            ),
          ),
          SizedBox(width: 12.w),
          Expanded(
            child: OutlinedButton.icon(
              onPressed: () => _sendProofByEmail(context),
              icon: const Icon(Icons.email),
              label: const Text('Send Email'),
              style: OutlinedButton.styleFrom(
                foregroundColor: etbalyColors.textMuted,
                side: BorderSide(color: etbalyColors.borderColor),
                padding: EdgeInsets.symmetric(vertical: 12.h),
              ),
            ),
          ),
          SizedBox(width: 12.w),
          Expanded(
            child: OutlinedButton.icon(
              onPressed: () => _sendProofByWhatsApp(context),
              icon: const Icon(Icons.message),
              label: const Text('WhatsApp'),
              style: OutlinedButton.styleFrom(
                foregroundColor: etbalyColors.textMuted,
                side: BorderSide(color: etbalyColors.borderColor),
                padding: EdgeInsets.symmetric(vertical: 12.h),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class InvoiceItem {
  final String name;
  final int quantity;
  final double unitPrice;

  InvoiceItem({
    required this.name,
    required this.quantity,
    required this.unitPrice,
  });

  double get total => quantity * unitPrice;
}
