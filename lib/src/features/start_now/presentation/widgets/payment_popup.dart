import 'dart:convert';
import 'dart:io';
import 'dart:ui' as ui;

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:image_picker/image_picker.dart';
import 'package:open_filex/open_filex.dart';
import 'package:path_provider/path_provider.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../../../extensions/context_extension.dart';
import '../../../../shared/widgets/etbaly_invoice.dart';

// ── Constants ─────────────────────────────────────────────────────────────────

const _receiptApiUrl = 'https://etba3ly-dm.com/api-email/send-receipt.php';
const _supportEmail = 'support@etba3ly-dm.com';
const _whatsappNumber = '+201010285020';
const _vodafone1 = '01010285020';
const _vodafone2 = '01003628888';
const _instaAddress = 'MASRAWY.2024@instapay';
const _bankAccount = '2305000886592101011';
const _bankIban = 'EG060003023050008865921010110';
const _bankSwift = 'NBEGEGCX230';

// ── Entry point ───────────────────────────────────────────────────────────────

Future<void> showPaymentPopup(
  BuildContext context, {
  required String invoiceNumber,
  required String invoiceDate,
  required String clientName,
  required String clientMobile,
  required String clientWhatsApp,
  required String clientEmail,
  required String serviceName,
  required List<InvoiceItem> items,
  String? companyName,
}) {
  return showDialog<void>(
    context: context,
    barrierDismissible: false,
    builder: (_) => _PaymentPopup(
      invoiceNumber: invoiceNumber,
      invoiceDate: invoiceDate,
      clientName: clientName,
      clientMobile: clientMobile,
      clientWhatsApp: clientWhatsApp,
      clientEmail: clientEmail,
      serviceName: serviceName,
      items: items,
      companyName: companyName,
    ),
  );
}

// ═════════════════════════════════════════════════════════════════════════════
// Main popup widget
// ═════════════════════════════════════════════════════════════════════════════

