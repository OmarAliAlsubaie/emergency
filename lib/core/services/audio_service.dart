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

  void _callWebSynthWithArg(String methodName, int arg) {
    if (_isMuted) return;
    if (kIsWeb) {
      try {
        js.context.callMethod('eval', ['if (window.EmergencyAudioSynth) window.EmergencyAudioSynth.$methodName($arg);']);
      } catch (e) {
        debugPrint('WebSynth error: $e');
      }
    }
  }

  void playClick() {
    if (_isMuted) return;
    try {
      HapticFeedback.selectionClick();
      _callWebSynth('playClick');
    } catch (e) {
      debugPrint('Audio click error: $e');
    }
  }

  void playSuccess() {
    if (_isMuted) return;
    try {
      HapticFeedback.mediumImpact();
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
    } catch (e) {
      debugPrint('Audio timer tick error: $e');
    }
  }

  void playSirenAlert() {
    if (_isMuted) return;
    try {
      HapticFeedback.vibrate();
    } catch (e) {
      debugPrint('Audio siren error: $e');
    }
  }

  void playElectricZap() {
    if (_isMuted) return;
    try {
      HapticFeedback.heavyImpact();
    } catch (e) {
      debugPrint('Audio zap error: $e');
    }
  }

  void playHeartbeat() {
    if (_isMuted) return;
    try {
      HapticFeedback.mediumImpact();
    } catch (e) {
      debugPrint('Audio heartbeat error: $e');
    }
  }

  void playLevelUpCelebration() {
    if (_isMuted) return;
    try {
      HapticFeedback.heavyImpact();
    } catch (e) {
      debugPrint('Audio celebration error: $e');
    }
  }

  void playStationSound(String categoryId, {int stepIndex = 0}) {
    if (_isMuted) return;
    try {
      HapticFeedback.lightImpact();
      switch (categoryId) {
        case 'fire':
          _callWebSynthWithArg('playFireStationSound', stepIndex);
          break;
        case 'electric':
          _callWebSynthWithArg('playElectricStationSound', stepIndex);
          break;
        case 'heat':
          _callWebSynthWithArg('playHeatStationSound', stepIndex);
          break;
        case 'flood':
          _callWebSynthWithArg('playFloodStationSound', stepIndex);
          break;
        case 'traffic':
          _callWebSynthWithArg('playTrafficStationSound', stepIndex);
          break;
        case 'cyber':
        case 'cyber_safety':
          _callWebSynthWithArg('playCyberStationSound', stepIndex);
          break;
        case 'desert':
        case 'desert_safety':
          _callWebSynthWithArg('playDesertStationSound', stepIndex);
          break;
        case 'evacuation':
          _callWebSynthWithArg('playEvacuationStationSound', stepIndex);
          break;
        case 'home':
          _callWebSynthWithArg('playHomeStationSound', stepIndex);
          break;
        case 'emergency_kit':
        default:
          _callWebSynthWithArg('playKitStationSound', stepIndex);
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


