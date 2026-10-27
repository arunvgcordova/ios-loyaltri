import 'dart:io';
import 'dart:math' as math;
import 'dart:ui' as ui;
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

/// A full-screen image crop widget.
///
/// The image is displayed fixed (fitted to the available area).
/// A resizable square crop rectangle is overlaid on top.
/// The user can drag any corner or edge to resize the square,
/// or drag the centre to reposition it.
/// Pressing "Done" crops the image and returns the cropped file path.
class ImageCropScreen extends StatefulWidget {
  final String imagePath;

  const ImageCropScreen({super.key, required this.imagePath});

  @override
  State<ImageCropScreen> createState() => _ImageCropScreenState();
}

class _ImageCropScreenState extends State<ImageCropScreen> {
  // The decoded image for rendering & cropping
  ui.Image? _uiImage;

  // Rect of the image as it is rendered on screen (within the body area)
  Rect _imageRect = Rect.zero;

  // Current crop rect in screen coordinates (clamped to _imageRect)
  late Rect _cropRect;

  // Which handle the user is dragging (null = none)
  _Handle? _activeHandle;

  // For centre-drag (move the whole rect)
  Offset? _dragStartOffset;
  Rect? _dragStartRect;

  bool _isCropping = false;

  // Minimum crop size in logical pixels
  static const double _minCropSize = 80;

  // Handle hit-test radius
  static const double _handleHitRadius = 24;

  // Safe clamp that never throws (handles min > max)
  double _safeClamp(double value, double lo, double hi) {
    if (lo > hi) lo = hi;
    return value.clamp(lo, hi);
  }

  @override
  void initState() {
    super.initState();
    _loadImage();
  }

  Future<void> _loadImage() async {
    final bytes = await File(widget.imagePath).readAsBytes();
    final codec = await ui.instantiateImageCodec(bytes);
    final frame = await codec.getNextFrame();
    setState(() {
      _uiImage = frame.image;
    });
  }

  /// Rotate the current image 90° clockwise.
  Future<void> _rotateImage() async {
    if (_uiImage == null) return;
    final src = _uiImage!;
    final w = src.width;
    final h = src.height;

    // Draw the rotated image onto a new canvas
    final recorder = ui.PictureRecorder();
    final canvas = Canvas(recorder);
    // After 90° CW rotation: new width = old height, new height = old width
    canvas.translate(h.toDouble(), 0);
    canvas.rotate(math.pi / 2);
    canvas.drawImage(src, Offset.zero, Paint());
    final picture = recorder.endRecording();
    final rotated = await picture.toImage(h, w);
    setState(() {
      _uiImage = rotated;
      _cropRect = Rect.zero; // reset so it recalculates on next layout
    });
  }

  // Calculate where the image sits on screen given the available size
  Rect _calcImageRect(Size available) {
    if (_uiImage == null) return Rect.zero;
    final iw = _uiImage!.width.toDouble();
    final ih = _uiImage!.height.toDouble();
    final scale = (available.width / iw).clamp(0.0, available.height / ih);
    final rw = iw * scale;
    final rh = ih * scale;
    final dx = (available.width - rw) / 2;
    final dy = (available.height - rh) / 2;
    return Rect.fromLTWH(dx, dy, rw, rh);
  }

  // Initialise crop rect to a centred square (80 % of the shorter image dim)
  Rect _initialCropRect(Rect imgRect) {
    final side = imgRect.shortestSide * 0.8;
    return Rect.fromCenter(
      center: imgRect.center,
      width: side,
      height: side,
    );
  }

  // Clamp a crop rect so it stays inside the image rect and stays square
  Rect _clampCrop(Rect crop) {
    double side = crop.width; // always square
    final maxSide = _imageRect.shortestSide;
    final minSide = math.min(_minCropSize, maxSide);
    side = _safeClamp(side, minSide, maxSide);

    double left = crop.left;
    double top = crop.top;

    left = _safeClamp(left, _imageRect.left, _imageRect.right - side);
    top = _safeClamp(top, _imageRect.top, _imageRect.bottom - side);

    return Rect.fromLTWH(left, top, side, side);
  }