class _PaymentPopup extends StatefulWidget {
  const _PaymentPopup({
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
  State<_PaymentPopup> createState() => _PaymentPopupState();
}

class _PaymentPopupState extends State<_PaymentPopup> {
  int _tab = 0;

  XFile? _transferProof;
  XFile? _invoiceProof;
  bool _emailSending = false;
  bool _emailSent = false;
  bool _emailError = false;
  String? _copiedKey;

  bool get _ar => context.locale.languageCode == 'ar';

  // ── Tab definitions ───────────────────────────────────────────────────────

  static const _tabDefs = [
    (Icons.receipt_long_rounded, 'الفاتورة', 'Invoice'),
    (Icons.credit_card_rounded, 'طرق الدفع', 'Pay Methods'),
    (Icons.send_rounded, 'إرسال الإثبات', 'Send Proof'),
  ];

  // ── Copy ──────────────────────────────────────────────────────────────────

  Future<void> _copy(String value, String key) async {
    await Clipboard.setData(ClipboardData(text: value));
    setState(() => _copiedKey = key);
    await Future<void>.delayed(const Duration(seconds: 2));
    if (mounted) setState(() => _copiedKey = null);
  }

  // ── Image picker ──────────────────────────────────────────────────────────

  Future<void> _pick(bool isTransfer) async {
    final file = await ImagePicker()
        .pickImage(source: ImageSource.gallery, imageQuality: 85);
    if (file == null) return;
    setState(() {
      if (isTransfer) {
        _transferProof = file;
      } else {
        _invoiceProof = file;
      }
      _emailSent = false;
      _emailError = false;
    });
  }

  // ── Send proof by email ───────────────────────────────────────────────────

  Future<void> _sendByEmail() async {
    if (_transferProof == null || _invoiceProof == null || _emailSending) {
      return;
    }
    setState(() {
      _emailSending = true;
      _emailError = false;
    });
    try {
      final t = await File(_transferProof!.path).readAsBytes();
      final inv = await File(_invoiceProof!.path).readAsBytes();

      final subject = _ar
          ? 'إثبات دفع + فاتورة — ${widget.clientName}'
          : 'Payment Proof & Invoice — ${widget.clientName}';

      final body = _ar
          ? 'مرحباً،\nبيانات العميل:\nالاسم: ${widget.clientName}\n'
              'الموبايل: ${widget.clientMobile}\nواتساب: ${widget.clientWhatsApp}\n'
              'الإيميل: ${widget.clientEmail}\nفاتورة رقم: ${widget.invoiceNumber}\n\n'
              'أرفق صورة التحويل وصورة الفاتورة — برجاء تفعيل الخدمة.'
          : 'Hello,\nClient Details:\nName: ${widget.clientName}\n'
              'Mobile: ${widget.clientMobile}\nWhatsApp: ${widget.clientWhatsApp}\n'
              'Email: ${widget.clientEmail}\nInvoice #: ${widget.invoiceNumber}\n\n'
              'Please find the transfer screenshot and invoice attached. '
              'Kindly activate the service.';

      final payload = jsonEncode({
        'subject': subject,
        'body': body,
        'attachment1': base64Encode(t),
        'filename1': _transferProof!.name,
        'attachment2': base64Encode(inv),
        'filename2': _invoiceProof!.name,
        'clientData': {
          'fullName': widget.clientName,
          'mobile': widget.clientMobile,
          'whatsapp': widget.clientWhatsApp,
          'email': widget.clientEmail,
        },
      });

      final client = HttpClient();
      final req = await client.postUrl(Uri.parse(_receiptApiUrl));
      req.headers.contentType = ContentType.json;
      final encoded = utf8.encode(payload);
      req.contentLength = encoded.length;
      req.add(encoded);
      final res = await req.close();
      if (res.statusCode >= 400) throw Exception('HTTP ${res.statusCode}');
      setState(() => _emailSent = true);
    } catch (_) {
      setState(() => _emailError = true);
    } finally {
      if (mounted) setState(() => _emailSending = false);
    }
  }

  // ── WhatsApp ──────────────────────────────────────────────────────────────

  Future<void> _openWhatsApp() async {
    final msg = _ar
        ? 'مرحباً، إثبات الدفع — ${widget.clientName} — فاتورة رقم ${widget.invoiceNumber}'
        : 'Hello, Payment Proof — ${widget.clientName} — Invoice #${widget.invoiceNumber}';
    await launchUrl(
      Uri.parse('https://wa.me/$_whatsappNumber?text=${Uri.encodeComponent(msg)}'),
      mode: LaunchMode.externalApplication,
    );
  }

  // ── Build ─────────────────────────────────────────────────────────────────

  @override
  Widget build(BuildContext context) {
    final colors = context.etbalyColors;
    return Dialog.fullscreen(
      backgroundColor: colors.bgMain,
      child: Column(
        children: [
          _buildHeader(colors),
          _buildTabBar(colors),
          Expanded(child: _buildContent()),
        ],
      ),
    );
  }

  Widget _buildHeader(dynamic colors) {
    return Container(
      padding: EdgeInsets.only(
        top: MediaQuery.of(context).padding.top + 8.h,
        bottom: 12.h,
        left: 16.w,
        right: 16.w,
      ),
      decoration: BoxDecoration(
        color: colors.bgCard,
        border: Border(bottom: BorderSide(color: colors.borderSubtle)),
      ),
      child: Row(
        children: [
          IconButton(
            icon: Icon(Icons.close_rounded,
                color: colors.textMuted, size: 22.sp),
            onPressed: () => Navigator.of(context).pop(),
          ),
          SizedBox(width: 8.w),
          Expanded(
            child: Text(
              _ar ? 'إتمام الدفع' : 'Complete Payment',
              style: TextStyle(
                color: colors.textMain,
                fontWeight: FontWeight.bold,
                fontSize: 17.sp,
              ),
            ),
          ),
          Container(
            padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 4.h),
            decoration: BoxDecoration(
              color: colors.gold.withValues(alpha: 0.12),
              borderRadius: BorderRadius.circular(20.r),
            ),
            child: Text(
              '#${widget.invoiceNumber}',
              style: TextStyle(
                  color: colors.gold,
                  fontWeight: FontWeight.bold,
                  fontSize: 12.sp),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTabBar(dynamic colors) {
    return Container(
      color: colors.bgCard,
      padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 8.h),
      child: Row(
        children: List.generate(_tabDefs.length, (i) {
          final active = _tab == i;
          final def = _tabDefs[i];
          return Expanded(
            child: GestureDetector(
              onTap: () => setState(() => _tab = i),
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 200),
                margin: EdgeInsets.symmetric(horizontal: 4.w),
                padding:
                    EdgeInsets.symmetric(vertical: 10.h, horizontal: 4.w),
                decoration: BoxDecoration(
                  color: active
                      ? colors.gold.withValues(alpha: 0.12)
                      : Colors.transparent,
                  borderRadius: BorderRadius.circular(10.r),
                  border: Border.all(
                    color: active ? colors.gold : colors.borderSubtle,
                  ),
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(def.$1,
                        size: 18.sp,
                        color: active ? colors.gold : colors.textMuted),
                    SizedBox(height: 4.h),
                    Text(
                      _ar ? def.$2 : def.$3,
                      style: TextStyle(
                        fontSize: 10.sp,
                        fontWeight:
                            active ? FontWeight.w700 : FontWeight.w500,
                        color: active ? colors.gold : colors.textMuted,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ],
                ),
              ),
            ),
          );
        }),
      ),
    );
  }

  Widget _buildContent() {
    return switch (_tab) {
      0 => _buildInvoiceTab(),
      1 => _buildMethodsTab(),
      2 => _buildProofTab(),
      _ => const SizedBox.shrink(),
    };
  }

  // ══════════════════════════════════════════════════════════════════════════
  // TAB 1 — INVOICE
  // ══════════════════════════════════════════════════════════════════════════

  Widget _buildInvoiceTab() {
    final colors = context.etbalyColors;
    return SingleChildScrollView(
      padding: EdgeInsets.all(16.r),
      child: Column(
        children: [
          _InvoiceCard(
            invoiceNumber: widget.invoiceNumber,
            invoiceDate: widget.invoiceDate,
            clientName: widget.clientName,
            clientMobile: widget.clientMobile,
            clientWhatsApp: widget.clientWhatsApp,
            clientEmail: widget.clientEmail,
            serviceName: widget.serviceName,
            items: widget.items,
            companyName: widget.companyName,
          ),
          SizedBox(height: 16.h),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton.icon(
              onPressed: () => setState(() => _tab = 1),
              icon: Icon(Icons.credit_card_rounded, size: 18.sp),
              label: Text(_ar ? 'طرق الدفع ←' : 'Payment Methods →'),
              style: ElevatedButton.styleFrom(
                backgroundColor: colors.gold,
                foregroundColor: Colors.black,
                padding: EdgeInsets.symmetric(vertical: 14.h),
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12.r)),
              ),
            ),
          ),
        ],
      ),
    );
  }

  // ══════════════════════════════════════════════════════════════════════════
  // TAB 2 — PAYMENT METHODS
  // ══════════════════════════════════════════════════════════════════════════

  Widget _buildMethodsTab() {
    final colors = context.etbalyColors;
    return SingleChildScrollView(
      padding: EdgeInsets.all(16.r),
      child: Column(
        children: [
          _PayCard(
            color: const Color(0xFFE60012),
            title: 'Vodafone Cash',
            icon: Icons.phone_android_rounded,
            fields: [
              _PayField(_ar ? 'الرقم الأول' : 'Number 1', _vodafone1, 'vf1'),
              _PayField(_ar ? 'الرقم الثاني' : 'Number 2', _vodafone2, 'vf2'),
            ],
            copiedKey: _copiedKey,
            onCopy: _copy,
          ),
          SizedBox(height: 12.h),
          _PayCard(
            color: const Color(0xFF00B8D9),
            title: 'InstaPay',
            icon: Icons.flash_on_rounded,
            fields: [
              _PayField(
                  _ar ? 'عنوان InstaPay' : 'InstaPay Address',
                  _instaAddress,
                  'ip'),
            ],
            copiedKey: _copiedKey,
            onCopy: _copy,
          ),
          SizedBox(height: 12.h),
          _PayCard(
            color: const Color(0xFF1A3C6E),
            title: _ar ? 'تحويل بنكي' : 'Bank Transfer',
            icon: Icons.account_balance_rounded,
            fields: [
              _PayField(
                  _ar ? 'رقم الحساب' : 'Account Number', _bankAccount, 'ba'),
              const _PayField('IBAN', _bankIban, 'ib'),
              const _PayField('SWIFT', _bankSwift, 'sw'),
            ],
            copiedKey: _copiedKey,
            onCopy: _copy,
          ),
          SizedBox(height: 16.h),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton.icon(
              onPressed: () => setState(() => _tab = 2),
              icon: Icon(Icons.send_rounded, size: 18.sp),
              label: Text(_ar ? 'إرسال الإثبات ←' : 'Send Proof →'),
              style: ElevatedButton.styleFrom(
                backgroundColor: colors.gold,
                foregroundColor: Colors.black,
                padding: EdgeInsets.symmetric(vertical: 14.h),
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12.r)),
              ),
            ),
          ),
        ],
      ),
    );
  }

  // ══════════════════════════════════════════════════════════════════════════
  // TAB 3 — SEND PROOF
  // ══════════════════════════════════════════════════════════════════════════

  Widget _buildProofTab() {
    final colors = context.etbalyColors;
    final bothReady = _transferProof != null && _invoiceProof != null;

    return SingleChildScrollView(
      padding: EdgeInsets.all(16.r),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Client summary
          _SummaryCard(
            clientName: widget.clientName,
            clientMobile: widget.clientMobile,
            clientWhatsApp: widget.clientWhatsApp,
            clientEmail: widget.clientEmail,
          ),
          SizedBox(height: 16.h),

          // Section label
          Text(
            _ar ? 'الصور المطلوبة' : 'Required Images',
            style: TextStyle(
                color: colors.textMain,
                fontWeight: FontWeight.bold,
                fontSize: 14.sp),
          ),
          SizedBox(height: 10.h),

          // Two upload zones
          Row(
            children: [
              Expanded(
                child: _UploadZone(
                  label: _ar ? 'صورة التحويل' : 'Transfer Screenshot',
                  icon: Icons.receipt_long_rounded,
                  file: _transferProof,
                  onTap: () => _pick(true),
                  onRemove: () => setState(() {
                    _transferProof = null;
                    _emailSent = false;
                  }),
                ),
              ),
              SizedBox(width: 12.w),
              Expanded(
                child: _UploadZone(
                  label: _ar ? 'صورة الفاتورة' : 'Invoice Photo',
                  icon: Icons.file_present_rounded,
                  file: _invoiceProof,
                  onTap: () => _pick(false),
                  onRemove: () => setState(() {
                    _invoiceProof = null;
                    _emailSent = false;
                  }),
                ),
              ),
            ],
          ),

          if (!bothReady) ...[
            SizedBox(height: 12.h),
            _InfoBanner(
              message: _ar
                  ? 'يجب رفع الصورتين معاً لتفعيل الخدمة'
                  : 'Both images are required to activate your service',
              color: colors.primary,
            ),
          ],

          if (bothReady) ...[
            SizedBox(height: 20.h),
            Text(
              _ar ? 'إرسال سريع' : 'Quick Send',
              style: TextStyle(
                  color: colors.textMain,
                  fontWeight: FontWeight.bold,
                  fontSize: 14.sp),
            ),
            SizedBox(height: 10.h),
            _SendButton(
              icon: _emailSending
                  ? Icons.hourglass_top_rounded
                  : _emailSent
                      ? Icons.check_circle_rounded
                      : Icons.email_rounded,
              label: _ar ? 'إرسال بالإيميل' : 'Send by Email',
              subLabel: _supportEmail,
              color: colors.primary,
              loading: _emailSending,
              success: _emailSent,
              onTap: _emailSending ? null : _sendByEmail,
            ),
            SizedBox(height: 10.h),
            _SendButton(
              icon: Icons.chat_rounded,
              label: _ar ? 'إرسال بالواتساب' : 'Send via WhatsApp',
              subLabel: _whatsappNumber,
              color: const Color(0xFF25D366),
              loading: false,
              success: false,
              onTap: _openWhatsApp,
            ),
          ],

          if (_emailSent) ...[
            SizedBox(height: 16.h),
            _StatusBanner(
              icon: Icons.check_circle_rounded,
              color: const Color(0xFF22C55E),
              title: _ar ? 'تم الإرسال بنجاح!' : 'Sent successfully!',
              subtitle: _ar
                  ? 'لا تنسى الإرسال عبر الواتساب أيضاً'
                  : 'Also send via WhatsApp for fastest activation',
            ),
          ],

          if (_emailError) ...[
            SizedBox(height: 16.h),
            _StatusBanner(
              icon: Icons.warning_rounded,
              color: Colors.red,
              title: _ar ? 'تعذّر الإرسال بالإيميل' : 'Email sending failed',
              subtitle: _ar
                  ? 'أرسل الصور عبر الواتساب بدلاً من ذلك'
                  : 'Please send images via WhatsApp instead',
            ),
          ],

          SizedBox(height: 24.h),
        ],
      ),
    );
  }
}

