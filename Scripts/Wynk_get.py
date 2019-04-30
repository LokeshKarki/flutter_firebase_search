import json
import urllib
import bs4 as bs
import urllib3
import warnings
import mysql.connector

con=mysql.connector.connect(
		host="127.0.0.1",
		user="root",
		passwd="",
		port=3306,
		database="beatsshare"
		)

mycursor = con.cursor()

mycursor.execute('SET GLOBAL connect_timeout=1000000')
mycursor.execute('SET GLOBAL wait_timeout=1000000')
mycursor.execute('SET GLOBAL interactive_timeout=1000000')
	
warnings.filterwarnings("ignore")

http = urllib3.PoolManager()
response = http.request('GET', "https://wynk.in")
home = response.data.decode('utf-8')
start = (home.find('main'))
end = home.find('"></script></body>')
mainJs = home[start:end]

response = http.request('GET', "https://wynk.in/" + mainJs)
data = response.data.decode('utf-8')
start = (data.find('n.STATIC_CPMAPPING={') + 20)
end = data.find('},n.BUTTONS')
cleaned = data[start:end]
cmap = cleaned.split(',')

singerName = list()
albumName = "NULL"
songName = "NULL"
shortUrl = "NULL"

i = 0
j = 0
k = 1
exp0=0
exp1=0
exp2=0
exp3=0
songDetail = 0
songlist = 0

#i=int(input("Enter i : "))

xmlsongmaplist,songUrls,exp = list(),list(),list()

xmlsitemap = urllib.request.urlopen('https://wynk.in/web_sitemap_index.xml').read()
soup=bs.BeautifulSoup(xmlsitemap,'xml')
for url in soup.find_all('loc'):
	if 'song' in url.text:
		print(url.text)
		xmlsongmaplist.append(url.text)

mycursor.execute("create table songUrl(id integer primary key auto_increment,url varchar(1000))")

while i < 98:
	try:
		xmlsongmap = urllib.request.urlopen(xmlsongmaplist[i]).read()
		soupsong=bs.BeautifulSoup(xmlsongmap,'xml')
		for urlsong in soupsong.find_all('loc'):
			mycursor.execute("insert into songUrl(url) values(\""+urlsong.text+'")')
		con.commit()
		print(i+1,"xml files done",len(songUrls))
		i = i + 1
	except KeyboardInterrupt:
		raise
	except:
		continue

mycursor.execute("select * from songurl")


songUrls = mycursor.fetchall()


mycursor.execute("create table songDetails(id integer auto_increment primary key,songName varchar(1000), album varchar(1000), singer1 varchar(1000), singer2 varchar(1000),singer3 varchar(1000),wynkUrl varchar(1000),wynkShortUrl varchar(1000), gaanaUrl varchar(1000), spotifyUrl varchar(1000),itunesUrl varchar(1000));")

while k < len("songUrls"):
	try:
		j = j + 1
		x = songUrls[k-1][1].split('/')
		y = x[6].split('_', 1)
		for it in cmap:
			if '"' + y[0] + '"' in it:
				while (k-exp1) != songDetail:
					try:
						songData = http.request('GET', "https://content.wynk.in/music/v3/content?id=" + it[:it.find(':')] + "_" + y[1] + "&type=SONG&count=50&offset=0")
						decodedSongData = songData.data.decode('utf-8')
						decodedJson = json.loads(decodedSongData)
						try:
							songName = decodedJson['title']
							songDetail = songDetail + 1
							for item in decodedJson:
								if item == 'singers':
									for singer in decodedJson[item]:
										singerName.append(singer['title'])
								if item == 'album':
									albumName = decodedJson[item]
								if item == 'shortUrl':
									shortUrl = decodedJson['shortUrl']
							print(songDetail)
							i = -1
							count = 0
							while i>(-len(songName)):
								if (songName[i] == '\\'):
									count = count + 1
								else:
									break
								i = i - 1
							if count % 2:
								songName = songName + '\\'
							if '"' or "'" in songName:
								newName=''
								for item in songName:
									if item == '"':
										newName = newName + '""'
									elif item == "'":
										newName = newName + "''"
									else:
										newName = newName + item
									songName = newName
							i = -1
							count = 0
							while i>(-len(albumName)):
								if (albumName[i] == '\\'):
									count = count + 1
								else:
									break
								i = i - 1
							if count % 2:
								albumName = albumName + '\\'
							if '"' or "'" in albumName:
								newName=''
								for item in albumName:
									if item == '"':
										newName = newName + '""'
									elif item == "'":
										newName = newName + "''"
									else:
										newName = newName + item
									albumName = newName
						except KeyboardInterrupt:
							con.commit()
							raise
					except KeyboardInterrupt:
						con.commit()
						raise
					except: 
						con.commit()
						print("EXP1")
						exp1 += 1
						exp.append(songDetail)
						break
					#sql Statement write
					if j == 10000:
						con.commit()
						j=0
						mycursor = con.cursor()
					if len(singerName) == 1:
						mycursor.execute("insert into songDetails(songName,album,singer1,wynkUrl,wynkShortUrl) values(\""+songName+'\",\"'+albumName+'\",\"'+singerName[0]+'\",\"'+songUrls[k-1][1]+'\",\"'+shortUrl+'\"'+')')
					if len(singerName) == 2:
						mycursor.execute("insert into songDetails(songName,album,singer1,singer2,wynkUrl,wynkShortUrl) values(\""+songName+'\",\"'+albumName+'\",\"'+singerName[0]+'\",\"'+singerName[1]+'\",\"'+songUrls[k-1][1]+'\",\"'+shortUrl+'\"'+')')
					if len(singerName) == 3:
						mycursor.execute("insert into songDetails(songName,album,singer1,singer2,singer3,wynkUrl,wynkShortUrl) values(\""+songName+'\",\"'+albumName+'\",\"'+singerName[0]+'\",\"'+singerName[1]+'\",\"'+singerName[2]+'\",\"'+songUrls[k-1][1]+'\",\"'+shortUrl+'\"'+')')
					singerName = list()
					albumName = "NULL"
					songName = "NULL"
					shortUrl = "NULL"
		k = k + 1
	except KeyboardInterrupt:
		con.commit()
		raise
	except:
		con.commit()
		continue
	
con.commit()
