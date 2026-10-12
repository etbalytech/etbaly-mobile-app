import 'dart:typed_data';

/// The careers API only accepts JPEG, PNG and WEBP and checks the file content,
/// not its name. A photo from an iPhone is often HEIC; the image picker converts
/// it to JPEG but can leave the `.heic` name, so the format is read from the
/// bytes and the name is corrected to match.
///
/// Returns `jpg`, `png` or `webp`, or null for anything else (a HEIC that was
/// not converted, a GIF, a text file renamed to `.jpg`...).
String? detectImageExtension(Uint8List bytes) {
  if (bytes.length >= 3 && bytes[0] == 0xFF && bytes[1] == 0xD8 && bytes[2] == 0xFF) {
    return 'jpg';
  }
  if (bytes.length >= 8 &&
      bytes[0] == 0x89 &&
      bytes[1] == 0x50 &&
      bytes[2] == 0x4E &&
      bytes[3] == 0x47 &&
      bytes[4] == 0x0D &&
      bytes[5] == 0x0A &&
      bytes[6] == 0x1A &&
      bytes[7] == 0x0A) {
    return 'png';
  }
  // RIFF....WEBP
  if (bytes.length >= 12 &&
      bytes[0] == 0x52 &&
      bytes[1] == 0x49 &&
      bytes[2] == 0x46 &&
      bytes[3] == 0x46 &&
      bytes[8] == 0x57 &&
      bytes[9] == 0x45 &&
      bytes[10] == 0x42 &&
      bytes[11] == 0x50) {
    return 'webp';
  }
  return null;
}

/// [name] with its extension replaced by [extension] (added when it has none).
String withImageExtension(String name, String extension) {
  final dot = name.lastIndexOf('.');
  final base = dot > 0 ? name.substring(0, dot) : name;
  return '${base.isEmpty ? 'image' : base}.$extension';
}
