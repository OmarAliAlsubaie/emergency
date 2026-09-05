import math
import random
import struct
import wave
import os

SAMPLE_RATE = 22050
DURATION = 15 # 15 seconds loop for fast generation and compact size

def create_wav(filename, samples):
    os.makedirs('web/audio', exist_ok=True)
    os.makedirs('assets/audio', exist_ok=True)
    
    web_path = os.path.join('web/audio', filename)
    asset_path = os.path.join('assets/audio', filename)
    
    for p in [web_path, asset_path]:
        with wave.open(p, 'wb') as wav_file:
            wav_file.setnchannels(1)
            wav_file.setsampwidth(2)
            wav_file.setframerate(SAMPLE_RATE)
            
            packed = bytearray()
            for s in samples:
                s_clamped = max(-1.0, min(1.0, s))
                val = int(s_clamped * 32767)
                packed.extend(struct.pack('<h', val))
            wav_file.writeframes(packed)
    print(f"Generated 100% PURE NATURE file: {filename} ({len(samples)} samples)")

class BiquadFilter:
    def __init__(self, filter_type, freq, q=1.0):
        w0 = 2.0 * math.pi * freq / SAMPLE_RATE
        alpha = math.sin(w0) / (2.0 * q)
        cos_w0 = math.cos(w0)
        
        if filter_type == 'lowpass':
            b0 = (1 - cos_w0) / 2
            b1 = 1 - cos_w0
            b2 = (1 - cos_w0) / 2
            a0 = 1 + alpha
            a1 = -2 * cos_w0
            a2 = 1 - alpha
        elif filter_type == 'bandpass':
            b0 = alpha
            b1 = 0
            b2 = -alpha
            a0 = 1 + alpha
            a1 = -2 * cos_w0
            a2 = 1 - alpha
        else:
            b0 = (1 - cos_w0) / 2
            b1 = 1 - cos_w0
            b2 = (1 - cos_w0) / 2
            a0 = 1 + alpha
            a1 = -2 * cos_w0
            a2 = 1 - alpha

        self.b0 = b0 / a0
        self.b1 = b1 / a0
        self.b2 = b2 / a0
        self.a1 = a1 / a0
        self.a2 = a2 / a0
        self.x1 = self.x2 = self.y1 = self.y2 = 0.0

    def process(self, x):
        y = self.b0 * x + self.b1 * self.x1 + self.b2 * self.x2 - self.a1 * self.y1 - self.a2 * self.y2
        self.x2 = self.x1
        self.x1 = x
        self.y2 = self.y1
        self.y1 = y
        return y

total_samples = SAMPLE_RATE * DURATION

# 1. FIRE (fire.mp3) - Pure Wood Crackle & Hearth Ember Popping (0% Music)
fire_filter = BiquadFilter('lowpass', 450, 0.7)
fire_samples = []
for i in range(total_samples):
    white = (random.random() - 0.5) * 0.4
    rumble = fire_filter.process(white) * 0.8
    crackle = (random.random() - 0.5) * 1.5 if random.random() < 0.003 else 0.0
    fire_samples.append(rumble + crackle)
create_wav('fire.mp3', fire_samples)

# 2. FLOOD (flood.mp3) - Pure Flowing Water Stream & Torrent (0% Music)
flood_filter1 = BiquadFilter('bandpass', 550, 1.2)
flood_filter2 = BiquadFilter('lowpass', 800, 0.8)
flood_samples = []
for i in range(total_samples):
    t = i / SAMPLE_RATE
    white = (random.random() - 0.5) * 0.6
    lfo = 1.0 + 0.3 * math.sin(2.0 * math.pi * 0.25 * t)
    w1 = flood_filter1.process(white) * lfo * 0.6
    w2 = flood_filter2.process(white) * 0.4
    flood_samples.append(w1 + w2)
create_wav('flood.mp3', flood_samples)

# 3. ELECTRIC (electric.mp3) - Pure Indoor Room Airflow & Fan (0% Music)
elec_filter = BiquadFilter('lowpass', 350, 0.6)
elec_samples = []
for i in range(total_samples):
    white = (random.random() - 0.5) * 0.35
    air = elec_filter.process(white) * 0.9
    elec_samples.append(air)
create_wav('electric.mp3', elec_samples)

