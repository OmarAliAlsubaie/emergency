import 'dart:async';
import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart' show rootBundle;
import 'package:path_provider/path_provider.dart';
import 'package:provider/provider.dart';
import 'package:video_player/video_player.dart';

import '../../core/localization/app_localizations.dart';
import '../../providers/app_state_provider.dart';
import '../../providers/preparedness_provider.dart';
import '../main_navigation_screen.dart';
import '../home/onboarding_profile_screen.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  VideoPlayerController? _videoController;
  bool _hasNavigated = false;
  bool _hasProfile = false;
  bool _videoReady = false;
  bool _isMuted = true;
  Timer? _fallbackTimer;

  @override
  void initState() {
    super.initState();
    _initializeApp();
    _initVideo();
  }

  Future<VideoPlayerController?> _createController(String assetPath) async {
    // 1. Try standard Asset Controller
    try {
      debugPrint('SplashScreen: Attempting Asset Controller for $assetPath');
      final controller = VideoPlayerController.asset(assetPath);
      await controller.initialize().timeout(const Duration(seconds: 4));
      return controller;
    } catch (e) {
      debugPrint('SplashScreen: Asset Controller failed for $assetPath: $e');
    }

    // 2. Try File Controller fallback (Non-web native platforms only)
    if (!kIsWeb) {
      try {
        debugPrint('SplashScreen: Attempting File Controller fallback for $assetPath');
        final byteData = await rootBundle.load(assetPath);
        final tempDir = await getTemporaryDirectory();
        final fileName = assetPath.split('/').last;
        final tempFile = File('${tempDir.path}/$fileName');

        await tempFile.writeAsBytes(
          byteData.buffer.asUint8List(byteData.offsetInBytes, byteData.lengthInBytes),
          flush: true,
        );

        final controller = VideoPlayerController.file(tempFile);
        await controller.initialize().timeout(const Duration(seconds: 4));
        return controller;
      } catch (e) {
        debugPrint('SplashScreen: File Controller fallback failed for $assetPath: $e');
      }
    }

    return null;
  }

  Future<void> _initVideo() async {
    try {
      // Primary candidate: lod_Scene.mp4
      VideoPlayerController? controller = await _createController('assets/videos/lod_Scene.mp4');

      // Secondary candidate fallback if primary video codec/file fails: cat_fire.mp4
      controller ??= await _createController('assets/videos/cat_fire.mp4');

      if (controller == null) {
        throw Exception('Failed to initialize any video player controller');
      }

      _videoController = controller;
      controller.addListener(_onVideoControllerUpdate);

      await controller.setLooping(false);

      // Sound ON by default (Volume 1.0)
      _isMuted = false;
      await controller.setVolume(1.0);

      if (!mounted) return;

      setState(() {
        _videoReady = true;
      });

      await controller.play();
    } catch (e, stack) {
      debugPrint('SplashScreen Video Init Error: $e\n$stack');
      if (mounted && !_hasNavigated) {
        // Smooth transition to main app if video playback is unsupported on device
        _fallbackTimer = Timer(const Duration(milliseconds: 1500), _navigateToNextScreen);
      }
    }
  }

  void _onVideoControllerUpdate() {
    if (!mounted || _videoController == null) return;

    final val = _videoController!.value;
    if (val.hasError) {
      final err = val.errorDescription ?? '';
      debugPrint('SplashScreen Video Error: $err');

      // If browser Autoplay policy restricts unmuted playback without gesture:
      if (err.contains('interact') || err.contains('NotAllowedError') || err.contains('play() failed')) {
        _videoController!.removeListener(_onVideoControllerUpdate);
        _videoController!.dispose();
        _videoController = null;
        _startMutedFallback();
        return;
      }

      _navigateToNextScreen();
      return;
    }

    if (val.isInitialized && !_videoReady) {
      setState(() {
        _videoReady = true;
      });
    }

    // When video completes, navigate to main app
    if (val.isInitialized &&
        !val.isPlaying &&
        val.duration > Duration.zero &&
        val.position >= val.duration &&
        !_hasNavigated) {
      _navigateToNextScreen();
    }
  }

  Future<void> _startMutedFallback() async {
    try {
      final controller = await _createController('assets/videos/lod_Scene.mp4');
      if (controller != null && mounted) {
        _videoController = controller;
        controller.addListener(_onVideoControllerUpdate);
        await controller.setLooping(false);
        _isMuted = true;
        await controller.setVolume(0.0);
        setState(() {
          _videoReady = true;
        });
        await controller.play();
      } else {
        _navigateToNextScreen();
      }
    } catch (e) {
      _navigateToNextScreen();
    }
  }

  Future<void> _initializeApp() async {
    try {
      final appState = Provider.of<AppStateProvider>(context, listen: false);
      await appState.loadProfiles();

      _hasProfile = appState.activeProfile != null;
      if (_hasProfile && mounted) {
        final prepProvider = Provider.of<PreparednessProvider>(context, listen: false);
        await prepProvider.loadPreparednessData(appState.activeProfile!.id);
      }
    } catch (e) {
      debugPrint('Error initializing app state: $e');
    }

    // Absolute safety timer: 10 seconds max on splash
    Timer(const Duration(seconds: 10), () {
      if (mounted && !_hasNavigated) {
        _navigateToNextScreen();
      }
    });
  }

  void _navigateToNextScreen() {
    if (_hasNavigated || !mounted) return;
    _hasNavigated = true;

    final targetScreen = _hasProfile
        ? const MainNavigationScreen()
        : const OnboardingProfileScreen();

    Navigator.of(context).pushReplacement(
      PageRouteBuilder(
        pageBuilder: (context, anim, secAnim) => targetScreen,
        transitionsBuilder: (context, anim, secAnim, child) {
          return FadeTransition(opacity: anim, child: child);
        },
        transitionDuration: const Duration(milliseconds: 500),
      ),
    );
  }

  @override
  void dispose() {
    _fallbackTimer?.cancel();
    _videoController?.removeListener(_onVideoControllerUpdate);
    _videoController?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isAr = AppLocalizations.of(context).isArabic;
    final isPlayingVideo = _videoReady &&
        _videoController != null &&
        _videoController!.value.isInitialized;

    return Scaffold(
      backgroundColor: Colors.black,
      body: Stack(
        alignment: Alignment.center,
        children: [
          // 1. FULL-SCREEN VIDEO PLAYER WHEN READY
          if (isPlayingVideo)
            Positioned.fill(
              child: GestureDetector(
                onTap: () {
                  if (_videoController != null) {
                    setState(() {
                      _isMuted = !_isMuted;
                      _videoController!.setVolume(_isMuted ? 0.0 : 1.0);
                    });
                  }
                },
                child: FittedBox(
                  fit: BoxFit.cover,
                  child: SizedBox(
                    width: _videoController!.value.size.width > 0
                        ? _videoController!.value.size.width
                        : 1280,
                    height: _videoController!.value.size.height > 0
                        ? _videoController!.value.size.height
                        : 720,
                    child: VideoPlayer(_videoController!),
                  ),
                ),
              ),
            )
          else
            // Pure black background while video initializes
            Positioned.fill(
              child: Container(
                color: Colors.black,
              ),
            ),

          // 2. TOP CONTROLS (SKIP & AUDIO TOGGLE)
          Positioned(
            top: MediaQuery.of(context).padding.top + 16,
            left: 20,
            right: 20,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                // Sound Toggle Button when video is playing
                if (isPlayingVideo)
                  GestureDetector(
                    onTap: () {
                      if (_videoController != null) {
                        setState(() {
                          _isMuted = !_isMuted;
                          _videoController!.setVolume(_isMuted ? 0.0 : 1.0);
                        });
                      }
                    },
                    child: Container(
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        color: Colors.black.withOpacity(0.55),
                        shape: BoxShape.circle,
                        border: Border.all(color: Colors.white.withOpacity(0.3)),
                      ),
                      child: Icon(
                        _isMuted ? Icons.volume_off_rounded : Icons.volume_up_rounded,
                        color: Colors.white,
                        size: 18,
                      ),
                    ),
                  )
                else
                  const SizedBox.shrink(),

                // Skip Button
                GestureDetector(
                  onTap: _navigateToNextScreen,
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                    decoration: BoxDecoration(
                      color: Colors.black.withOpacity(0.55),
                      borderRadius: BorderRadius.circular(20),
                      border: Border.all(color: Colors.white.withOpacity(0.3)),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          isAr ? 'تخطي' : 'Skip',
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 13,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(width: 4),
                        Icon(
                          isAr
                              ? Icons.arrow_back_ios_new_rounded
                              : Icons.arrow_forward_ios_rounded,
                          color: Colors.white,
                          size: 12,
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