// ═════════════════════════════════════════════════════════════════════════════
// Inline invoice card (no dialog wrapper, with download button)
// ═════════════════════════════════════════════════════════════════════════════

class _InvoiceCard extends StatefulWidget {
  const _InvoiceCard({
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
  State<_InvoiceCard> createState() => _InvoiceCardState();
}

class _InvoiceCardState extends State<_InvoiceCard> {
  final GlobalKey _repaintKey = GlobalKey();
  bool _isExporting = false;

  bool get _ar => context.locale.languageCode == 'ar';

  double get _grandTotal =>
      widget.items.fold(0, (sum, item) => sum + item.total);

  // ── Export ────────────────────────────────────────────────────────────────

  Future<void> _exportAsImage() async {
    if (_isExporting) return;
    setState(() => _isExporting = true);
    try {
      await Future<void>.delayed(const Duration(milliseconds: 100));

      final boundary = _repaintKey.currentContext?.findRenderObject()
          as RenderRepaintBoundary?;
      if (boundary == null) throw Exception('boundary not found');

      final image = await boundary.toImage(pixelRatio: 3);
      final byteData = await image.toByteData(format: ui.ImageByteFormat.png);
      if (byteData == null) throw Exception('encode failed');

      final bytes = Uint8List.view(byteData.buffer);
      final dir = await getDownloadsDirectory() ??
          await getApplicationDocumentsDirectory();
      final filePath =
          '${dir.path}/invoice_${widget.invoiceNumber}.png';
      await File(filePath).writeAsBytes(bytes, flush: true);

      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
              _ar ? 'تم الحفظ بنجاح' : 'Saved successfully'),
          backgroundColor: context.etbalyColors.gold,
          action: SnackBarAction(
            label: _ar ? 'فتح' : 'Open',
            textColor: Colors.black,
            onPressed: () => OpenFilex.open(filePath),
          ),
        ),
      );
    } catch (_) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(_ar ? 'فشل التصدير' : 'Export failed'),
          backgroundColor: Colors.red,
        ),
      );
    } finally {
      if (mounted) setState(() => _isExporting = false);
    }
  }

  // ── Build ─────────────────────────────────────────────────────────────────

  @override
  Widget build(BuildContext context) {
    final colors = context.etbalyColors;
    return RepaintBoundary(
      key: _repaintKey,
      child: DecoratedBox(
        decoration: BoxDecoration(
          color: colors.bgCard,
          borderRadius: BorderRadius.circular(16.r),
          border: Border.all(
              color: colors.borderColor.withValues(alpha: 0.3)),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            _buildHeader(colors),
            // Gold bar
            Container(
              height: 3.h,
              margin: EdgeInsets.symmetric(horizontal: 20.w),
              decoration: BoxDecoration(
                gradient: LinearGradient(colors: [
                  colors.goldLight,
                  colors.gold,
                  colors.goldDark,
                ]),
                borderRadius: BorderRadius.circular(2.r),
              ),
            ),
            _buildClientSection(colors),
            _buildItemsTable(colors),
            _buildFooterRow(colors),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader(dynamic colors) {
    return Padding(
      padding: EdgeInsets.all(16.r),
      child: Row(
        children: [
          Container(
            width: 42.w,
            height: 42.h,
            decoration: BoxDecoration(
              color: colors.badgeBg,
              borderRadius: BorderRadius.circular(10.r),
            ),
            child: Icon(Icons.receipt_long,
                color: colors.primary, size: 22.sp),
          ),
          SizedBox(width: 12.w),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(widget.serviceName,
                    style: TextStyle(
                        color: colors.textMain,
                        fontWeight: FontWeight.bold,
                        fontSize: 14.sp)),
                Text('Etbaly Services',
                    style:
                        TextStyle(color: colors.textMuted, fontSize: 11.sp)),
              ],
            ),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text('#${widget.invoiceNumber}',
                  style: TextStyle(
                      color: colors.textMain,
                      fontWeight: FontWeight.bold,
                      fontSize: 12.sp)),
              Text(widget.invoiceDate,
                  style:
                      TextStyle(color: colors.textMuted, fontSize: 10.sp)),
              SizedBox(height: 4.h),
              Container(
                padding:
                    EdgeInsets.symmetric(horizontal: 8.w, vertical: 3.h),
                decoration: BoxDecoration(
                  color: colors.gold.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(10.r),
                ),
                child: Text(
                  _ar ? 'في انتظار الدفع' : 'Pending Payment',
                  style: TextStyle(
                      color: colors.gold,
                      fontSize: 9.sp,
                      fontWeight: FontWeight.w600),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildClientSection(dynamic colors) {
    final fields = [
      (_ar ? 'الاسم' : 'Name', widget.clientName),
      (_ar ? 'الموبايل' : 'Mobile', widget.clientMobile),
      if (widget.clientEmail.isNotEmpty)
        (_ar ? 'الإيميل' : 'Email', widget.clientEmail),
      if (widget.companyName != null)
        (_ar ? 'الشركة' : 'Company', widget.companyName!),
    ];

    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.h),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(_ar ? 'بيانات العميل' : 'Client Details',
              style: TextStyle(
                  color: colors.textMain,
                  fontWeight: FontWeight.w600,
                  fontSize: 12.sp)),
          SizedBox(height: 8.h),
          Wrap(
            spacing: 16.w,
            runSpacing: 6.h,
            children: fields
                .map((f) => SizedBox(
                      width:
                          (MediaQuery.of(context).size.width - 80.w) / 2,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(f.$1,
                              style: TextStyle(
                                  color: colors.textMuted, fontSize: 10.sp)),
                          Text(f.$2,
                              style: TextStyle(
                                  color: colors.textMain,
                                  fontWeight: FontWeight.w500,
                                  fontSize: 11.sp)),
                        ],
                      ),
                    ))
                .toList(),
          ),
        ],
      ),
    );
  }

  Widget _buildItemsTable(dynamic colors) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.h),
      child: DecoratedBox(
        decoration: BoxDecoration(
          color: colors.bgSubtle,
          borderRadius: BorderRadius.circular(10.r),
          border: Border.all(color: colors.borderSubtle),
        ),
        child: Column(
          children: [
            // Header
            Container(
              padding:
                  EdgeInsets.symmetric(horizontal: 12.w, vertical: 8.h),
              decoration: BoxDecoration(
                color: colors.primary.withValues(alpha: 0.1),
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(10.r),
                  topRight: Radius.circular(10.r),
                ),
              ),
              child: Row(
                children: [
                  Expanded(
                      flex: 3,
                      child: Text(_ar ? 'الخدمة' : 'Service',
                          style: TextStyle(
                              color: colors.primary,
                              fontWeight: FontWeight.bold,
                              fontSize: 11.sp))),
                  SizedBox(
                    width: 36.w,
                    child: Text(_ar ? 'كمية' : 'Qty',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                            color: colors.primary,
                            fontWeight: FontWeight.bold,
                            fontSize: 11.sp)),
                  ),
                  Expanded(
                      flex: 2,
                      child: Text(_ar ? 'الإجمالي' : 'Total',
                          textAlign: TextAlign.end,
                          style: TextStyle(
                              color: colors.primary,
                              fontWeight: FontWeight.bold,
                              fontSize: 11.sp))),
                ],
              ),
            ),
            // Rows
            ...widget.items.map((item) => Container(
                  padding:
                      EdgeInsets.symmetric(horizontal: 12.w, vertical: 8.h),
                  decoration: BoxDecoration(
                    border: Border(
                        bottom: BorderSide(
                            color: colors.borderSubtle, width: 1)),
                  ),
                  child: Row(
                    children: [
                      Expanded(
                          flex: 3,
                          child: Text(item.name,
                              style: TextStyle(
                                  color: colors.textMain, fontSize: 11.sp))),
                      SizedBox(
                        width: 36.w,
                        child: Container(
                          padding: EdgeInsets.symmetric(
                              horizontal: 6.w, vertical: 2.h),
                          decoration: BoxDecoration(
                            color: colors.badgeBg,
                            borderRadius: BorderRadius.circular(6.r),
                          ),
                          child: Text('${item.quantity}',
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                  color: colors.primary,
                                  fontWeight: FontWeight.w600,
                                  fontSize: 10.sp)),
                        ),
                      ),
                      Expanded(
                        flex: 2,
                        child: Text(
                          item.total > 0
                              ? '${item.total.toStringAsFixed(0)} ج.م'
                              : (_ar ? 'يحدد لاحقاً' : 'TBD'),
                          textAlign: TextAlign.end,
                          style: TextStyle(
                              color: colors.textMain,
                              fontWeight: FontWeight.w600,
                              fontSize: 11.sp),
                        ),
                      ),
                    ],
                  ),
                )),
            // Grand total
            Container(
              padding:
                  EdgeInsets.symmetric(horizontal: 12.w, vertical: 10.h),
              decoration: BoxDecoration(
                color: colors.gold.withValues(alpha: 0.1),
                borderRadius: BorderRadius.only(
                  bottomLeft: Radius.circular(10.r),
                  bottomRight: Radius.circular(10.r),
                ),
              ),
              child: Row(
                children: [
                  Expanded(
                    child: Text(_ar ? 'الإجمالي الكلي' : 'Grand Total',
                        style: TextStyle(
                            color: colors.gold,
                            fontWeight: FontWeight.bold,
                            fontSize: 12.sp)),
                  ),
                  Text(
                    _grandTotal > 0
                        ? '${_grandTotal.toStringAsFixed(0)} ج.م'
                        : (_ar ? 'يحدد بعد المراجعة' : 'TBD after review'),
                    style: TextStyle(
                        color: colors.gold,
                        fontWeight: FontWeight.bold,
                        fontSize: 12.sp),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildFooterRow(dynamic colors) {
    return Padding(
      padding: EdgeInsets.all(16.r),
      child: Row(
        children: [
          Icon(Icons.favorite, color: colors.gold, size: 13.sp),
          SizedBox(width: 6.w),
          Expanded(
            child: Text(
              _ar
                  ? 'شكراً لثقتك — اضبعلي للتسويق الرقمي'
                  : 'Thank you for your trust — Etbaly Digital Marketing',
              style: TextStyle(color: colors.textMuted, fontSize: 10.sp),
            ),
          ),
          SizedBox(width: 8.w),
          GestureDetector(
            onTap: _exportAsImage,
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 200),
              padding:
                  EdgeInsets.symmetric(horizontal: 12.w, vertical: 6.h),
              decoration: BoxDecoration(
                color: _isExporting
                    ? colors.gold.withValues(alpha: 0.3)
                    : colors.gold,
                borderRadius: BorderRadius.circular(8.r),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  if (_isExporting)
                    SizedBox(
                      width: 12.w,
                      height: 12.h,
                      child: const CircularProgressIndicator(
                          strokeWidth: 2, color: Colors.black),
                    )
                  else
                    Icon(Icons.download_rounded,
                        color: Colors.black, size: 14.sp),
                  SizedBox(width: 4.w),
                  Text(
                    _ar ? 'تحميل' : 'Save',
                    style: TextStyle(
                        color: Colors.black,
                        fontWeight: FontWeight.bold,
                        fontSize: 11.sp),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// ═════════════════════════════════════════════════════════════════════════════
// Reusable small widgets
// ═════════════════════════════════════════════════════════════════════════════

class _PayField {
  const _PayField(this.label, this.value, this.key);
  final String label;
  final String value;
  final String key;
}

// ── Payment method card ───────────────────────────────────────────────────────

class _PayCard extends StatelessWidget {
  const _PayCard({
    required this.color,
    required this.title,
    required this.icon,
    required this.fields,
    required this.copiedKey,
    required this.onCopy,
  });

  final Color color;
  final String title;
  final IconData icon;
  final List<_PayField> fields;
  final String? copiedKey;
  final Future<void> Function(String, String) onCopy;

  @override
  Widget build(BuildContext context) {
    final colors = context.etbalyColors;
    final ar = context.locale.languageCode == 'ar';

    return DecoratedBox(
      decoration: BoxDecoration(
        color: colors.bgCard,
        borderRadius: BorderRadius.circular(14.r),
        border: Border.all(color: color.withValues(alpha: 0.25)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.h),
            decoration: BoxDecoration(
              color: color.withValues(alpha: 0.08),
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(14.r),
                topRight: Radius.circular(14.r),
              ),
            ),
            child: Row(
              children: [
                Icon(icon, color: color, size: 20.sp),
                SizedBox(width: 8.w),
                Text(title,
                    style: TextStyle(
                        color: color,
                        fontWeight: FontWeight.bold,
                        fontSize: 14.sp)),
              ],
            ),
          ),
          Padding(
            padding: EdgeInsets.all(14.r),
            child: Column(
              children: fields.map((f) {
                final copied = copiedKey == f.key;
                return Padding(
                  padding: EdgeInsets.only(bottom: 8.h),
                  child: Row(
                    children: [
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(f.label,
                                style: TextStyle(
                                    color: colors.textMuted,
                                    fontSize: 11.sp)),
                            SizedBox(height: 2.h),
                            Text(f.value,
                                style: TextStyle(
                                    color: colors.textMain,
                                    fontWeight: FontWeight.w600,
                                    fontSize: 13.sp)),
                          ],
                        ),
                      ),
                      GestureDetector(
                        onTap: () => onCopy(f.value, f.key),
                        child: AnimatedContainer(
                          duration: const Duration(milliseconds: 200),
                          padding: EdgeInsets.symmetric(
                              horizontal: 10.w, vertical: 6.h),
                          decoration: BoxDecoration(
                            color: copied
                                ? const Color(0xFF22C55E)
                                    .withValues(alpha: 0.12)
                                : colors.bgSubtle,
                            borderRadius: BorderRadius.circular(8.r),
                          ),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Icon(
                                copied
                                    ? Icons.check_rounded
                                    : Icons.copy_rounded,
                                size: 14.sp,
                                color: copied
                                    ? const Color(0xFF22C55E)
                                    : colors.textMuted,
                              ),
                              SizedBox(width: 4.w),
                              Text(
                                copied
                                    ? (ar ? 'تم' : 'Copied')
                                    : (ar ? 'نسخ' : 'Copy'),
                                style: TextStyle(
                                    fontSize: 11.sp,
                                    color: copied
                                        ? const Color(0xFF22C55E)
                                        : colors.textMuted),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                );
              }).toList(),
            ),
          ),
        ],
      ),
    );
  }
}

// ── Upload zone ───────────────────────────────────────────────────────────────

class _UploadZone extends StatelessWidget {
  const _UploadZone({
    required this.label,
    required this.icon,
    required this.file,
    required this.onTap,
    required this.onRemove,
  });

  final String label;
  final IconData icon;
  final XFile? file;
  final VoidCallback onTap;
  final VoidCallback onRemove;

  @override
  Widget build(BuildContext context) {
    final colors = context.etbalyColors;
    final ar = context.locale.languageCode == 'ar';
    final hasFile = file != null;

    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        height: 130.h,
        decoration: BoxDecoration(
          color:
              hasFile ? colors.primary.withValues(alpha: 0.06) : colors.bgCard,
          borderRadius: BorderRadius.circular(12.r),
          border: Border.all(
            color: hasFile
                ? colors.primary.withValues(alpha: 0.4)
                : colors.borderSubtle,
            width: 1.5,
          ),
        ),
        child: hasFile
            ? Stack(
                children: [
                  ClipRRect(
                    borderRadius: BorderRadius.circular(11.r),
                    child: Image.file(
                      File(file!.path),
                      fit: BoxFit.cover,
                      width: double.infinity,
                      height: double.infinity,
                    ),
                  ),
                  Positioned(
                    top: 6.h,
                    right: 6.w,
                    child: GestureDetector(
                      onTap: onRemove,
                      child: Container(
                        padding: EdgeInsets.all(4.r),
                        decoration: const BoxDecoration(
                          color: Colors.black54,
                          shape: BoxShape.circle,
                        ),
                        child: Icon(Icons.close_rounded,
                            color: Colors.white, size: 14.sp),
                      ),
                    ),
                  ),
                ],
              )
            : Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(icon, color: colors.textMuted, size: 28.sp),
                  SizedBox(height: 8.h),
                  Text(label,
                      textAlign: TextAlign.center,
                      style: TextStyle(
                          color: colors.textMuted,
                          fontSize: 11.sp,
                          fontWeight: FontWeight.w500)),
                  SizedBox(height: 4.h),
                  Text(
                    ar ? 'اضغط للاختيار' : 'Tap to select',
                    style: TextStyle(
                        color: colors.textMuted.withValues(alpha: 0.6),
                        fontSize: 10.sp),
                  ),
                ],
              ),
      ),
    );
  }
}

// ── Send button ───────────────────────────────────────────────────────────────

class _SendButton extends StatelessWidget {
  const _SendButton({
    required this.icon,
    required this.label,
    required this.subLabel,
    required this.color,
    required this.loading,
    required this.success,
    required this.onTap,
  });

  final IconData icon;
  final String label;
  final String subLabel;
  final Color color;
  final bool loading;
  final bool success;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final colors = context.etbalyColors;
    final activeColor = success ? const Color(0xFF22C55E) : color;

    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 14.h),
        decoration: BoxDecoration(
          color: activeColor.withValues(alpha: 0.08),
          borderRadius: BorderRadius.circular(12.r),
          border: Border.all(color: activeColor.withValues(alpha: 0.3)),
        ),
        child: Row(
          children: [
            Container(
              width: 40.w,
              height: 40.h,
              decoration: BoxDecoration(
                color: activeColor.withValues(alpha: 0.15),
                shape: BoxShape.circle,
              ),
              child: loading
                  ? Padding(
                      padding: EdgeInsets.all(10.r),
                      child: CircularProgressIndicator(
                          strokeWidth: 2, color: color),
                    )
                  : Icon(icon, color: activeColor, size: 20.sp),
            ),
            SizedBox(width: 12.w),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(label,
                      style: TextStyle(
                          color: colors.textMain,
                          fontWeight: FontWeight.bold,
                          fontSize: 13.sp)),
                  Text(subLabel,
                      style: TextStyle(
                          color: colors.textMuted, fontSize: 11.sp)),
                ],
              ),
            ),
            Icon(Icons.arrow_forward_ios_rounded,
                color: colors.textMuted, size: 14.sp),
          ],
        ),
      ),
    );
  }
}

