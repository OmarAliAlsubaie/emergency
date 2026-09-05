import 'dart:js' as js;
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

  void _callWebSynth(String methodName) {
    if (_isMuted) return;
    if (kIsWeb) {
      try {
        js.context.callMethod('eval', ['if (window.EmergencyAudioSynth) window.EmergencyAudioSynth.$methodName();']);
      } catch (e) {
        debugPrint('WebSynth error: $e');
      }
    }
  }

  void playClick() {
    if (_isMuted) return;
    try {
      HapticFeedback.selectionClick();
      SystemSound.play(SystemSoundType.click);
      _callWebSynth('playClick');
    } catch (e) {
      debugPrint('Audio click error: $e');
    }
  }

  void playSuccess() {
    if (_isMuted) return;
    try {
      HapticFeedback.mediumImpact();
      SystemSound.play(SystemSoundType.click);
      _callWebSynth('playSuccess');
    } catch (e) {
      debugPrint('Audio success error: $e');
    }
  }

  void playError() {
    if (_isMuted) return;
    try {
      HapticFeedback.heavyImpact();
      _callWebSynth('playError');
    } catch (e) {
      debugPrint('Audio error: $e');
    }
  }

  void playTimerTick() {
    if (_isMuted) return;
    try {
      HapticFeedback.lightImpact();
      _callWebSynth('playClick');
    } catch (e) {
      debugPrint('Audio timer tick error: $e');
    }
  }

  void playSirenAlert() {
    if (_isMuted) return;
    try {
      HapticFeedback.vibrate();
      SystemSound.play(SystemSoundType.alert);
      _callWebSynth('playSiren');
    } catch (e) {
      debugPrint('Audio siren error: $e');
    }
  }

  void playElectricZap() {
    if (_isMuted) return;
    try {
      HapticFeedback.heavyImpact();
      _callWebSynth('playZap');
    } catch (e) {
      debugPrint('Audio zap error: $e');
    }
  }

  void playHeartbeat() {
    if (_isMuted) return;
    try {
      HapticFeedback.mediumImpact();
      _callWebSynth('playHeartbeat');
    } catch (e) {
      debugPrint('Audio heartbeat error: $e');
    }
  }

  void playLevelUpCelebration() {
    if (_isMuted) return;
    try {
      HapticFeedback.heavyImpact();
      SystemSound.play(SystemSoundType.click);
      _callWebSynth('playSuccess');
    } catch (e) {
      debugPrint('Audio celebration error: $e');
    }
  }

  void playStationSound(String categoryId) {
    if (_isMuted) return;
    try {
      switch (categoryId) {
        case 'fire':
          playSirenAlert();
          _callWebSynth('playFireStationSound');
          break;
        case 'electric':
          playElectricZap();
          _callWebSynth('playElectricStationSound');
          break;
        case 'heat':
          playHeartbeat();
          _callWebSynth('playHeatStationSound');
          break;
        case 'flood':
          HapticFeedback.mediumImpact();
          _callWebSynth('playFloodStationSound');
          break;
        case 'traffic':
          HapticFeedback.heavyImpact();
          _callWebSynth('playTrafficStationSound');
          break;
        case 'cyber':
          HapticFeedback.lightImpact();
          _callWebSynth('playCyberStationSound');
          break;
        case 'desert_safety':
          HapticFeedback.selectionClick();
          _callWebSynth('playDesertStationSound');
          break;
        case 'evacuation':
          HapticFeedback.vibrate();
          _callWebSynth('playEvacuationStationSound');
          break;
        case 'home':
          HapticFeedback.lightImpact();
          _callWebSynth('playHomeStationSound');
          break;
        case 'emergency_kit':
        default:
          playSuccess();
          _callWebSynth('playKitStationSound');
          break;
      }
    } catch (e) {
      debugPrint('Audio station sound error: $e');
    }
  }

  void stopStationSound() {
    _callWebSynth('stopStationAmbiance');
  }
}


