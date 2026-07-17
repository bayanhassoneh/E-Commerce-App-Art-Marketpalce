import 'package:flutter/material.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'dart:async';

class InternetCheckerWrapper extends StatefulWidget {
  final Widget child;
  const InternetCheckerWrapper({super.key, required this.child});
  @override
  State<InternetCheckerWrapper> createState() => _InternetCheckerWrapperState();
}

class _InternetCheckerWrapperState extends State<InternetCheckerWrapper> {
  bool _isOffline = false;
  Timer? _DebounceTimer;

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<List<ConnectivityResult>>(
      stream: Connectivity().onConnectivityChanged,
      builder: (context, snapshot) {
        // Handle the connectivity status here
        final connectivityResult = snapshot.data;

        if (connectivityResult != null) {
          if (connectivityResult.contains(ConnectivityResult.none)) {
            if (_DebounceTimer == null || !_DebounceTimer!.isActive) {
              _DebounceTimer = Timer(const Duration(seconds: 2), () {
                setState(() {
                  _isOffline = true;
                });
              });
            }
          } else {
            _DebounceTimer?.cancel();
            if (_isOffline) {
              WidgetsBinding.instance.addPostFrameCallback((_) {
                setState(() {
                  _isOffline = false;
                });
              });
            }
          }
        }

        if (_isOffline) {
          return const Scaffold(
            body: Center(
              child: Column(
                children: [
                  Icon(Icons.signal_wifi_off, size: 80, color: Colors.grey),
                  SizedBox(height: 20),
                  Text(
                    'No Internet Connection',
                    style: TextStyle(
                      fontSize: 18,
                      color: Colors.grey,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Text(
                    'Please check your network settings.',
                    style: TextStyle(fontSize: 16, color: Colors.grey),
                  ),
                ],
              ),
            ),
          );
        }
        return widget.child;
      },
    );
  }

  @override
  void dispose() {
    _DebounceTimer?.cancel();
    super.dispose();
  }
}