// ── Client summary card ───────────────────────────────────────────────────────

class _SummaryCard extends StatelessWidget {
  const _SummaryCard({
    required this.clientName,
    required this.clientMobile,
    required this.clientWhatsApp,
    required this.clientEmail,
  });

  final String clientName;
  final String clientMobile;
  final String clientWhatsApp;
  final String clientEmail;

  @override
  Widget build(BuildContext context) {
    final colors = context.etbalyColors;
    final ar = context.locale.languageCode == 'ar';

    final fields = [
      (ar ? 'الاسم' : 'Name', clientName),
      (ar ? 'الموبايل' : 'Mobile', clientMobile),
      (ar ? 'واتساب' : 'WhatsApp', clientWhatsApp),
      if (clientEmail.isNotEmpty) (ar ? 'الإيميل' : 'Email', clientEmail),
    ];

    return Container(
      padding: EdgeInsets.all(14.r),
      decoration: BoxDecoration(
        color: colors.bgCard,
        borderRadius: BorderRadius.circular(12.r),
        border: Border.all(color: colors.borderSubtle),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(Icons.person_rounded, color: colors.primary, size: 16.sp),
              SizedBox(width: 6.w),
              Text(ar ? 'بيانات العميل' : 'Client Information',
                  style: TextStyle(
                      color: colors.textMain,
                      fontWeight: FontWeight.bold,
                      fontSize: 13.sp)),
            ],
          ),
          SizedBox(height: 10.h),
          ...fields.map((f) => Padding(
                padding: EdgeInsets.only(bottom: 6.h),
                child: Row(
                  children: [
                    SizedBox(
                      width: 80.w,
                      child: Text(f.$1,
                          style: TextStyle(
                              color: colors.textMuted, fontSize: 12.sp)),
                    ),
                    Expanded(
                      child: Text(f.$2,
                          style: TextStyle(
                              color: colors.textMain,
                              fontWeight: FontWeight.w500,
                              fontSize: 12.sp)),
                    ),
                  ],
                ),
              )),
        ],
      ),
    );
  }
}

