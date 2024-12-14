import 'package:flutter/material.dart';

class Loading {
  static final _overlayStateKey = GlobalKey<OverlayState>();
  static OverlayEntry? _overlayEntry;

  static void show(BuildContext context) {
    if (_overlayEntry != null) return;

    _overlayEntry = OverlayEntry(
      builder: (_) => Container(
        color: Colors.black54,
        child: Center(
          child: CircularProgressIndicator(
            color: Colors.white,
          ),
        ),
      ),
    );

    Overlay.of(context, rootOverlay: true)?.insert(_overlayEntry!);
  }

  static void hide() {
    _overlayEntry?.remove();
    _overlayEntry = null;
  }
}
