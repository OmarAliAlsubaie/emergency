import urllib.request
import json
import time

url = "https://archive.org/advancedsearch.php?q=title%3A%28field+recording%29+AND+mediatype%3Aaudio&fl[]=identifier,title&rows=20&page=1&output=json"
req = urllib.request.Request(url, headers={'User-Agent': 'Mozilla/5.0'})
try:
    res = urllib.request.urlopen(req)
    data = json.loads(res.read().decode('utf-8'))
    docs = data.get('response', {}).get('docs', [])
    for doc in docs:
        identifier = doc.get('identifier')
        title = doc.get('title')
        # check files
        murl = f"https://archive.org/metadata/{identifier}"
        mreq = urllib.request.Request(murl, headers={'User-Agent': 'Mozilla/5.0'})
        time.sleep(0.2)
        mres = urllib.request.urlopen(mreq)
        mdata = json.loads(mres.read().decode('utf-8'))
        files = mdata.get('files', [])
        mp3s = [f['name'] for f in files if f['name'].endswith('.mp3')]
        if mp3s:
            print(f"{identifier:<35} | {title[:35]:<35} | {mp3s[0]}")
except Exception as e:
    print("Error:", e)