  // Detect which handle (corner / edge / centre) a point hits
  _Handle? _hitTest(Offset pos) {
    // Corners first
    if ((pos - _cropRect.topLeft).distance < _handleHitRadius) {
      return _Handle.topLeft;
    }
    if ((pos - _cropRect.topRight).distance < _handleHitRadius) {
      return _Handle.topRight;
    }
    if ((pos - _cropRect.bottomLeft).distance < _handleHitRadius) {
      return _Handle.bottomLeft;
    }
    if ((pos - _cropRect.bottomRight).distance < _handleHitRadius) {
      return _Handle.bottomRight;
    }
    // Edges
    if (_edgeHit(pos, _cropRect.topLeft, _cropRect.topRight)) {
      return _Handle.top;
    }
    if (_edgeHit(pos, _cropRect.bottomLeft, _cropRect.bottomRight)) {
      return _Handle.bottom;
    }
    if (_edgeHit(pos, _cropRect.topLeft, _cropRect.bottomLeft)) {
      return _Handle.left;
    }
    if (_edgeHit(pos, _cropRect.topRight, _cropRect.bottomRight)) {
      return _Handle.right;
    }
    // Centre
    if (_cropRect.contains(pos)) {
      return _Handle.centre;
    }
    return null;
  }

  bool _edgeHit(Offset pos, Offset a, Offset b) {
    final r = _handleHitRadius;
    if (a.dx == b.dx) {
      // vertical edge
      return (pos.dx - a.dx).abs() < r &&
          pos.dy > a.dy + r &&
          pos.dy < b.dy - r;
    } else {
      // horizontal edge
      return (pos.dy - a.dy).abs() < r &&
          pos.dx > a.dx + r &&
          pos.dx < b.dx - r;
    }
  }

  void _onPanStart(DragStartDetails d) {
    _activeHandle = _hitTest(d.localPosition);
    if (_activeHandle == _Handle.centre) {
      _dragStartOffset = d.localPosition;
      _dragStartRect = _cropRect;
    }
  }

  void _onPanUpdate(DragUpdateDetails d) {
    if (_activeHandle == null) return;

    setState(() {
      if (_activeHandle == _Handle.centre) {
        // Move the whole rect
        final delta = d.localPosition - _dragStartOffset!;
        final moved = _dragStartRect!.shift(delta);
        _cropRect = _clampCrop(moved);
      } else {
        _cropRect = _resizeCrop(d.localPosition);
      }
    });
  }

  void _onPanEnd(DragEndDetails _) {
    _activeHandle = null;
    _dragStartOffset = null;
    _dragStartRect = null;
  }

  /// Resize crop rect by moving the active handle while keeping it square.
  Rect _resizeCrop(Offset pos) {
    double newSide;
    double newLeft = _cropRect.left;
    double newTop = _cropRect.top;

    switch (_activeHandle!) {
      case _Handle.topLeft:
        final dx = pos.dx - _cropRect.right;
        final dy = pos.dy - _cropRect.bottom;
        newSide = math.max(-dx, _minCropSize);
        newSide = math.min(newSide, math.max(-dy, _minCropSize));
        newSide = _safeClamp(newSide, _minCropSize, _imageRect.shortestSide);
        newLeft = _cropRect.right - newSide;
        newTop = _cropRect.bottom - newSide;
        break;
      case _Handle.topRight:
        final dx = pos.dx - _cropRect.left;
        final dy = pos.dy - _cropRect.bottom;
        newSide = math.max(dx, _minCropSize);
        newSide = math.min(newSide, math.max(-dy, _minCropSize));
        newSide = _safeClamp(newSide, _minCropSize, _imageRect.shortestSide);
        newLeft = _cropRect.left;
        newTop = _cropRect.bottom - newSide;
        break;
      case _Handle.bottomLeft:
        final dx = pos.dx - _cropRect.right;
        final dy = pos.dy - _cropRect.top;
        newSide = math.max(-dx, _minCropSize);
        newSide = math.min(newSide, math.max(dy, _minCropSize));
        newSide = _safeClamp(newSide, _minCropSize, _imageRect.shortestSide);
        newLeft = _cropRect.right - newSide;
        newTop = _cropRect.top;
        break;
      case _Handle.bottomRight:
        final dx = pos.dx - _cropRect.left;
        final dy = pos.dy - _cropRect.top;
        newSide = math.max(dx, _minCropSize);
        newSide = math.min(newSide, math.max(dy, _minCropSize));
        newSide = _safeClamp(newSide, _minCropSize, _imageRect.shortestSide);
        newLeft = _cropRect.left;
        newTop = _cropRect.top;
        break;
      case _Handle.top:
        final dy = pos.dy - _cropRect.bottom;
        newSide = _safeClamp(-dy, _minCropSize, _imageRect.shortestSide);
        final centre = _cropRect.center.dx;
        newLeft = centre - newSide / 2;
        newTop = _cropRect.bottom - newSide;
        break;
      case _Handle.bottom:
        final dy = pos.dy - _cropRect.top;
        newSide = _safeClamp(dy, _minCropSize, _imageRect.shortestSide);
        final centre = _cropRect.center.dx;
        newLeft = centre - newSide / 2;
        newTop = _cropRect.top;
        break;
      case _Handle.left:
        final dx = pos.dx - _cropRect.right;
        newSide = _safeClamp(-dx, _minCropSize, _imageRect.shortestSide);
        newLeft = _cropRect.right - newSide;
        final centreY = _cropRect.center.dy;
        newTop = centreY - newSide / 2;
        break;
      case _Handle.right:
        final dx = pos.dx - _cropRect.left;
        newSide = _safeClamp(dx, _minCropSize, _imageRect.shortestSide);
        newLeft = _cropRect.left;
        final centreY = _cropRect.center.dy;
        newTop = centreY - newSide / 2;
        break;
      case _Handle.centre:
        return _cropRect; // handled elsewhere
    }

    return _clampCrop(Rect.fromLTWH(newLeft, newTop, newSide, newSide));
  }

