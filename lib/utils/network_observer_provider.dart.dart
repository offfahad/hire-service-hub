import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:e_commerce/common/buttons/custom_elevated_button.dart';
import 'package:e_commerce/providers/network_provider_controller.dart';
import 'package:e_commerce/utils/app_theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter_tts/flutter_tts.dart';
import 'package:provider/provider.dart';

class ProviderNetworkObserver extends StatefulWidget {
  final Widget child;

  const ProviderNetworkObserver({super.key, required this.child});

  @override
  State<ProviderNetworkObserver> createState() =>
      _ProviderNetworkObserverState();
}

class _ProviderNetworkObserverState extends State<ProviderNetworkObserver> {
  Future<void> _retryConnection() async {
    var connectivityResult = await Connectivity().checkConnectivity();
    if (connectivityResult != ConnectivityResult.none) {
      // Internet connection is available, go back to the previous screen
      // ignore: use_build_context_synchronously
      Navigator.of(context).pop();
    }
  }

  void showSnackBar(String text, Color color) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(text),
        backgroundColor: color,
      ),
    );
  }

  final FlutterTts _flutterTts = FlutterTts();

  Future<void> _sendVoiceDialog(String message) async {
    await _flutterTts.speak(message);
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<NetworkProviderController>(
      builder: (context, networkObserver, child) {
        // If the status is offline, show the custom offline screen
        if (networkObserver.status == ConnectivityStatus.offline) {
          return Scaffold(
            body: SafeArea(
              child: Center(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 40),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Icon(
                        Icons.wifi_off_outlined,
                        size: 60,
                      ),
                      SizedBox(
                        height: MediaQuery.of(context).size.height * 0.01,
                      ),
                      const Text(
                        "Opps!",
                        style: TextStyle(
                            fontSize: 20, fontWeight: FontWeight.bold),
                      ),
                      SizedBox(
                        height: MediaQuery.of(context).size.height * 0.02,
                      ),
                      const Text(
                        "No internet connection available. Please check your connection and try again.",
                        textAlign: TextAlign.center,
                      ),
                      SizedBox(
                        height: MediaQuery.of(context).size.height * 0.04,
                      ),
                      CustomElevatedButton(
                        width: MediaQuery.of(context).size.width * 0.5,
                        height: MediaQuery.of(context).size.height * 0.05,
                        backgroundColor: AppTheme.fMainColor,
                        foregroundColor: Colors.white,
                        onPressed: _retryConnection,
                        text: "Retry",
                      ),
                    ],
                  ),
                ),
              ),
            ),
          );
        } else {
          // If the status is online, return the original child widget
          return widget.child;
        }
      },
    );
  }
}
