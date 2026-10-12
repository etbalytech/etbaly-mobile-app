import 'dart:typed_data';

import 'package:etbaly/src/features/careers/data/image_format.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  Uint8List b(List<int> v) => Uint8List.fromList(v);

  group('detectImageExtension', () {
    test('recognises JPEG, PNG and WEBP by their first bytes', () {
      expect(detectImageExtension(b([0xFF, 0xD8, 0xFF, 0xE0, 0, 0x10])), 'jpg');
      expect(
        detectImageExtension(b([0x89, 0x50, 0x4E, 0x47, 0x0D, 0x0A, 0x1A, 0x0A, 0, 0])),
        'png',
      );
      expect(
        detectImageExtension(b([0x52, 0x49, 0x46, 0x46, 1, 2, 3, 4, 0x57, 0x45, 0x42, 0x50])),
        'webp',
      );
    });

    test('rejects HEIC, GIF, empty and truncated data', () {
      // ....ftypheic
      expect(
        detectImageExtension(b([0, 0, 0, 0x18, 0x66, 0x74, 0x79, 0x70, 0x68, 0x65, 0x69, 0x63])),
        isNull,
      );
      expect(detectImageExtension(b([0x47, 0x49, 0x46, 0x38, 0x39, 0x61])), isNull);
      expect(detectImageExtension(b([])), isNull);
      expect(detectImageExtension(b([0xFF, 0xD8])), isNull);
      // RIFF but not WEBP (a WAV file)
      expect(
        detectImageExtension(b([0x52, 0x49, 0x46, 0x46, 1, 2, 3, 4, 0x57, 0x41, 0x56, 0x45])),
        isNull,
      );
    });
  });

  group('withImageExtension', () {
    test('replaces a wrong extension', () {
      expect(withImageExtension('scaled_IMG_0042.heic', 'jpg'), 'scaled_IMG_0042.jpg');
      expect(withImageExtension('photo.final.HEIC', 'jpg'), 'photo.final.jpg');
    });

    test('adds one when missing and handles odd names', () {
      expect(withImageExtension('photo', 'png'), 'photo.png');
      expect(withImageExtension('.hidden', 'jpg'), '.hidden.jpg');
      expect(withImageExtension('', 'webp'), 'image.webp');
    });
  });
}
