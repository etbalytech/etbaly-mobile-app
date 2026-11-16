import 'package:dio/dio.dart';

/// Applicant-facing errors never claim that an unconfirmed submission was saved.
class CareerSubmissionErrors {
  const CareerSubmissionErrors._();

  static String message({
    required bool isArabic,
    int? status,
    Map<String, dynamic>? body,
    bool partialUpload = false,
    bool timedOut = false,
  }) {
    final reference = '${body?['reference'] ?? ''}'.trim();
    final suffix = reference.isEmpty
        ? ''
        : ' (${isArabic ? 'رقم المتابعة' : 'Reference'}: $reference)';
    if (partialUpload) {
      return (isArabic
              ? 'لم نتمكن من تأكيد استلام الطلب كاملًا. اترك الصفحة مفتوحة واضغط إرسال مرة أخرى؛ لن يتكرر الطلب إذا كان قد وصل.'
              : 'We could not confirm receipt of the complete application. Keep this page open and press Send again; an application already received will not be duplicated.') +
          suffix;
    }
    final serverError = body?['error'];
    if (serverError is String && serverError.trim().isNotEmpty) {
      final text = serverError.trim();
      return reference.isNotEmpty && !text.contains(reference)
          ? text + suffix
          : text;
    }
    if (status == 413) {
      return isArabic
          ? 'حجم الملفات أكبر من المسموح على السيرفر. صغّر الصور أو ملف PDF ثم أعد الإرسال.'
          : 'The attachments exceed the server upload limit. Reduce their sizes and try again.';
    }
    if (timedOut || status == 408 || status == 504) {
      return isArabic
          ? 'استغرق رفع الطلب وقتًا أطول من المتوقع ولم نتمكن من تأكيد وصوله. اترك الصفحة مفتوحة، وتأكد من الإنترنت وحجم المرفقات، ثم اضغط إرسال مرة أخرى.'
          : 'Uploading took too long, so we could not confirm receipt. Keep this page open, check your connection and attachment sizes, then press Send again.';
    }
    if (status == 429) {
      return isArabic
          ? 'تم إرسال محاولات كثيرة في وقت قصير. اترك الصفحة مفتوحة وانتظر قليلًا، ثم اضغط إرسال مرة أخرى.'
          : 'Too many attempts were made. Keep this page open, wait a little, and press Send again.';
    }
    if (status == 403) {
      return isArabic
          ? 'رفض خادم التوظيف استلام الطلب. اترك الصفحة مفتوحة وتواصل مع الإدارة للمساعدة.'
          : 'The careers server declined the request. Keep this page open and contact the team for help.';
    }
    if (status != null && status >= 200 && status < 300) {
      return isArabic
          ? 'وصل رد غير واضح من خادم التوظيف، ولم نتمكن من تأكيد استلام طلبك. اترك الصفحة مفتوحة واضغط إرسال مرة أخرى، أو تواصل مع الإدارة.'
          : 'The server returned an unclear response. Keep this page open and press Send again, or contact the team.';
    }
    if (status != null && status >= 500) {
      return isArabic
          ? 'تعذر حفظ الطلب على السيرفر حاليًا. حاول مرة أخرى بعد قليل.'
          : 'The server could not save the application right now. Please try again shortly.';
    }
    return isArabic
        ? 'انقطع الاتصال أو لم يستجب خادم التوظيف، لذلك لم نتمكن من تأكيد وصول طلبك. اترك الصفحة مفتوحة، وتأكد من الإنترنت ثم اضغط إرسال مرة أخرى. لو استمرت المشكلة تواصل مع الإدارة.'
        : 'The connection was interrupted or the server did not respond, so we could not confirm receipt. Keep this page open, check your connection, and press Send again. Contact the team if the issue continues.';
  }

  static bool isTimeout(DioExceptionType type) =>
      type == DioExceptionType.connectionTimeout ||
      type == DioExceptionType.sendTimeout ||
      type == DioExceptionType.receiveTimeout;
}
