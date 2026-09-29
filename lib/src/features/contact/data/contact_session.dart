import 'package:shared_preferences/shared_preferences.dart';

/// A package the visitor picked on the services tab ("Contact us" in the order
/// sheet). The contact form shows it and sends it with the message, like the
/// website's `selected_package` session entry.
class SelectedPackage {
  const SelectedPackage({
    required this.name,
    required this.category,
    this.price,
    this.isCustom = false,
  });

  final String name;
  final String category;

  /// Plain number as sent to the form endpoint; null for on-request packages.
  final String? price;
  final bool isCustom;
}

/// The contact form's state that has to survive leaving the page (e.g. going to
/// pick a different package) — the website keeps it in `sessionStorage`.
class ContactDraft {
  const ContactDraft({
    this.name = '',
    this.email = '',
    this.phone = '',
    this.whatsapp = '',
    this.business = '',
    this.specialty = '',
    this.message = '',
  });

  final String name;
  final String email;
  final String phone;
  final String whatsapp;
  final String business;
  final String specialty;
  final String message;
}

class ContactSession {
  ContactSession._();

  /// Set by the package sheet right before it opens the contact page and
  /// consumed by the form.
  static SelectedPackage? pendingPackage;

  /// The package currently attached to the form (kept while the form is away).
  static SelectedPackage? package;
  static ContactDraft draft = const ContactDraft();

  static void clear() {
    pendingPackage = null;
    package = null;
    draft = const ContactDraft();
  }

  // ── Cooldown between two submissions ─────────────────────────────────────

  static const cooldown = Duration(minutes: 5);
  static const _lastSubmitKey = 'contact_last_submit';

  /// Time left before another message may be sent, or [Duration.zero].
  static Future<Duration> remainingCooldown() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final last = prefs.getInt(_lastSubmitKey);
      if (last == null) return Duration.zero;
      final elapsed = DateTime.now().millisecondsSinceEpoch - last;
      final left = cooldown.inMilliseconds - elapsed;
      return left > 0 ? Duration(milliseconds: left) : Duration.zero;
    } catch (_) {
      return Duration.zero;
    }
  }

  static Future<void> recordSubmit() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setInt(
        _lastSubmitKey,
        DateTime.now().millisecondsSinceEpoch,
      );
    } catch (_) {
      // The cooldown is a courtesy limit; losing it is harmless.
    }
  }
}
