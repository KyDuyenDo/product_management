import 'dart:io';

abstract class NetworkInfo {
  Future<bool> get isConnected;
}

class NetworkInfoImpl implements NetworkInfo {
  @override
  Future<bool> get isConnected async {
    try {
      print('NetworkInfo: Testing network connection...');

      // Test kết nối đến Google DNS
      final result = await InternetAddress.lookup(
        'google.com',
      ).timeout(const Duration(seconds: 5));

      if (result.isNotEmpty && result[0].rawAddress.isNotEmpty) {
        print('NetworkInfo: Network connection confirmed');
        return true;
      }

      print('NetworkInfo: No network connection');
      return false;
    } catch (e) {
      print('NetworkInfo: Network test failed: $e');
      return false;
    }
  }
}
