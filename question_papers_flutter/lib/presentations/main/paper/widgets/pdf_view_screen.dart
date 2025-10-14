import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_pdfviewer/pdfviewer.dart';
import 'package:question_papers_flutter/common/app_theme.dart';
import 'dart:math' as math;

class PdfViewerScreen extends StatefulWidget {
  final String url;
  final String title;

  const PdfViewerScreen({super.key, required this.url, required this.title});

  @override
  State<PdfViewerScreen> createState() => _PdfViewerScreenState();
}

class _PdfViewerScreenState extends State<PdfViewerScreen> {
  late PdfViewerController _pdfViewerController;
  double _zoomLevel = 1.0;
  int _rotation = 0;
  bool _isWhiteBackground = false;

  @override
  void initState() {
    super.initState();
    _pdfViewerController = PdfViewerController();
  }

  void _zoomIn() {
    if (_zoomLevel < 3.0) {
      setState(() {
        _zoomLevel += 0.25;
        _pdfViewerController.zoomLevel = _zoomLevel;
      });
    } else {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('Maximum zoom reached')));
    }
  }

  void _zoomOut() {
    if (_zoomLevel > 1.0) {
      setState(() {
        _zoomLevel -= 0.25;
        _pdfViewerController.zoomLevel = _zoomLevel;
      });
    } else {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('Minimum zoom reached')));
    }
  }

  void _fitToScreen() {
    setState(() {
      _zoomLevel = 1.0;
      _pdfViewerController.zoomLevel = _zoomLevel;
    });
  }

  void _rotate() {
    setState(() {
      _rotation = (_rotation + 90) % 360;
    });
  }

  void _toggleBackground() {
    setState(() {
      _isWhiteBackground = !_isWhiteBackground;
    });
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final backgroundColor = _isWhiteBackground
        ? Colors.white
        : (isDark ? AppTheme.backgroundDark : AppTheme.backgroundLight);

    return Scaffold(
      backgroundColor: backgroundColor,
      appBar: AppBar(
        title: Text(
          widget.title,
          style: Theme.of(context).textTheme.titleLarge?.copyWith(
            fontWeight: FontWeight.bold,
            color: isDark ? AppTheme.textColorDark : AppTheme.textColorLight,
          ),
        ),
        centerTitle: true,
        leading: IconButton(
          icon: Icon(
            Icons.arrow_back,
            color: isDark ? AppTheme.textColorDark : AppTheme.textColorLight,
          ),
          onPressed: () => Navigator.pop(context),
        ),
        backgroundColor: Colors.transparent,
        elevation: 0,
        actions: [
          IconButton(
            tooltip: "Toggle Background",
            icon: Icon(
              _isWhiteBackground
                  ? Icons.dark_mode_outlined
                  : Icons.light_mode_outlined,
              color: isDark ? AppTheme.textColorDark : AppTheme.textColorLight,
            ),
            onPressed: _toggleBackground,
          ),
          IconButton(
            tooltip: "Rotate",
            icon: Icon(
              Icons.rotate_right,
              color: isDark ? AppTheme.textColorDark : AppTheme.textColorLight,
            ),
            onPressed: _rotate,
          ),
        ],
      ),
      body: Stack(
        children: [
          Center(
            child: Transform.rotate(
              angle: _rotation * math.pi / 180,
              child: SfPdfViewer.network(
                widget.url,
                controller: _pdfViewerController,
                canShowScrollHead: true,
                canShowScrollStatus: true,
                enableDoubleTapZooming: true,
                onDocumentLoadFailed: (details) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text('Failed to load PDF: ${details.error}'),
                    ),
                  );
                },
              ),
            ),
          ),
          // Bottom Zoom Controls
          Positioned(
            bottom: 16,
            left: 0,
            right: 0,
            child: Center(
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: Colors.black.withOpacity(0.4),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    _controlButton(Icons.zoom_out, "Zoom Out", _zoomOut),
                    _controlButton(
                      Icons.fit_screen,
                      "Fit to Screen",
                      _fitToScreen,
                    ),
                    _controlButton(Icons.zoom_in, "Zoom In", _zoomIn),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _controlButton(IconData icon, String tooltip, VoidCallback onPressed) {
    return IconButton(
      icon: Icon(icon, color: Colors.white),
      tooltip: tooltip,
      onPressed: onPressed,
    );
  }
}
