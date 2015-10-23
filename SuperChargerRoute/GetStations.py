import re
import requests
import numpy as np
import pandas as pd

url = 'http://www.teslamotors.com/findus/list/superchargers/United+States'
rv = requests.get(url)
content = rv.text

sc_page_urls = re.findall('(/findus/location/supercharger/\w+)', content)
sc_names = []
sc_coors = {}

for sc_page_url in sc_page_urls:
    url = 'http://www.teslamotors.com' + sc_page_url
    rv = requests.get(url)
    soup = BeautifulSoup(rv.text)
    sc_name = soup.find('h1').text
    sc_names.append(sc_name)
    directions_link = soup.find('a', {'class': 'directions-link'})['href']
    lat, lng = directions_link.split('=')[-1].split(',')
    lat, lng = float(lat), float(lng)
    sc_coors[sc_name] = {'lat': lat, 'lng': lng}

sc_names = sorted(sc_names)
In [9]:
coords = pd.DataFrame.from_dict(sc_coors).T.reindex(sc_names)
coords.head()