import os

os.makedirs(r"c:\Users\omara\Desktop\m proj\assets\illustrations", exist_ok=True)

avatars = {
    "avatar_boy.svg": """<svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 100 100">
  <circle cx="50" cy="50" r="48" fill="#A2E8DD"/>
  <circle cx="50" cy="42" r="22" fill="#FAD7A0"/>
  <!-- Hair -->
  <path d="M 30 38 Q 50 16 70 38 C 65 24 35 24 30 38 Z" fill="#5D4037"/>
  <!-- Eyes -->
  <circle cx="43" cy="40" r="3" fill="#212121"/>
  <circle cx="57" cy="40" r="3" fill="#212121"/>
  <!-- Smile -->
  <path d="M 42 48 Q 50 54 58 48" stroke="#212121" stroke-width="2.5" fill="none" stroke-linecap="round"/>
  <!-- Shirt -->
  <path d="M 22 88 Q 50 62 78 88 L 78 100 L 22 100 Z" fill="#4CAF50"/>
</svg>""",

    "avatar_girl.svg": """<svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 100 100">
  <circle cx="50" cy="50" r="48" fill="#FCE4EC"/>
  <!-- Hair Long -->
  <path d="M 24 35 C 24 15 76 15 76 35 C 76 60 70 70 68 72 C 60 45 40 45 32 72 C 30 70 24 60 24 35 Z" fill="#3E2723"/>
  <circle cx="50" cy="42" r="21" fill="#FFE0B2"/>
  <!-- Eyes -->
  <circle cx="43" cy="41" r="3" fill="#212121"/>
  <circle cx="57" cy="41" r="3" fill="#212121"/>
  <!-- Smile -->
  <path d="M 43 49 Q 50 55 57 49" stroke="#E91E63" stroke-width="2.5" fill="none" stroke-linecap="round"/>
  <!-- Shirt -->
  <path d="M 24 88 Q 50 64 76 88 L 76 100 L 24 100 Z" fill="#FF4081"/>
</svg>""",

    "avatar_hero.svg": """<svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 100 100">
  <circle cx="50" cy="50" r="48" fill="#FFE082"/>
  <!-- Helmet -->
  <path d="M 25 38 C 25 18 75 18 75 38 L 78 40 L 22 40 Z" fill="#E65100"/>
  <rect x="20" y="38" width="60" height="6" rx="3" fill="#FF9800"/>
  <circle cx="50" cy="48" r="20" fill="#FFCC80"/>
  <!-- Eyes -->
  <circle cx="43" cy="47" r="3" fill="#212121"/>
  <circle cx="57" cy="47" r="3" fill="#212121"/>
  <!-- Big Smile -->
  <path d="M 42 54 Q 50 60 58 54" stroke="#212121" stroke-width="2.5" fill="none" stroke-linecap="round"/>
  <!-- Uniform -->
  <path d="M 22 88 Q 50 64 78 88 L 78 100 L 22 100 Z" fill="#FB8C00"/>
  <rect x="46" y="70" width="8" height="25" fill="#FFEB3B"/>
</svg>""",

    "avatar_father.svg": """<svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 100 100">
  <circle cx="50" cy="50" r="48" fill="#E8EAF6"/>
  <circle cx="50" cy="42" r="22" fill="#FAD7A0"/>
  <!-- Hair & Shemagh Base -->
  <path d="M 26 34 Q 50 14 74 34 L 74 42 L 26 42 Z" fill="#D32F2F"/>
  <path d="M 30 20 Q 50 10 70 20" stroke="#212121" stroke-width="4" fill="none"/>
  <!-- Eyes -->
  <circle cx="43" cy="42" r="3" fill="#212121"/>
  <circle cx="57" cy="42" r="3" fill="#212121"/>
  <!-- Smile -->
  <path d="M 43 50 Q 50 56 57 50" stroke="#212121" stroke-width="2.5" fill="none" stroke-linecap="round"/>
  <!-- Thobe -->
  <path d="M 22 88 Q 50 62 78 88 L 78 100 L 22 100 Z" fill="#FFFFFF" stroke="#B0BEC5" stroke-width="1.5"/>
</svg>""",

    "avatar_mother.svg": """<svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 100 100">
  <circle cx="50" cy="50" r="48" fill="#F3E5F5"/>
  <!-- Hijab -->
  <path d="M 24 38 C 24 16 76 16 76 38 C 76 65 72 85 68 95 C 60 70 40 70 32 95 C 28 85 24 65 24 38 Z" fill="#7B1FA2"/>
  <circle cx="50" cy="42" r="19" fill="#FFE0B2"/>
  <!-- Eyes -->
  <circle cx="44" cy="41" r="2.8" fill="#212121"/>
  <circle cx="56" cy="41" r="2.8" fill="#212121"/>
  <!-- Smile -->
  <path d="M 44 48 Q 50 53 56 48" stroke="#E91E63" stroke-width="2.2" fill="none" stroke-linecap="round"/>
  <!-- Dress -->
  <path d="M 25 88 Q 50 68 75 88 L 75 100 L 25 100 Z" fill="#AB47BC"/>
</svg>"""
}

for fname, content in avatars.items():
    fpath = os.path.join(r"c:\Users\omara\Desktop\m proj\assets\illustrations", fname)
    with open(fpath, "w", encoding="utf-8") as f:
        f.write(content)
    print(f"Created {fname}")

