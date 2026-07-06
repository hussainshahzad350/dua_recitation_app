/// English UI strings, keyed by a stable identifier.
///
/// Content (the duas themselves) lives in JSON; these are only the app's
/// chrome/labels. Keep keys in sync with [urStrings].
const Map<String, String> enStrings = <String, String>{
  'app_name': 'Dua Companion',
  'app_tagline': 'Authentic duas after every Salah',

  // Home
  'home_prayers_title': 'After Salah',
  'home_explore_title': 'Explore',
  'important_duas': 'Important Duas',
  'favorites': 'Favorites',
  'search': 'Search',
  'settings': 'Settings',

  // Prayers
  'prayer_fajr': 'Fajr',
  'prayer_dhuhr': 'Dhuhr',
  'prayer_asr': 'Asr',
  'prayer_maghrib': 'Maghrib',
  'prayer_isha': 'Isha',
  'prayer_duas_title': 'Duas after {prayer}',

  // Dua card
  'play': 'Play',
  'stop': 'Stop',
  'reference': 'Reference',
  'add_favorite': 'Add to favorites',
  'remove_favorite': 'Remove from favorites',
  'share': 'Share',
  'repeat': 'Repeat',

  // Reference sheet
  'reference_title': 'Reference',
  'source_book': 'Source Book',
  'hadith_collection': 'Collection',
  'hadith_number': 'Number',
  'authenticity': 'Authenticity',
  'full_hadith': 'Full Text',
  'full_hadith_unavailable':
      'Full text is not bundled. Please verify in the cited source.',

  // Search
  'search_hint': 'Search Arabic, English, Urdu, category…',
  'search_prompt': 'Start typing to search duas.',
  'no_results': 'No duas found.',

  // Empty states
  'favorites_empty': 'You have not added any favorites yet.',
  'category_empty': 'No duas in this category yet.',

  // Settings
  'settings_language': 'Language',
  'settings_theme': 'Theme',
  'theme_system': 'System',
  'theme_light': 'Light',
  'theme_dark': 'Dark',
  'settings_arabic_font': 'Arabic Font Size',
  'settings_translation_font': 'Translation Font Size',
  'settings_show_transliteration': 'Show Transliteration',
  'settings_about': 'About',
  'settings_sources': 'Sources',
  'settings_privacy': 'Privacy Policy',
  'language_english': 'English',
  'language_urdu': 'اردو',
  'settings_preview': 'Preview',

  // About / Sources / Privacy
  'about_body':
      'Dua Companion is a lightweight, offline-first app to help you recite '
          'authentic duas after Salah without needing to memorize them. It is '
          'deliberately simple: no accounts, no ads, no tracking.',
  'sources_body':
      'Duas are primarily compiled from Hisnul Muslim (Fortress of the Muslim) '
          'and cross-referenced with Sahih al-Bukhari, Sahih Muslim, Sunan Abi '
          'Dawud, Jami\' at-Tirmidhi and Sunan an-Nasa\'i. Every dua carries its '
          'reference. Please verify all content against the original sources '
          'before relying on it.',
  'privacy_body':
      'This app collects no personal data. There are no accounts, no analytics, '
          'and no network requests during normal use. Your favorites and '
          'settings are stored only on your device.',

  // Audio
  'audio_unavailable': 'Audio is not available yet for this dua.',
  'audio_error': 'Could not play audio.',

  // Verification banner
  'verify_note':
      'Content is provided for review. Verify authenticity before public '
          'release.',
};