  // ---- Crop & save ----

  Future<void> _performCrop() async {
    if (_uiImage == null || _isCropping) return;
    setState(() => _isCropping = true);

    try {
      // Convert screen-coordinate crop rect → image-pixel rect
      final scaleX = _uiImage!.width / _imageRect.width;
      final scaleY = _uiImage!.height / _imageRect.height;

      final srcLeft = ((_cropRect.left - _imageRect.left) * scaleX).round();
      final srcTop = ((_cropRect.top - _imageRect.top) * scaleY).round();
      final srcWidth = (_cropRect.width * scaleX).round();
      final srcHeight = (_cropRect.height * scaleY).round();

      final recorder = ui.PictureRecorder();
      final canvas = Canvas(recorder);
      canvas.drawImageRect(
        _uiImage!,
        Rect.fromLTWH(
          srcLeft.toDouble(),
          srcTop.toDouble(),
          srcWidth.toDouble(),
          srcHeight.toDouble(),
        ),
        Rect.fromLTWH(0, 0, srcWidth.toDouble(), srcHeight.toDouble()),
        Paint(),
      );
      final picture = recorder.endRecording();
      final croppedImage = await picture.toImage(srcWidth, srcHeight);
      final byteData =
          await croppedImage.toByteData(format: ui.ImageByteFormat.png);
      if (byteData == null) {
        if (mounted) Navigator.pop(context);
        return;
      }

      // Write to a temporary file
      final dir = Directory.systemTemp;
      final outFile = File(
        '${dir.path}/cropped_${DateTime.now().millisecondsSinceEpoch}.png',
      );
      await outFile.writeAsBytes(byteData.buffer.asUint8List());

      if (mounted) Navigator.pop(context, outFile.path);
    } catch (_) {
      if (mounted) Navigator.pop(context);
    }
  }

