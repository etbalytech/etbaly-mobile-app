import 'dart:io';
import 'dart:ui' as ui;

import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:open_filex/open_filex.dart';
import 'package:path_provider/path_provider.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../extensions/context_extension.dart';
import '../../theme/etbaly_colors.dart';
import '../../theme/theme.dart';

class EtbalyInvoice extends StatefulWidget {
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

  @override
  State<EtbalyInvoice> createState() => _EtbalyInvoiceState();
}

class _EtbalyInvoiceState extends State<EtbalyInvoice> {
  final GlobalKey _repaintKey = GlobalKey();
  bool _isExporting = false;

  double get _grandTotal =>
      widget.items.fold(0, (sum, item) => sum + item.total);

  // ── Export as PNG ─────────────────────────────────────────────────────────

  Future<void> _exportAsImage() async {
    if (_isExporting) return;
    setState(() => _isExporting = true);

    try {
      // Let the frame settle after setState before capturing
      await Future<void>.delayed(const Duration(milliseconds: 120));

      final boundary = _repaintKey.currentContext?.findRenderObject()
          as RenderRepaintBoundary?;
      if (boundary == null) throw Exception('RepaintBoundary not ready');

      final image = await boundary.toImage(pixelRatio: 3);
      final byteData =
          await image.toByteData(format: ui.ImageByteFormat.png);
      if (byteData == null) throw Exception('Failed to encode PNG');

      final bytes = byteData.buffer.asUint8List();
      final dir = await getDownloadsDirectory() ??
          await getApplicationDocumentsDirectory();
      final fileName =
          'invoice_${widget.invoiceNumber}_${DateTime.now().millisecondsSinceEpoch}.png';
      final filePath = '${dir.path}/$fileName';
      await File(filePath).writeAsBytes(bytes, flush: true);

      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('تم حفظ الفاتورة: $fileName'),
          backgroundColor: context.etbalyColors.gold,
          duration: const Duration(seconds: 5),
          action: SnackBarAction(
            label: 'فتح',
            textColor: Colors.black,
            onPressed: () => OpenFilex.open(filePath),
          ),
        ),
      );
    } catch (_) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('فشل تصدير الفاتورة'),
          backgroundColor: Colors.red,
        ),
      );
    } finally {
      if (mounted) setState(() => _isExporting = false);
    }
  }

  // ── WhatsApp ──────────────────────────────────────────────────────────────

  Future<void> _sendProofByWhatsApp() async {
    final text = _buildInvoiceText();
    final url = Uri.parse(
        'https://wa.me/${widget.clientWhatsApp}?text=${Uri.encodeComponent(text)}');
    if (!await launchUrl(url, mode: LaunchMode.externalApplication)) {
      final fallback =
          Uri.parse('https://wa.me/?text=${Uri.encodeComponent(text)}');
      await launchUrl(fallback, mode: LaunchMode.externalApplication);
    }
  }

  // ── Email ─────────────────────────────────────────────────────────────────

  Future<void> _sendProofByEmail() async {
    final subject =
        Uri.encodeComponent('فاتورة رقم #${widget.invoiceNumber}');
    final body = Uri.encodeComponent(_buildInvoiceText());
    final url = Uri.parse(
        'mailto:${widget.clientEmail}?subject=$subject&body=$body');
    await launchUrl(url, mode: LaunchMode.externalApplication);
  }

  // ── Plain-text invoice summary ────────────────────────────────────────────

  String _buildInvoiceText() {
    final buf = StringBuffer();
    buf.writeln('🧾 فاتورة #${widget.invoiceNumber}');
    buf.writeln('📅 التاريخ: ${widget.invoiceDate}');
    buf.writeln('🛠 الخدمة: ${widget.serviceName}');
    buf.writeln('');
    buf.writeln('👤 العميل: ${widget.clientName}');
    buf.writeln('📞 الهاتف: ${widget.clientMobile}');
    buf.writeln('💬 واتساب: ${widget.clientWhatsApp}');
    if (widget.clientEmail.isNotEmpty) {
      buf.writeln('📧 البريد: ${widget.clientEmail}');
    }
    if (widget.companyName != null) {
      buf.writeln('🏢 الشركة: ${widget.companyName}');
    }
    buf.writeln('');
    buf.writeln('── التفاصيل ──────────────');
    for (final item in widget.items) {
      buf.writeln(
          '• ${item.name}  ×${item.quantity}  @${item.unitPrice.toStringAsFixed(2)} = ${item.total.toStringAsFixed(2)} ج.م');
    }
    buf.writeln('──────────────────────────');
    buf.writeln('💰 الإجمالي: ${_grandTotal.toStringAsFixed(2)} ج.م');
    buf.writeln('');
    buf.writeln('— اضبعلي للتسويق الرقمي');
    return buf.toString();
  }

  // ── Build ─────────────────────────────────────────────────────────────────

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
          borderRadius:
              BorderRadius.circular(designTokens.borderRadiusLarge),
          border: Border.all(
            color: etbalyColors.borderColor.withValues(alpha: 0.3),
            width: 1.w,
          ),
          boxShadow: [
            BoxShadow(
              color: etbalyColors.cardShadow,
              blurRadius: 20.r,
              offset: Offset(0.w, 8.h),
            ),
            BoxShadow(
              color: etbalyColors.primaryGlow,
              blurRadius: 32.r,
              offset: Offset(0.w, 8.h),
            ),
          ],
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // ── Exportable content (captured by RepaintBoundary) ──────────
            RepaintBoundary(
              key: _repaintKey,
              child: ColoredBox(
                color: etbalyColors.bgCard,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    _buildHeader(context, etbalyColors, designTokens),
                    // Gold accent bar
                    Container(
                      height: 4.h,
                      margin: EdgeInsets.symmetric(horizontal: 24.w),
                      decoration: BoxDecoration(
                        gradient: LinearGradient(colors: [
                          etbalyColors.goldLight,
                          etbalyColors.gold,
                          etbalyColors.goldDark,
                        ]),
                        borderRadius: BorderRadius.circular(2.r),
                      ),
                    ),
                    _buildClientDetails(
                        context, etbalyColors, designTokens),
                    _buildOrderTable(context, etbalyColors, designTokens),
                    _buildFooter(context, etbalyColors, designTokens),
                  ],
                ),
              ),
            ),
            // ── Action buttons (not included in exported image) ───────────
            _buildActions(context, etbalyColors, designTokens),
          ],
        ),
      ),
    );
  }

  // ── Header ────────────────────────────────────────────────────────────────

  Widget _buildHeader(BuildContext context,
      EtbalyColorsExtension etbalyColors, AppDesignTokens designTokens) {
    return Padding(
      padding: EdgeInsets.all(24.r),
      child: Row(
        children: [
          Container(
            width: 48.w,
            height: 48.h,
            decoration: BoxDecoration(
              color: etbalyColors.badgeBg,
              borderRadius:
                  BorderRadius.circular(designTokens.borderRadiusSmall),
            ),
            child: Icon(Icons.receipt_long,
                color: etbalyColors.primary, size: 24.sp),
          ),
          SizedBox(width: 16.w),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  widget.serviceName,
                  style: context.textTheme.headlineSmall?.copyWith(
                    color: etbalyColors.textMain,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(height: 4.h),
                Text(
                  'Etbaly Services',
                  style: context.textTheme.bodyMedium
                      ?.copyWith(color: etbalyColors.textMuted),
                ),
              ],
            ),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(
                '#${widget.invoiceNumber}',
                style: context.textTheme.labelLarge?.copyWith(
                  color: etbalyColors.textMain,
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(height: 4.h),
              Text(
                widget.invoiceDate,
                style: context.textTheme.bodySmall
                    ?.copyWith(color: etbalyColors.textMuted),
              ),
              SizedBox(height: 4.h),
              Container(
                padding:
                    EdgeInsets.symmetric(horizontal: 8.w, vertical: 4.h),
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

  // ── Client details ────────────────────────────────────────────────────────

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
          GridView.count(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            crossAxisCount: 2,
            childAspectRatio: 2.5,
            mainAxisSpacing: 12.r,
            crossAxisSpacing: 12.r,
            children: [
              _buildClientItem(
                  'Name', widget.clientName, etbalyColors, context),
              _buildClientItem(
                  'Mobile', widget.clientMobile, etbalyColors, context),
              _buildClientItem(
                  'WhatsApp', widget.clientWhatsApp, etbalyColors, context),
              _buildClientItem(
                  'Email', widget.clientEmail, etbalyColors, context),
              if (widget.companyName != null)
                _buildClientItem(
                    'Company', widget.companyName!, etbalyColors, context),
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

  // ── Order table ───────────────────────────────────────────────────────────

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
          DecoratedBox(
            decoration: BoxDecoration(
              color: etbalyColors.bgSubtle,
              borderRadius:
                  BorderRadius.circular(designTokens.borderRadiusMedium),
              border: Border.all(color: etbalyColors.borderSubtle, width: 1.w),
            ),
            child: Column(
              children: [
                // Header row
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
                          child: Text('Service',
                              style: context.textTheme.labelSmall?.copyWith(
                                  color: etbalyColors.primary,
                                  fontWeight: FontWeight.bold))),
                      Expanded(
                          flex: 1,
                          child: Text('Qty',
                              textAlign: TextAlign.center,
                              style: context.textTheme.labelSmall?.copyWith(
                                  color: etbalyColors.primary,
                                  fontWeight: FontWeight.bold))),
                      Expanded(
                          flex: 2,
                          child: Text('Unit Price',
                              textAlign: TextAlign.end,
                              style: context.textTheme.labelSmall?.copyWith(
                                  color: etbalyColors.primary,
                                  fontWeight: FontWeight.bold))),
                      Expanded(
                          flex: 2,
                          child: Text('Total',
                              textAlign: TextAlign.end,
                              style: context.textTheme.labelSmall?.copyWith(
                                  color: etbalyColors.primary,
                                  fontWeight: FontWeight.bold))),
                    ],
                  ),
                ),
                // Item rows
                ...widget.items.map(
                    (item) => _buildTableRow(context, item, etbalyColors)),
                // Grand total
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
                        child: Text('Grand Total',
                            style: context.textTheme.titleSmall?.copyWith(
                                color: etbalyColors.gold,
                                fontWeight: FontWeight.bold)),
                      ),
                      Expanded(
                        flex: 2,
                        child: Text(
                          '${_grandTotal.toStringAsFixed(2)} EGP',
                          textAlign: TextAlign.end,
                          style: context.textTheme.titleSmall?.copyWith(
                              color: etbalyColors.gold,
                              fontWeight: FontWeight.bold),
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
            bottom: BorderSide(color: etbalyColors.borderSubtle, width: 1.w)),
      ),
      child: Row(
        children: [
          Expanded(
              flex: 3,
              child: Text(item.name,
                  style: context.textTheme.bodyMedium
                      ?.copyWith(color: etbalyColors.textMain))),
          Expanded(
            flex: 1,
            child: Container(
              padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 4.h),
              decoration: BoxDecoration(
                color: etbalyColors.badgeBg,
                borderRadius: BorderRadius.circular(8.r),
              ),
              child: Text('${item.quantity}',
                  textAlign: TextAlign.center,
                  style: context.textTheme.labelSmall?.copyWith(
                      color: etbalyColors.primary,
                      fontWeight: FontWeight.w600)),
            ),
          ),
          Expanded(
              flex: 2,
              child: Text('${item.unitPrice.toStringAsFixed(2)} EGP',
                  textAlign: TextAlign.end,
                  style: context.textTheme.bodyMedium
                      ?.copyWith(color: etbalyColors.textMain))),
          Expanded(
              flex: 2,
              child: Text('${item.total.toStringAsFixed(2)} EGP',
                  textAlign: TextAlign.end,
                  style: context.textTheme.bodyMedium?.copyWith(
                      color: etbalyColors.textMain,
                      fontWeight: FontWeight.w600))),
        ],
      ),
    );
  }

  // ── Footer ────────────────────────────────────────────────────────────────

  Widget _buildFooter(BuildContext context,
      EtbalyColorsExtension etbalyColors, AppDesignTokens designTokens) {
    return Padding(
      padding: EdgeInsets.all(24.r),
      child: Row(
        children: [
          Icon(Icons.favorite, color: etbalyColors.gold, size: 16.sp),
          SizedBox(width: 8.w),
          Text(
            'Thank you for your trust — Etbaly Services',
            style: context.textTheme.bodySmall
                ?.copyWith(color: etbalyColors.textMuted),
          ),
        ],
      ),
    );
  }

  // ── Actions ───────────────────────────────────────────────────────────────

  Widget _buildActions(BuildContext context,
      EtbalyColorsExtension etbalyColors, AppDesignTokens designTokens) {
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
              onPressed: _isExporting ? null : _exportAsImage,
              icon: _isExporting
                  ? SizedBox(
                      width: 16.w,
                      height: 16.h,
                      child: const CircularProgressIndicator(
                          strokeWidth: 2, color: Colors.black),
                    )
                  : const Icon(Icons.download_rounded),
              label: Text(_isExporting ? 'جاري الحفظ...' : 'تحميل صورة'),
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
              onPressed: _sendProofByEmail,
              icon: const Icon(Icons.email_rounded),
              label: const Text('إيميل'),
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
              onPressed: _sendProofByWhatsApp,
              icon: const Icon(Icons.message_rounded),
              label: const Text('واتساب'),
              style: OutlinedButton.styleFrom(
                foregroundColor: const Color(0xFF25D366),
                side: const BorderSide(color: Color(0xFF25D366)),
                padding: EdgeInsets.symmetric(vertical: 12.h),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// ── InvoiceItem model ─────────────────────────────────────────────────────────

class InvoiceItem {
  const InvoiceItem({
    required this.name,
    required this.quantity,
    required this.unitPrice,
  });

  final String name;
  final int quantity;
  final double unitPrice;

  double get total => quantity * unitPrice;
}
