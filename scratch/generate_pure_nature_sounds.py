import math
import random
import struct
import wave
import os

def create_pure_nature_sound(filename, duration_sec, sound_type):
    sample_rate = 22050
    num_samples = int(sample_rate * duration_sec)
    
    # State variables for filters and LFOs
    b0, b1, b2, b3, b4, b5, b6 = 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0
    filter_state = 0.0
    filter_state2 = 0.0
    lfo_phase = 0.0
    
    samples = []
    
    for i in range(num_samples):
        t = i / sample_rate
        
        # Pink / Brown Noise Generator
        white = random.uniform(-1.0, 1.0)
        b0 = 0.99886 * b0 + white * 0.0555179
        b1 = 0.99332 * b1 + white * 0.0750759
        b2 = 0.96900 * b2 + white * 0.1538520
        b3 = 0.86650 * b3 + white * 0.3104856
        b4 = 0.55000 * b4 + white * 0.5329522
        b5 = -0.7616 * b5 - white * 0.0168980
        pink = b0 + b1 + b2 + b3 + b4 + b5 + b6 + white * 0.5362
        b6 = white * 0.115926
        
        sample = 0.0
        
        if sound_type == 'fire':
            # PURE WOOD FIRE CRACKLE & HEARTH BURNING (0% Music)
            # Low flame rumbling
            filter_state += (pink * 0.3 - filter_state) * 0.08
            flame = filter_state
            # Wood crackle impulses
            crackle = 0.0
            if random.random() < 0.003: # Random wood pop
                pop_amp = random.uniform(0.4, 0.9)
                crackle = pop_amp * (1.0 if random.random() > 0.5 else -1.0)
            sample = flame * 0.6 + crackle * 0.8

        elif sound_type == 'flood':
            # PURE RUSHING RIVER STREAM & WATER FLOW (0% Music)
            lfo = math.sin(2 * math.pi * 0.4 * t) * 0.3 + 0.7
            filter_state += (pink * lfo - filter_state) * 0.25
            bubble = 0.0
            if random.random() < 0.02:
                bubble = math.sin(2 * math.pi * random.uniform(600, 1200) * t) * 0.15
            sample = filter_state * 0.8 + bubble

        elif sound_type == 'electric':
            # PURE INDOOR ROOM AIRFLOW & VENTILATION (0% Music)
            filter_state += (pink * 0.25 - filter_state) * 0.05
            sample = filter_state * 0.9

        elif sound_type == 'heat':
            # PURE DESERT WIND BREEZE GUSTS (0% Music)
            gust_lfo = (math.sin(2 * math.pi * 0.12 * t) + math.sin(2 * math.pi * 0.05 * t)) * 0.4 + 0.5
            filter_state += (pink * gust_lfo - filter_state) * 0.08
            sample = filter_state * 0.95

        elif sound_type == 'traffic':
            # PURE RAIN ON ROAD & WET ASPHALT (0% Music)
            filter_state += (pink * 0.4 - filter_state) * 0.35
            rain_drop = 0.0
            if random.random() < 0.015:
                rain_drop = (random.random() - 0.5) * 0.4
            sample = filter_state * 0.5 + rain_drop * 0.5

        elif sound_type == 'cyber':
            # PURE OCEAN BEACH WAVES CRASHING (0% Music)
            wave_lfo = (math.sin(2 * math.pi * 0.08 * t) + 1.0) * 0.5 # 12.5s wave cycle
            wave_lfo = wave_lfo ** 2 # Steeper wave swell
            filter_cutoff = 0.04 + wave_lfo * 0.3
            filter_state += (pink * wave_lfo - filter_state) * filter_cutoff
            sample = filter_state * 1.1

        elif sound_type == 'desert':
            # PURE DESERT SANDSTORM WIND HOWLING (0% Music)
            wind_lfo = math.sin(2 * math.pi * 0.18 * t) * 0.35 + 0.65
            freq = 400 + wind_lfo * 400
            # Resonant bandpass
            filter_state += (pink * wind_lfo - filter_state) * 0.15
            filter_state2 += (filter_state - filter_state2) * 0.15
            sample = (filter_state - filter_state2) * 1.2

        elif sound_type == 'evacuation':
            # PURE FOREST WIND & RUSTLING TREES (0% Music)
            leaf_lfo = (math.sin(2 * math.pi * 0.25 * t) + math.sin(2 * math.pi * 0.7 * t)) * 0.25 + 0.5
            filter_state += (pink * leaf_lfo - filter_state) * 0.18
            sample = filter_state * 0.85

        elif sound_type == 'home':
            # PURE RAIN DROPS TAPPING ON WINDOW GLASS (0% Music)
            filter_state += (pink * 0.2 - filter_state) * 0.12
            glass_tap = 0.0
            if random.random() < 0.025: # Frequent rain taps on glass
                glass_tap = (random.random() - 0.5) * 0.6
            sample = filter_state * 0.4 + glass_tap * 0.6

        elif sound_type == 'kit':
            # PURE MOUNTAIN WATER BROOK & BUBBLING STREAM (0% Music)
            brook_lfo = math.sin(2 * math.pi * 0.6 * t) * 0.2 + 0.8
            filter_state += (pink * brook_lfo - filter_state) * 0.3
            micro_splash = 0.0
            if random.random() < 0.03:
                micro_splash = (random.random() - 0.5) * 0.3
            sample = filter_state * 0.7 + micro_splash * 0.4

        # Clamp sample
        sample = max(-0.98, min(0.98, sample))
        int_sample = int(sample * 32767)
        samples.append(int_sample)
        
    os.makedirs('web/audio', exist_ok=True)
    os.makedirs('assets/audio', exist_ok=True)
    
    web_path = os.path.join('web/audio', filename)
    asset_path = os.path.join('assets/audio', filename)
    
    for path in [web_path, asset_path]:
        with wave.open(path, 'wb') as wav_file:
            wav_file.setnchannels(1)
            wav_file.setsampwidth(2)
            wav_file.setframerate(sample_rate)
            packed_data = struct.pack(f'<{len(samples)}h', *samples)
            wav_file.writeframes(packed_data)
            
    print(f'Generated {filename:<15} -> {num_samples} samples, {os.path.getsize(web_path)} bytes')

sound_configs = [
    ('fire.mp3', 25.0, 'fire'),
    ('flood.mp3', 25.0, 'flood'),
    ('electric.mp3', 25.0, 'electric'),
    ('heat.mp3', 25.0, 'heat'),
    ('traffic.mp3', 25.0, 'traffic'),
    ('cyber.mp3', 25.0, 'cyber'),
    ('desert.mp3', 25.0, 'desert'),
    ('evacuation.mp3', 25.0, 'evacuation'),
    ('home.mp3', 25.0, 'home'),
    ('kit.mp3', 25.0, 'kit')
]

for filename, duration, stype in sound_configs:
    create_pure_nature_sound(filename, duration, stype)
