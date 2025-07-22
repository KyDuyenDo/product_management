import 'dart:convert';
import 'dart:typed_data';
import 'package:http/http.dart' as http;

class ImgBBUploadService {
  static const String _apiKey = "dd5391cce15b83cbb25c9f0cfe6ce724";

  Future<dynamic> uploadImage(Uint8List bytes, String filename) async {
    try {
      final base64Image = base64Encode(bytes);
      final url = Uri.parse("https://api.imgbb.com/1/upload");

      final response = await http.post(
        url,
        body: {'key': _apiKey, 'image': base64Image, 'name': filename},
      );

      if (response.statusCode == 200) {
        final jsonData = jsonDecode(response.body);
        if (jsonData['success'] == true) {
          final imageUrl = jsonData['data']['url'];
          return {'location': imageUrl};
        }
      }

      return null;
    } catch (e) {
      return null;
    }
  }
}