/// Urdu UI strings. Keys mirror [enStrings].
const Map<String, String> urStrings = <String, String>{
  'app_name': 'دعا کمپینین',
  'app_tagline': 'ہر نماز کے بعد مستند دعائیں',

  'home_prayers_title': 'نماز کے بعد',
  'home_explore_title': 'مزید',
  'important_duas': 'اہم دعائیں',
  'favorites': 'پسندیدہ',
  'search': 'تلاش',
  'settings': 'ترتیبات',

  'prayer_fajr': 'فجر',
  'prayer_dhuhr': 'ظہر',
  'prayer_asr': 'عصر',
  'prayer_maghrib': 'مغرب',
  'prayer_isha': 'عشاء',
  'prayer_duas_title': '{prayer} کے بعد کی دعائیں',

  'play': 'سنیں',
  'stop': 'روکیں',
  'reference': 'حوالہ',
  'add_favorite': 'پسندیدہ میں شامل کریں',
  'remove_favorite': 'پسندیدہ سے نکالیں',
  'share': 'شیئر کریں',
  'repeat': 'تکرار',

  'reference_title': 'حوالہ',
  'source_book': 'کتاب',
  'hadith_collection': 'مجموعہ',
  'hadith_number': 'نمبر',
  'authenticity': 'درجہ',
  'full_hadith': 'مکمل متن',
  'full_hadith_unavailable':
      'مکمل متن شامل نہیں ہے۔ براہِ کرم مذکورہ ماخذ میں تصدیق کریں۔',

  'search_hint': 'عربی، انگریزی، اردو، زمرہ تلاش کریں…',
  'search_prompt': 'دعائیں تلاش کرنے کے لیے لکھنا شروع کریں۔',
  'no_results': 'کوئی دعا نہیں ملی۔',

  'favorites_empty': 'ابھی تک کوئی پسندیدہ دعا شامل نہیں کی گئی۔',
  'category_empty': 'اس زمرے میں ابھی کوئی دعا نہیں ہے۔',

  'settings_language': 'زبان',
  'settings_theme': 'تھیم',
  'theme_system': 'سسٹم',
  'theme_light': 'روشن',
  'theme_dark': 'گہرا',
  'settings_arabic_font': 'عربی متن کا سائز',
  'settings_translation_font': 'ترجمہ کا سائز',
  'settings_show_transliteration': 'رومن متن دکھائیں',
  'settings_about': 'ایپ کے بارے میں',
  'settings_sources': 'مآخذ',
  'settings_privacy': 'رازداری کی پالیسی',
  'language_english': 'English',
  'language_urdu': 'اردو',
  'settings_preview': 'نمونہ',

  'about_body':
      'دعا کمپینین ایک ہلکی پھلکی، آف لائن ایپ ہے جو آپ کو نماز کے بعد مستند '
          'دعائیں یاد کیے بغیر پڑھنے میں مدد دیتی ہے۔ نہ اکاؤنٹ، نہ اشتہار، نہ '
          'ٹریکنگ۔',
  'sources_body':
      'دعائیں بنیادی طور پر حصنِ مسلم سے لی گئی ہیں اور صحیح بخاری، صحیح مسلم، '
          'سنن ابی داؤد، جامع ترمذی اور سنن نسائی سے تصدیق کی گئی ہے۔ ہر دعا کے '
          'ساتھ اس کا حوالہ موجود ہے۔ استعمال سے پہلے اصل مآخذ سے تصدیق کریں۔',
  'privacy_body':
      'یہ ایپ کوئی ذاتی معلومات جمع نہیں کرتی۔ نہ کوئی اکاؤنٹ، نہ اینالٹکس، اور '
          'عام استعمال میں کوئی انٹرنیٹ درخواست نہیں۔ آپ کی پسندیدہ دعائیں اور '
          'ترتیبات صرف آپ کے آلے پر محفوظ رہتی ہیں۔',

  'audio_unavailable': 'اس دعا کے لیے آڈیو ابھی دستیاب نہیں ہے۔',
  'audio_error': 'آڈیو نہیں چل سکی۔',

  'verify_note':
      'مواد جائزے کے لیے فراہم کیا گیا ہے۔ عوامی اجرا سے پہلے صداقت کی تصدیق کریں۔',
};
