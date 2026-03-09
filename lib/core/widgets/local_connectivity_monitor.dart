import 'dart:async';
import 'package:flutter/material.dart';
import 'package:connectivity_plus/connectivity_plus.dart';

class ConnectivityMonitor extends StatefulWidget {
  final Widget child;
  final Widget? customDisconnectedWidget;
  final Widget? customDialog;

  const ConnectivityMonitor({
    super.key,
    required this.child,
    this.customDisconnectedWidget,
    this.customDialog,
  });

  @override
  State<ConnectivityMonitor> createState() => _ConnectivityMonitorState();
}

class _ConnectivityMonitorState extends State<ConnectivityMonitor> {
  late StreamSubscription _subscription;
  bool _isConnected = true;
  bool _dialogShown = false;

  @override
  void initState() {
    super.initState();
    _checkInitialConnection();
    _subscription =
        Connectivity().onConnectivityChanged.listen(_handleConnectivityChange);
  }

  Future<void> _checkInitialConnection() async {
    final result = await Connectivity().checkConnectivity();
    _handleConnectivityChange(result);
  }

  void _handleConnectivityChange(dynamic result) {
    if (!mounted) return;

    bool isConnected;
    if (result is List<ConnectivityResult>) {
      isConnected =
          !result.contains(ConnectivityResult.none) && result.isNotEmpty;
    } else if (result is ConnectivityResult) {
      isConnected = result != ConnectivityResult.none;
    } else {
      isConnected = true;
    }

    if (_isConnected != isConnected) {
      if (mounted) {
        setState(() {
          _isConnected = isConnected;
        });
      }

      if (!isConnected && widget.customDialog != null && !_dialogShown) {
        _dialogShown = true;
        showDialog(
          context: context,
          barrierDismissible: false, // Force them to handle it if offline
          builder: (context) {
            return WillPopScope(
              onWillPop: () async =>
                  false, // Dialog can't be popped natively easily
              child: widget.customDialog!,
            );
          },
        ).then((_) {
          if (mounted) {
            _dialogShown = false;
          }
        });
      } else if (isConnected && _dialogShown) {
        if (Navigator.canPop(context)) {
          Navigator.pop(context);
        }
        _dialogShown = false;
      }
    }
  }

  @override
  void dispose() {
    _subscription.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (!_isConnected && widget.customDisconnectedWidget != null) {
      return Scaffold(
        body: widget.customDisconnectedWidget!,
      );
    }
    return widget.child;
  }
}

class ConnectivityService {
  static void startConnectionNotifier({
    String? connectedToastMessage,
    String? disconnectedToastMessage,
    bool showToasts = false,
  }) {
    if (!showToasts) return;
    Connectivity().onConnectivityChanged.listen((result) {
      // Simple Toast implementation
      // Not actually showing toast on first launch to avoid spam, but listening to changes.
      // (Optional) You can import fluttertoast and use Fluttertoast.showToast(...)
    });
  }
}
