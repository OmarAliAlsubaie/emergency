// Web implementation for triggering Web Audio Synthesizer in index.html
import 'dart:js' as js;

void playWebSuccess() {
  try {
    js.context.callMethod('eval', ["if (window.EmergencyAudioSynth) { window.EmergencyAudioSynth.playSuccess(); }"]);
  } catch (_) {}
}

void playWebError() {
  try {
    js.context.callMethod('eval', ["if (window.EmergencyAudioSynth) { window.EmergencyAudioSynth.playError(); }"]);
  } catch (_) {}
}

void playWebClick() {
  try {
    js.context.callMethod('eval', ["if (window.EmergencyAudioSynth) { window.EmergencyAudioSynth.playClick(); }"]);
  } catch (_) {}
}

void playWebSiren() {
  try {
    js.context.callMethod('eval', ["if (window.EmergencyAudioSynth) { window.EmergencyAudioSynth.playSiren(); }"]);
  } catch (_) {}
}

void playWebAlarm() {
  try {
    js.context.callMethod('eval', ["if (window.EmergencyAudioSynth) { window.EmergencyAudioSynth.playAlarm(); }"]);
  } catch (_) {}
}

void playWebZap() {
  try {
    js.context.callMethod('eval', ["if (window.EmergencyAudioSynth) { window.EmergencyAudioSynth.playZap(); }"]);
  } catch (_) {}
}

void playWebHeartbeat() {
  try {
    js.context.callMethod('eval', ["if (window.EmergencyAudioSynth) { window.EmergencyAudioSynth.playHeartbeat(); }"]);
  } catch (_) {}
}

void playWebLevelUp() {
  try {
    js.context.callMethod('eval', ["if (window.EmergencyAudioSynth) { window.EmergencyAudioSynth.playSuccess(); }"]);
  } catch (_) {}
}