  // ---- Build ----

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: SafeArea(
        child: Column(
          children: [
            // Image + crop overlay
            Expanded(
              child: LayoutBuilder(
                builder: (context, constraints) {
                  final available =
                      Size(constraints.maxWidth, constraints.maxHeight);
                  _imageRect = _calcImageRect(available);

                  // Lazily initialise crop rect on first layout
                  if (_cropRect == Rect.zero && _imageRect != Rect.zero) {
                    _cropRect = _initialCropRect(_imageRect);
                  }

                  if (_uiImage == null) {
                    return const Center(
                      child: CircularProgressIndicator(color: Colors.white),
                    );
                  }

                  return GestureDetector(
                    onPanStart: _onPanStart,
                    onPanUpdate: _onPanUpdate,
                    onPanEnd: _onPanEnd,
                    child: CustomPaint(
                      size: available,
                      painter: _CropPainter(
                        image: _uiImage!,
                        imageRect: _imageRect,
                        cropRect: _cropRect,
                      ),
                    ),
                  );
                },
              ),
            ),

            // Bottom bar
            Container(
              color: Colors.black,
              padding:
                  const EdgeInsets.symmetric(horizontal: 24, vertical: 14),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  TextButton(
                    onPressed: () => Navigator.pop(context),
                    child: Text(
                      'Cancel',
                      style: GoogleFonts.poppins(
                        color: Colors.white,
                        fontSize: 16,
                      ),
                    ),
                  ),
                  // Rotate 90° clockwise
                  IconButton(
                    onPressed: _rotateImage,
                    icon: const Icon(Icons.rotate_right, color: Colors.white, size: 24),
                  ),
                  TextButton(
                    onPressed: _isCropping ? null : _performCrop,
                    child: Text(
                      'Done',
                      style: GoogleFonts.poppins(
                        color: _isCropping ? Colors.grey : Colors.white,
                        fontSize: 16,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    // Reset crop rect so it gets recalculated on next layout
    _cropRect = Rect.zero;
  }
}

// ─── Custom Painter ───────────────────────────────────────────────

class _CropPainter extends CustomPainter {
  final ui.Image image;
  final Rect imageRect;
  final Rect cropRect;

  _CropPainter({
    required this.image,
    required this.imageRect,
    required this.cropRect,
  });

  @override
  void paint(Canvas canvas, Size size) {
    // 1. Draw the image
    canvas.drawImageRect(
      image,
      Rect.fromLTWH(
        0,
        0,
        image.width.toDouble(),
        image.height.toDouble(),
      ),
      imageRect,
      Paint(),
    );

    // 2. Dim the area outside the crop rect (semi-transparent overlay)
    final dimPaint = Paint()..color = Colors.black.withValues(alpha: 0.55);

    // Top strip
    canvas.drawRect(
      Rect.fromLTRB(0, 0, size.width, cropRect.top),
      dimPaint,
    );
    // Bottom strip
    canvas.drawRect(
      Rect.fromLTRB(0, cropRect.bottom, size.width, size.height),
      dimPaint,
    );
    // Left strip
    canvas.drawRect(
      Rect.fromLTRB(0, cropRect.top, cropRect.left, cropRect.bottom),
      dimPaint,
    );
    // Right strip
    canvas.drawRect(
      Rect.fromLTRB(cropRect.right, cropRect.top, size.width, cropRect.bottom),
      dimPaint,
    );

    // 3. Crop border
    final borderPaint = Paint()
      ..color = Colors.white
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2;
    canvas.drawRect(cropRect, borderPaint);

    // 4. Grid lines (2×2 rule-of-thirds)
    final gridPaint = Paint()
      ..color = Colors.white.withValues(alpha: 0.4)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 0.5;
    final thirdW = cropRect.width / 3;
    final thirdH = cropRect.height / 3;
    for (int i = 1; i <= 2; i++) {
      // Vertical
      canvas.drawLine(
        Offset(cropRect.left + thirdW * i, cropRect.top),
        Offset(cropRect.left + thirdW * i, cropRect.bottom),
        gridPaint,
      );
      // Horizontal
      canvas.drawLine(
        Offset(cropRect.left, cropRect.top + thirdH * i),
        Offset(cropRect.right, cropRect.top + thirdH * i),
        gridPaint,
      );
    }

    // 5. Corner handles (thicker L-shaped lines)
    _drawCornerHandles(canvas, cropRect);
  }

  void _drawCornerHandles(Canvas canvas, Rect rect) {
    final p = Paint()
      ..color = Colors.white
      ..style = PaintingStyle.stroke
      ..strokeWidth = 3.5
      ..strokeCap = StrokeCap.square;
    const len = 20.0;

    // Top-left
    canvas.drawLine(rect.topLeft, Offset(rect.left + len, rect.top), p);
    canvas.drawLine(rect.topLeft, Offset(rect.left, rect.top + len), p);
    // Top-right
    canvas.drawLine(rect.topRight, Offset(rect.right - len, rect.top), p);
    canvas.drawLine(rect.topRight, Offset(rect.right, rect.top + len), p);
    // Bottom-left
    canvas.drawLine(rect.bottomLeft, Offset(rect.left + len, rect.bottom), p);
    canvas.drawLine(
        rect.bottomLeft, Offset(rect.left, rect.bottom - len), p);
    // Bottom-right
    canvas.drawLine(
        rect.bottomRight, Offset(rect.right - len, rect.bottom), p);
    canvas.drawLine(
        rect.bottomRight, Offset(rect.right, rect.bottom - len), p);
  }

  @override
  bool shouldRepaint(covariant _CropPainter old) =>
      old.cropRect != cropRect || old.imageRect != imageRect;
}

// ─── Handle enum ──────────────────────────────────────────────────

enum _Handle {
  topLeft,
  topRight,
  bottomLeft,
  bottomRight,
  top,
  bottom,
  left,
  right,
  centre,
}
