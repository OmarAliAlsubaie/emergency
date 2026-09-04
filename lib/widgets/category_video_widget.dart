import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';
import 'nano_image_widget.dart';

class CategoryVideoWidget extends StatefulWidget {
  final String categoryId;
  final double height;
  final BorderRadius? borderRadius;
  final bool autoPlay;
  final bool showControls;

  const CategoryVideoWidget({
    super.key,
    required this.categoryId,
    this.height = 200,
    this.borderRadius,
    this.autoPlay = true,
    this.showControls = true,
  });

  @override
  State<CategoryVideoWidget> createState() => _CategoryVideoWidgetState();
}

class _CategoryVideoWidgetState extends State<CategoryVideoWidget> {
  VideoPlayerController? _controller;
  bool _isInitialized = false;
  bool _hasError = false;

  @override
  void initState() {
    super.initState();
    _initVideo();
  }

  @override
  void didUpdateWidget(CategoryVideoWidget oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.categoryId != widget.categoryId) {
      _controller?.dispose();
      _isInitialized = false;
      _hasError = false;
      _initVideo();
    }
  }

  Future<void> _initVideo() async {
    final videoPath = 'assets/videos/cat_${widget.categoryId}.mp4';
    try {
      final controller = VideoPlayerController.asset(videoPath);
      await controller.initialize();
      controller.setLooping(true);
      controller.setVolume(0.0); // Muted background video for smooth playback
      if (widget.autoPlay) {
        controller.play();
      }
      if (mounted) {
        setState(() {
          _controller = controller;
          _isInitialized = true;
        });
      }
    } catch (e) {
      debugPrint('Error loading category video $videoPath: $e');
      if (mounted) {
        setState(() {
          _hasError = true;
        });
      }
    }
  }

  @override
  void dispose() {
    _controller?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final effectiveRadius = widget.borderRadius ?? BorderRadius.circular(20);

    return ClipRRect(
      borderRadius: effectiveRadius,
      child: Container(
        height: widget.height,
        width: double.infinity,
        color: Colors.black,
        child: Stack(
          alignment: Alignment.center,
          children: [
            if (_isInitialized && _controller != null && !_hasError)
              SizedBox.expand(
                child: FittedBox(
                  fit: BoxFit.cover,
                  child: SizedBox(
                    width: _controller!.value.size.width > 0
                        ? _controller!.value.size.width
                        : 16,
                    height: _controller!.value.size.height > 0
                        ? _controller!.value.size.height
                        : 9,
                    child: VideoPlayer(_controller!),
                  ),
                ),
              )
            else
              Positioned.fill(
                child: NanoImageWidget(
                  imageSource: 'cat_${widget.categoryId}',
                  fit: BoxFit.cover,
                ),
              ),

            // Soft overlay gradient for high contrast readability
            Positioned.fill(
              child: Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.bottomCenter,
                    end: Alignment.topCenter,
                    colors: [
                      Colors.black.withOpacity(0.55),
                      Colors.transparent,
                    ],
                  ),
                ),
              ),
            ),

            // Interactive Play / Pause button toggle
            if (_isInitialized && _controller != null && widget.showControls)
              Positioned(
                bottom: 12,
                left: 12,
                child: GestureDetector(
                  onTap: () {
                    setState(() {
                      if (_controller!.value.isPlaying) {
                        _controller!.pause();
                      } else {
                        _controller!.play();
                      }
                    });
                  },
                  child: Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: Colors.black54,
                      shape: BoxShape.circle,
                      border: Border.all(color: Colors.white30, width: 1),
                    ),
                    child: Icon(
                      _controller!.value.isPlaying
                          ? Icons.pause_rounded
                          : Icons.play_arrow_rounded,
                      color: Colors.white,
                      size: 20,
                    ),
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}
