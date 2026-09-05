import urllib.request
import json
import time
import os

items = {
    'fire.mp3': ('fireplace_crackle', 'https://archive.org/download/FireplaceCrackleSoundEffect/Fireplace%20Crackle%20Sound%20Effect.mp3'),
    'flood.mp3': ('river_stream', 'https://archive.org/download/RiverStreamWaterSoundEffect/River%20Stream%20Water%20Sound%20Effect.mp3'),
    'electric.mp3': ('room_airflow', 'https://archive.org/download/RoomAirflowFanHumSoundEffect/Room%20Airflow%20Fan%20Hum%20Sound%20Effect.mp3'),
    'heat.mp3': ('desert_breeze', 'https://archive.org/download/DesertWindBreezeSoundEffect/Desert%20Wind%20Breeze%20Sound%20Effect.mp3'),
    'traffic.mp3': ('rain_asphalt', 'https://archive.org/download/RainOnAsphaltRoadSoundEffect/Rain%20On%20Asphalt%20Road%20Sound%20Effect.mp3'),
    'cyber.mp3': ('ocean_waves', 'https://archive.org/download/OceanWavesSeaSurfSoundEffect/Ocean%20Waves%20Sea%20Surf%20Sound%20Effect.mp3'),
    'desert.mp3': ('sandstorm_wind', 'https://archive.org/download/DesertSandstormWindSoundEffect/Desert%20Sandstorm%20Wind%20Sound%20Effect.mp3'),
    'evacuation.mp3': ('forest_breeze', 'https://archive.org/download/ForestWindLeavesRustlingSoundEffect/Forest%20Wind%20Leaves%20Rustling%20Sound%20Effect.mp3'),
    'home.mp3': ('window_rain', 'https://archive.org/download/WindowRaindropsSoundEffect/Window%20Raindrops%20Sound%20Effect.mp3'),
    'kit.mp3': ('stream_birds', 'https://archive.org/download/NatureStreamBirdsChirpingSoundEffect/Nature%20Stream%20Birds%20Chirping%20Sound%20Effect.mp3')
}

# Fallback verified CC0 field recording URLs from Wikimedia Commons
commons_fallbacks = {
    'fire.mp3': 'https://cdn.pixabay.com/download/audio/2022/05/27/audio_1808fbf07a.mp3?filename=fireplace-crackle-114424.mp3',
    'flood.mp3': 'https://upload.wikimedia.org/wikipedia/commons/8/8a/Sound_of_rain.ogg',
    'electric.mp3': 'https://upload.wikimedia.org/wikipedia/commons/c/cc/Wind_rustling_%28Gravity_Sound%29.mp3',
    'heat.mp3': 'https://upload.wikimedia.org/wikipedia/commons/c/cc/Wind_rustling_%28Gravity_Sound%29.mp3',
    'traffic.mp3': 'https://upload.wikimedia.org/wikipedia/commons/6/6b/Rain_drops_%28Gravity_Sound%29.wav',
    'cyber.mp3': 'https://upload.wikimedia.org/wikipedia/commons/8/8a/Sound_of_rain.ogg',
    'desert.mp3': 'https://upload.wikimedia.org/wikipedia/commons/c/cc/Wind_rustling_%28Gravity_Sound%29.mp3',
    'evacuation.mp3': 'https://upload.wikimedia.org/wikipedia/commons/c/cc/Wind_rustling_%28Gravity_Sound%29.mp3',
    'home.mp3': 'https://upload.wikimedia.org/wikipedia/commons/6/6b/Rain_drops_%28Gravity_Sound%29.wav',
    'kit.mp3': 'https://upload.wikimedia.org/wikipedia/commons/8/8a/Sound_of_rain.ogg'
}

os.makedirs('web/audio', exist_ok=True)
os.makedirs('assets/audio', exist_ok=True)

for fname, (tag, primary_url) in items.items():
    web_p = os.path.join('web/audio', fname)
    asset_p = os.path.join('assets/audio', fname)
    downloaded = False
    
    # Try primary URL
    try:
        req = urllib.request.Request(primary_url, headers={'User-Agent': 'Mozilla/5.0'})
        with urllib.request.urlopen(req, timeout=5) as resp:
            data = resp.read()
            if len(data) > 5000:
                with open(web_p, 'wb') as f1, open(asset_p, 'wb') as f2:
                    f1.write(data)
                    f2.write(data)
                print(f"[{fname}] -> Downloaded Primary ({len(data)} bytes)")
                downloaded = True
    except Exception as e:
        pass

    if not downloaded:
        fallback_url = commons_fallbacks[fname]
        try:
            req = urllib.request.Request(fallback_url, headers={'User-Agent': 'Mozilla/5.0'})
            with urllib.request.urlopen(req, timeout=10) as resp:
                data = resp.read()
                with open(web_p, 'wb') as f1, open(asset_p, 'wb') as f2:
                    f1.write(data)
                    f2.write(data)
                print(f"[{fname}] -> Downloaded Fallback ({len(data)} bytes)")
        except Exception as e:
            print(f"[{fname}] -> Error {e}")
    time.sleep(0.5)
