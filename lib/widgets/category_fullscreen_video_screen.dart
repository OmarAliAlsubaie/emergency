import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';
import '../models/category.dart';
import '../screens/simulation/scenario_list_screen.dart';

class CategoryFullscreenVideoScreen extends StatefulWidget {
  final SimulationCategory category;

  const CategoryFullscreenVideoScreen({
    super.key,
    required this.category,
  });

  @override
  State<CategoryFullscreenVideoScreen> createState() =>
      _CategoryFullscreenVideoScreenState();
}

class _CategoryFullscreenVideoScreenState
    extends State<CategoryFullscreenVideoScreen> {
  VideoPlayerController? _controller;
  bool _isInitialized = false;
  bool _hasError = false;
  bool _isFinished = false;

  @override
  void initState() {
    super.initState();
    _initVideo();
  }

  Future<void> _initVideo() async {
    final videoPath = 'assets/videos/cat_${widget.category.id}.mp4';
    try {
      final controller = VideoPlayerController.asset(videoPath);
      await controller.initialize();
      controller.setLooping(false);
      controller.setVolume(1.0);
      controller.addListener(_videoListener);
      await controller.play();

      if (mounted) {
        setState(() {
          _controller = controller;
          _isInitialized = true;
        });
      }
    } catch (e) {
      debugPrint('Error playing fullscreen video for ${widget.category.id}: $e');
      if (mounted) {
        setState(() {
          _hasError = true;
        });
        // If error loading video, proceed directly to scenario list screen
        _finishVideo();
      }
    }
  }

  void _videoListener() {
    if (_controller != null && _controller!.value.isInitialized) {
      final value = _controller!.value;
      if (value.position >= value.duration && value.duration > Duration.zero) {
        _finishVideo();
      }
    }
  }

  void _finishVideo() {
    if (_isFinished) return;
    _isFinished = true;
    _controller?.removeListener(_videoListener);
    _controller?.pause();

    if (mounted) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) => ScenarioListScreen(category: widget.category),
        ),
      );
    }
  }

  @override
  void dispose() {
    _controller?.removeListener(_videoListener);
    _controller?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: SafeArea(
        child: Stack(
          alignment: Alignment.center,
          children: [
            // Fullscreen Video Player
            if (_isInitialized && _controller != null && !_hasError)
              Center(
                child: AspectRatio(
                  aspectRatio: _controller!.value.aspectRatio > 0
                      ? _controller!.value.aspectRatio
                      : 16 / 9,
                  child: VideoPlayer(_controller!),
                ),
              )
            else if (_hasError)
              const Center(
                child: Icon(Icons.error_outline, color: Colors.white70, size: 48),
              )
            else
              const Center(
                child: CircularProgressIndicator(color: Colors.white),
              ),

            // Top Overlay Bar: Category Title + Skip ("تخطي") Button
            Positioned(
              top: 16,
              left: 16,
              right: 16,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  // Category Title Pill
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
                    decoration: BoxDecoration(
                      color: Colors.black.withOpacity(0.65),
                      borderRadius: BorderRadius.circular(20),
                      border: Border.all(color: Colors.white24, width: 1),
                    ),
                    child: Text(
                      widget.category.titleAr,
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),

                  // Skip ("تخطي") Button
                  GestureDetector(
                    onTap: _finishVideo,
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.2),
                        borderRadius: BorderRadius.circular(20),
                        border: Border.all(color: Colors.white30, width: 1),
                      ),
                      child: const Row(
                        children: [
                          Text(
                            'تخطي',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 13,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          SizedBox(width: 4),
                          Icon(
                            Icons.skip_next_rounded,
                            color: Colors.white,
                            size: 18,
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),

            // Bottom Progress Bar Indicator
            if (_isInitialized && _controller != null)
              Positioned(
                bottom: 12,
                left: 20,
                right: 20,
                child: VideoProgressIndicator(
                  _controller!,
                  allowScrubbing: false,
                  colors: const VideoProgressColors(
                    playedColor: Color(0xFF00E676),
                    bufferedColor: Colors.white24,
                    backgroundColor: Colors.white12,
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}