// ── Info banner ───────────────────────────────────────────────────────────────

class _InfoBanner extends StatelessWidget {
  const _InfoBanner({required this.message, required this.color});

  final String message;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 10.h),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.08),
        borderRadius: BorderRadius.circular(10.r),
      ),
      child: Row(
        children: [
          Icon(Icons.info_outline_rounded, color: color, size: 16.sp),
          SizedBox(width: 8.w),
          Expanded(
            child: Text(message,
                style: TextStyle(color: color, fontSize: 12.sp)),
          ),
        ],
      ),
    );
  }
}

// ── Status banner (success / error) ──────────────────────────────────────────

class _StatusBanner extends StatelessWidget {
  const _StatusBanner({
    required this.icon,
    required this.color,
    required this.title,
    required this.subtitle,
  });

  final IconData icon;
  final Color color;
  final String title;
  final String subtitle;

  @override
  Widget build(BuildContext context) {
    final textMuted = context.etbalyColors.textMuted;

    return Container(
      padding: EdgeInsets.all(14.r),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.08),
        borderRadius: BorderRadius.circular(12.r),
        border: Border.all(color: color.withValues(alpha: 0.25)),
      ),
      child: Row(
        children: [
          Icon(icon, color: color, size: 20.sp),
          SizedBox(width: 10.w),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title,
                    style: TextStyle(
                        color: color,
                        fontWeight: FontWeight.bold,
                        fontSize: 13.sp)),
                Text(subtitle,
                    style:
                        TextStyle(color: textMuted, fontSize: 11.sp)),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
