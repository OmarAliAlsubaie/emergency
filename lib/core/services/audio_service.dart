import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'audio_synth_helper.dart';

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
      playWebClick();
    } catch (e) {
      debugPrint('Audio click error: $e');
    }
  }

  void playSuccess() {
    if (_isMuted) return;
    try {
      HapticFeedback.mediumImpact();
      SystemSound.play(SystemSoundType.click);
      playWebSuccess();
    } catch (e) {
      debugPrint('Audio success error: $e');
    }
  }

  void playError() {
    if (_isMuted) return;
    try {
      HapticFeedback.heavyImpact();
      SystemSound.play(SystemSoundType.alert);
      playWebError();
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
      playWebSiren();
    } catch (e) {
      debugPrint('Audio siren error: $e');
    }
  }

  void playElectricZap() {
    if (_isMuted) return;
    try {
      HapticFeedback.heavyImpact();
      playWebZap();
    } catch (e) {
      debugPrint('Audio zap error: $e');
    }
  }

  void playHeartbeat() {
    if (_isMuted) return;
    try {
      HapticFeedback.mediumImpact();
      playWebHeartbeat();
    } catch (e) {
      debugPrint('Audio heartbeat error: $e');
    }
  }

  void playLevelUpCelebration() {
    if (_isMuted) return;
    try {
      HapticFeedback.heavyImpact();
      SystemSound.play(SystemSoundType.click);
      playWebLevelUp();
    } catch (e) {
      debugPrint('Audio celebration error: $e');
    }
  }
}
