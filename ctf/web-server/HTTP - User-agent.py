import requests
resp = requests.get('http://challenge01.root-me.org/web-serveur/ch2/', headers={'User-Agent': 'Admin'})
print resp.text
