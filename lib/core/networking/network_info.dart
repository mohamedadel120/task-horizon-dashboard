import 'dart:async';
import 'dart:io';
import 'package:connectivity_plus/connectivity_plus.dart';

/// Network connectivity information and monitoring
class NetworkInfo {
  final Connectivity _connectivity;
  StreamSubscription<List<ConnectivityResult>>? _connectivitySubscription;
  final StreamController<bool> _connectionStatusController =
      StreamController<bool>.broadcast();

  NetworkInfo({Connectivity? connectivity})
    : _connectivity = connectivity ?? Connectivity();

  /// Check if device is connected to internet
  Future<bool> get isConnected async {
    try {
      final connectivityResults = await _connectivity.checkConnectivity();

      // If no connectivity, return false immediately
      if (connectivityResults.contains(ConnectivityResult.none)) {
        return false;
      }

      // Double check with actual network request
      return await _hasInternetAccess();
    } catch (e) {
      return false;
    }
  }

  /// Get current connectivity type
  Future<ConnectivityResult> get connectivityType async {
    try {
      final results = await _connectivity.checkConnectivity();
      // Return the first non-none result, or none if all are none
      return results.firstWhere(
        (result) => result != ConnectivityResult.none,
        orElse: () => ConnectivityResult.none,
      );
    } catch (e) {
      return ConnectivityResult.none;
    }
  }

  /// Get all current connectivity types
  Future<List<ConnectivityResult>> get connectivityTypes async {
    try {
      return await _connectivity.checkConnectivity();
    } catch (e) {
      return [ConnectivityResult.none];
    }
  }

  /// Check if connected via WiFi
  Future<bool> get isWiFiConnected async {
    final types = await connectivityTypes;
    return types.contains(ConnectivityResult.wifi);
  }

  /// Check if connected via Mobile Data
  Future<bool> get isMobileConnected async {
    final types = await connectivityTypes;
    return types.contains(ConnectivityResult.mobile);
  }

  /// Check if connected via Ethernet
  Future<bool> get isEthernetConnected async {
    final types = await connectivityTypes;
    return types.contains(ConnectivityResult.ethernet);
  }

  /// Stream of connectivity changes
  Stream<List<ConnectivityResult>> get onConnectivityChanged {
    return _connectivity.onConnectivityChanged;
  }

  /// Stream of internet connection status (true/false)
  Stream<bool> get onConnectionStatusChanged {
    return _connectionStatusController.stream;
  }

  /// Start monitoring connectivity changes
  void startMonitoring() {
    _connectivitySubscription?.cancel();
    _connectivitySubscription = _connectivity.onConnectivityChanged.listen((
      List<ConnectivityResult> results,
    ) async {
      final hasConnection =
          !results.contains(ConnectivityResult.none) &&
          await _hasInternetAccess();
      _connectionStatusController.add(hasConnection);
    });
  }

  /// Stop monitoring connectivity changes
  void stopMonitoring() {
    _connectivitySubscription?.cancel();
    _connectivitySubscription = null;
  }

  /// Actually test internet access by making a network request
  Future<bool> _hasInternetAccess() async {
    try {
      // Try to connect to multiple reliable endpoints
      final endpoints = [
        'google.com',
        'cloudflare.com',
        '8.8.8.8', // Google DNS
      ];

      for (final endpoint in endpoints) {
        try {
          final result = await InternetAddress.lookup(
            endpoint,
          ).timeout(const Duration(seconds: 5));

          if (result.isNotEmpty && result[0].rawAddress.isNotEmpty) {
            return true;
          }
        } catch (e) {
          // Continue to next endpoint
          continue;
        }
      }

      return false;
    } catch (e) {
      return false;
    }
  }

  /// Test internet speed by downloading a small file
  Future<NetworkSpeed> testNetworkSpeed() async {
    try {
      if (!await isConnected) {
        return NetworkSpeed.none;
      }

      final stopwatch = Stopwatch()..start();

      // Use a small test endpoint - you might want to replace this with your own
      final client = HttpClient();
      final request = await client.getUrl(
        Uri.parse('https://httpbin.org/bytes/1024'), // 1KB test
      );
      request.headers.set('Cache-Control', 'no-cache');

      final response = await request.close().timeout(
        const Duration(seconds: 10),
      );

      if (response.statusCode == 200) {
        await response.drain();
        stopwatch.stop();

        final milliseconds = stopwatch.elapsedMilliseconds;

        // Rough speed categorization based on 1KB download time
        if (milliseconds < 500) {
          return NetworkSpeed.fast;
        } else if (milliseconds < 2000) {
          return NetworkSpeed.medium;
        } else {
          return NetworkSpeed.slow;
        }
      }

      return NetworkSpeed.unknown;
    } catch (e) {
      return NetworkSpeed.unknown;
    }
  }

  /// Get network information summary
  Future<NetworkSummary> getNetworkSummary() async {
    return NetworkSummary(
      isConnected: await isConnected,
      connectivityTypes: await connectivityTypes,
      isWiFi: await isWiFiConnected,
      isMobile: await isMobileConnected,
      isEthernet: await isEthernetConnected,
      speed: await testNetworkSpeed(),
    );
  }

  /// Dispose resources
  void dispose() {
    stopMonitoring();
    _connectionStatusController.close();
  }
}

/// Network speed categories
enum NetworkSpeed { none, slow, medium, fast, unknown }

/// Network information summary
class NetworkSummary {
  final bool isConnected;
  final List<ConnectivityResult> connectivityTypes;
  final bool isWiFi;
  final bool isMobile;
  final bool isEthernet;
  final NetworkSpeed speed;

  const NetworkSummary({
    required this.isConnected,
    required this.connectivityTypes,
    required this.isWiFi,
    required this.isMobile,
    required this.isEthernet,
    required this.speed,
  });

  @override
  String toString() {
    return 'NetworkSummary('
        'isConnected: $isConnected, '
        'types: $connectivityTypes, '
        'wifi: $isWiFi, '
        'mobile: $isMobile, '
        'ethernet: $isEthernet, '
        'speed: $speed'
        ')';
  }
}

/// Extension for prettier connectivity result names
extension ConnectivityResultExtension on ConnectivityResult {
  String get displayName {
    switch (this) {
      case ConnectivityResult.wifi:
        return 'WiFi';
      case ConnectivityResult.mobile:
        return 'Mobile Data';
      case ConnectivityResult.ethernet:
        return 'Ethernet';
      case ConnectivityResult.vpn:
        return 'VPN';
      case ConnectivityResult.bluetooth:
        return 'Bluetooth';
      case ConnectivityResult.other:
        return 'Other';
      case ConnectivityResult.none:
        return 'No Connection';
    }
  }
}