# 4. HEAT (heat.mp3) - Pure Desert Summer Wind Gusts (0% Music)
heat_filter = BiquadFilter('bandpass', 480, 1.5)
heat_samples = []
for i in range(total_samples):
    t = i / SAMPLE_RATE
    white = (random.random() - 0.5) * 0.5
    gust = 0.6 + 0.4 * math.sin(2.0 * math.pi * 0.15 * t)
    w = heat_filter.process(white) * gust * 0.8
    heat_samples.append(w)
create_wav('heat.mp3', heat_samples)

# 5. TRAFFIC (traffic.mp3) - Pure Rain on Road Asphalt (0% Music)
traffic_filter1 = BiquadFilter('lowpass', 600, 0.7)
traffic_filter2 = BiquadFilter('bandpass', 1200, 1.0)
traffic_samples = []
for i in range(total_samples):
    white = (random.random() - 0.5) * 0.5
    r1 = traffic_filter1.process(white) * 0.6
    r2 = traffic_filter2.process(white) * 0.3
    drop = (random.random() - 0.5) * 0.8 if random.random() < 0.005 else 0.0
    traffic_samples.append(r1 + r2 + drop)
create_wav('traffic.mp3', traffic_samples)

# 6. CYBER (cyber.mp3) - Pure Ocean Shore Waves & Sea Surf (0% Music)
cyber_filter = BiquadFilter('lowpass', 500, 0.8)
cyber_samples = []
for i in range(total_samples):
    t = i / SAMPLE_RATE
    white = (random.random() - 0.5) * 0.5
    wave_lfo = 0.2 + 0.8 * (0.5 + 0.5 * math.sin(2.0 * math.pi * 0.125 * t))
    w = cyber_filter.process(white) * wave_lfo * 0.75
    cyber_samples.append(w)
create_wav('cyber.mp3', cyber_samples)

# 7. DESERT (desert.mp3) - Pure Howling Sandstorm Wind (0% Music)
desert_filter = BiquadFilter('bandpass', 650, 2.5)
desert_samples = []
for i in range(total_samples):
    t = i / SAMPLE_RATE
    white = (random.random() - 0.5) * 0.55
    gust = 0.5 + 0.5 * math.sin(2.0 * math.pi * 0.2 * t)
    w = desert_filter.process(white) * gust * 0.85
    desert_samples.append(w)
create_wav('desert.mp3', desert_samples)

# 8. EVACUATION (evacuation.mp3) - Pure Forest Wind Leaves (0% Music)
evac_filter1 = BiquadFilter('lowpass', 400, 0.7)
evac_filter2 = BiquadFilter('bandpass', 1400, 1.8)
evac_samples = []
for i in range(total_samples):
    t = i / SAMPLE_RATE
    white = (random.random() - 0.5) * 0.45
    w1 = evac_filter1.process(white) * 0.6
    rustle = evac_filter2.process(white) * (0.3 + 0.3 * math.sin(2.0 * math.pi * 0.3 * t))
    evac_samples.append(w1 + rustle)
create_wav('evacuation.mp3', evac_samples)

# 9. HOME (home.mp3) - Pure Raindrops on Window Glass (0% Music)
home_filter = BiquadFilter('lowpass', 550, 0.8)
home_samples = []
for i in range(total_samples):
    white = (random.random() - 0.5) * 0.4
    r = home_filter.process(white) * 0.7
    glass_drop = (random.random() - 0.5) * 0.9 if random.random() < 0.008 else 0.0
    home_samples.append(r + glass_drop)
create_wav('home.mp3', home_samples)

# 10. EMERGENCY KIT (kit.mp3) - Pure Mountain Water Stream (0% Music)
kit_filter1 = BiquadFilter('bandpass', 480, 1.2)
kit_filter2 = BiquadFilter('bandpass', 950, 1.5)
kit_samples = []
for i in range(total_samples):
    t = i / SAMPLE_RATE
    white = (random.random() - 0.5) * 0.45
    s1 = kit_filter1.process(white) * 0.5
    s2 = kit_filter2.process(white) * (0.3 + 0.2 * math.sin(2.0 * math.pi * 0.4 * t))
    kit_samples.append(s1 + s2)
create_wav('kit.mp3', kit_samples)

print("ALL 10 PURE NATURE FILES CREATED SUCCESSFULLY!")
