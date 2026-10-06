import 'package:etbaly/src/features/careers/presentation/widgets/birthday_field.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  final today = DateTime(2026, 10, 6);

  group('birthdayIso', () {
    test('accepts a real date', () {
      expect(birthdayIso('15', '03', '1999', today), '1999-03-15');
      expect(birthdayIso('5', '3', '1999', today), '1999-03-05');
    });

    test('rejects unfinished or impossible dates', () {
      expect(birthdayIso('', '03', '1999', today), '');
      expect(birthdayIso('15', '03', '199', today), '');
      expect(birthdayIso('31', '02', '1999', today), '');
      expect(birthdayIso('29', '02', '2001', today), '');
      expect(birthdayIso('15', '13', '1999', today), '');
    });

    test('accepts a leap day only in a leap year', () {
      expect(birthdayIso('29', '02', '2000', today), '2000-02-29');
    });

    test('rejects the future and dates over 120 years ago', () {
      expect(birthdayIso('07', '10', '2026', today), '');
      expect(birthdayIso('06', '10', '2026', today), '2026-10-06');
      expect(birthdayIso('01', '01', '1900', today), '');
    });
  });

  group('birthdayAge', () {
    test('counts whole years, birthday included', () {
      expect(birthdayAge('2000-10-06', today), 26);
      expect(birthdayAge('2000-10-07', today), 25);
      expect(birthdayAge('2000-10-05', today), 26);
    });

    test('is null for bad input', () {
      expect(birthdayAge('', today), isNull);
      expect(birthdayAge(null, today), isNull);
      expect(birthdayAge('1999-02-30', today), isNull);
      expect(birthdayAge('2027-01-01', today), isNull);
    });
  });

  group('validApplicantBirthDate', () {
    test('allows 18 to 40 inclusive', () {
      expect(validApplicantBirthDate('2008-10-06', today), isTrue); // turns 18 today
      expect(validApplicantBirthDate('2008-10-07', today), isFalse); // 17
      expect(validApplicantBirthDate('1985-10-07', today), isTrue); // still 40
    });

    test('rejects 41 and over', () {
      expect(validApplicantBirthDate('1985-10-06', today), isFalse);
      expect(validApplicantBirthDate('', today), isFalse);
    });
  });

  group('birthdaySign', () {
    test('matches the website zodiac boundaries', () {
      expect(birthdaySign('1999-03-15', arabic: false), contains('Pisces'));
      expect(birthdaySign('1999-03-21', arabic: false), contains('Aries'));
      expect(birthdaySign('1999-12-25', arabic: true), contains('الجدي'));
      expect(birthdaySign('1999-01-05', arabic: true), contains('الجدي'));
    });
  });

  test('latinDigitsOnly converts Arabic-Indic digits and drops the rest', () {
    expect(latinDigitsOnly('١٥/٠٣-۱۹۹۹'), '15031999');
    expect(latinDigitsOnly('ab12'), '12');
  });
}
