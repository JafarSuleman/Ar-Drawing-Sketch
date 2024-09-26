import 'dart:io';
import 'dart:math' as math;
import 'package:flutter/material.dart';
import '../screens/camera_screen.dart';

class DraggableImage extends StatefulWidget {
  const DraggableImage({
    super.key,
    required this.widget,
    required this.isColored,
    required this.isFlipped,
    File? lineArtImage,
  }) : _lineArtImage = lineArtImage;

  final CameraScreen widget;
  final bool isColored;
  final bool isFlipped;
  final File? _lineArtImage;

  @override
  State<DraggableImage> createState() => _DraggableImageState();
}

class _DraggableImageState extends State<DraggableImage> {
  @override
  Widget build(BuildContext context) {
    return Transform(
      alignment: Alignment.center,
      transform: widget.isFlipped == true
          ? Matrix4.rotationY(math.pi)
          : Matrix4.rotationY(0),
      child: Transform.scale(
        scale: 0.9,
        child: Center(
          child: widget.widget.imageData != null
              ? widget._lineArtImage != null
                  ? Image.file(widget._lineArtImage!,)
                  : Image.file(widget.widget.imageData!)
              : Container(
                  color: widget.isColored ? Colors.white : null,
                  child: ColorFiltered(
                    colorFilter: const ColorFilter.mode(
                      Colors.black,
                      BlendMode.srcATop,
                    ),
                    child: Image.asset(
                      widget.widget.imagePath ?? '',
                      alignment: Alignment.center,
                      color: Colors.grey,
                    ),
                  ),
                ),
        ),
      ),
    );
  }
}
