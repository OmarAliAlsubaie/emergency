import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';

class AudioService {
  static final AudioService instance = AudioService._init();
  AudioService._init();

  bool _isMuted = false;
  bool get isMuted => _isMuted;

  void toggleMute() {
    _isMuted = !_isMuted;
  }

  void playClick() {
    if (_isMuted) return;
    try {
      HapticFeedback.selectionClick();
      SystemSound.play(SystemSoundType.click);
    } catch (e) {
      debugPrint('Audio click error: $e');
    }
  }

  void playSuccess() {
    if (_isMuted) return;
    try {
      HapticFeedback.mediumImpact();
      SystemSound.play(SystemSoundType.click);
    } catch (e) {
      debugPrint('Audio success error: $e');
    }
  }

  void playError() {
    if (_isMuted) return;
    try {
      HapticFeedback.heavyImpact();
    } catch (e) {
      debugPrint('Audio error: $e');
    }
  }

  void playTimerTick() {
    if (_isMuted) return;
    try {
      HapticFeedback.lightImpact();
    } catch (e) {
      debugPrint('Audio timer tick error: $e');
    }
  }

  void playSirenAlert() {
    if (_isMuted) return;
    try {
      HapticFeedback.vibrate();
      SystemSound.play(SystemSoundType.alert);
    } catch (e) {
      debugPrint('Audio siren error: $e');
    }
  }

  void playLevelUpCelebration() {
    if (_isMuted) return;
    try {
      HapticFeedback.heavyImpact();
      SystemSound.play(SystemSoundType.click);
    } catch (e) {
      debugPrint('Audio celebration error: $e');
    }
  }
}

