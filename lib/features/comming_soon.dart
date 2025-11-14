import 'package:emotcare_apps/app/ui/appbar_widget.dart';
import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';

class CommingSoon extends StatefulWidget {
  const CommingSoon({super.key});

  @override
  State<CommingSoon> createState() => _CommingSoonState();
}

class _CommingSoonState extends State<CommingSoon> {
  late final WebViewController _controller;
  bool _isLoading = true; // Untuk menampilkan loading indicator

  // !!! GANTI LINK INI DENGAN LINK GOOGLE DRIVE ANDA !!!
  final String googleDriveUrl =
      "https://drive.google.com/file/d/1MMAcVytEM8VxupjX98fhbBWxRHnJYMet/view?usp=sharing";

  @override
  void initState() {
    super.initState();

    _controller = WebViewController()
      ..setJavaScriptMode(JavaScriptMode.unrestricted) // Mengizinkan JavaScript
      ..setBackgroundColor(const Color(0x00000000))
      ..setNavigationDelegate(
        NavigationDelegate(
          onPageStarted: (String url) {
            setState(() {
              _isLoading = true; // Mulai loading
            });
          },
          onPageFinished: (String url) {
            setState(() {
              _isLoading = false; // Selesai loading
            });
          },
          onWebResourceError: (WebResourceError error) {
            // Anda bisa menangani error di sini
            debugPrint("Error: ${error.description}");
          },
        ),
      )
      ..loadRequest(Uri.parse(googleDriveUrl)); // Memuat URL
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Video dari Google Drive'),
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
        elevation: 1,
      ),
      body: Stack(
        children: [
          // Tampilkan WebView
          WebViewWidget(controller: _controller),

          // Tampilkan loading indicator di atas WebView saat sedang loading
          if (_isLoading) const Center(child: CircularProgressIndicator()),
        ],
      ),
    );
  }
}
