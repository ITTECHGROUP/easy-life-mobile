import 'package:flutter_dotenv/flutter_dotenv.dart';

class Constants {
  static const String noImageURL =
      'https://easy-life-dashboard.s3.amazonaws.com/uploads/no-image.jpeg';

  static String baseUrl = dotenv.get('API_URL', fallback: 'http://localhost:8000');
}
