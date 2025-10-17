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
      _showSnack('Maximum zoom reached');
    }
  }

  void _zoomOut() {
    if (_zoomLevel > 1.0) {
      setState(() {
        _zoomLevel -= 0.25;
        _pdfViewerController.zoomLevel = _zoomLevel;
      });
    } else {
      _showSnack('Minimum zoom reached');
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

  void _showSnack(String message) {
    ScaffoldMessenger.of(context)
        .showSnackBar(SnackBar(content: Text(message)));
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final backgroundColor =
        isDark ? AppTheme.backgroundDark : AppTheme.backgroundLight;
    final textColor =
        isDark ? AppTheme.textColorDark : AppTheme.textColorLight;

    return Scaffold(
      backgroundColor: backgroundColor,
      appBar: AppBar(
        backgroundColor: backgroundColor,
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: textColor),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(
          widget.title,
          style: Theme.of(context).textTheme.titleLarge?.copyWith(
                fontWeight: FontWeight.bold,
                color: textColor,
              ),
        ),
        centerTitle: true,
        actions: [
          IconButton(
            tooltip: "Rotate",
            icon: Icon(Icons.rotate_right, color: textColor),
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
                  _showSnack('Failed to load PDF: ${details.error}');
                },
              ),
            ),
          ),
          Positioned(
            bottom: 16,
            left: 0,
            right: 0,
            child: Center(
              child: Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 8, vertical: 6),
                decoration: BoxDecoration(
                  color: isDark
                      ? Colors.white.withOpacity(0.1)
                      : Colors.black.withOpacity(0.05),
                  borderRadius: BorderRadius.circular(AppTheme.defaultRadius),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    _controlButton(Icons.zoom_out, "Zoom Out", _zoomOut, textColor),
                    _controlButton(Icons.fit_screen, "Fit to Screen", _fitToScreen, textColor),
                    _controlButton(Icons.zoom_in, "Zoom In", _zoomIn, textColor),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _controlButton(
      IconData icon, String tooltip, VoidCallback onPressed, Color color) {
    return IconButton(
      icon: Icon(icon, color: color),
      tooltip: tooltip,
      onPressed: onPressed,
    );
  }
}
