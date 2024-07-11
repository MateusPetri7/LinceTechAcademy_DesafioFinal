import 'package:http/http.dart' as http;

/// A class for performing HTTP GET requests using the `http` package.
class HttpClient {
  /// The HTTP client instance from the `http` package.
  final client = http.Client();

  /// Performs a GET request to the specified [url].
  Future get({required String url}) async {
    return await client.get(Uri.parse(url));
  }
}