import 'package:dio/dio.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:etbaly/src/features/careers/logic/submission_errors.dart';

void main() {
  test('connection and timeout messages do not claim an unconfirmed save', () {
    final connection =
        CareerSubmissionErrors.message(isArabic: true, status: 0);
    final timeout =
        CareerSubmissionErrors.message(isArabic: true, timedOut: true);
    expect(connection, contains('لم نتمكن من تأكيد'));
    expect(timeout, contains('حجم المرفقات'));
    expect(connection, isNot(contains('تم استلام')));
    expect(CareerSubmissionErrors.isTimeout(DioExceptionType.receiveTimeout),
        isTrue);
    expect(CareerSubmissionErrors.isTimeout(DioExceptionType.connectionError),
        isFalse);
  });

  test('specific statuses and API references are preserved', () {
    expect(CareerSubmissionErrors.message(isArabic: true, status: 413),
        contains('حجم'));
    expect(CareerSubmissionErrors.message(isArabic: true, status: 429),
        contains('انتظر'));
    expect(CareerSubmissionErrors.message(isArabic: true, status: 403),
        contains('الإدارة'));
    expect(CareerSubmissionErrors.message(isArabic: false, status: 504),
        contains('took too long'));
    expect(
        CareerSubmissionErrors.message(
            isArabic: true,
            status: 503,
            body: {'error': 'السيرفر مشغول', 'reference': 'abc123'}),
        contains('abc123'));
    expect(
        CareerSubmissionErrors.message(
            isArabic: true, status: 400, partialUpload: true),
        contains('لن يتكرر'));
  });
}
