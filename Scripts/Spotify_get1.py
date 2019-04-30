
import spotipy
import spotipy.util as util
from fuzzywuzzy import fuzz

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

mycursor.execute('SELECT ID,SONGNAME,ALBUM,SINGER1,SINGER2,SINGER3 FROM songdetailsfinal')

dbResult = mycursor.fetchall()

# Get the username from terminal
username = <USERNAME>
scope = 'user-read-private user-read-playback-state user-modify-playback-state'

token = util.prompt_for_user_token(username,scope,client_id=<CLIENT_ID>,client_secret=<API_KEY>,redirect_uri='http://google.com/')


spotifyObject = spotipy.Spotify(auth=token)

i=1
idAlbum=list()
aftersong = list()
# Loop
while i<len(dbResult):
	
	songName = dbResult[i][1]
	idAlbum=list()

	for songs in dbResult:
		if songs[1] == songName:
			idAlbum.append([songs[0],songs[2],songs[3],songs[4],songs[5]])
			
			
	searchResults = spotifyObject.search(songName,50,0,"track")

	songMeta = searchResults['tracks']['items']

	for songMetaData in songMeta:
		if fuzz.ratio(songMetaData['name'], songName) > 98:
			print('first match')
			for item in idAlbum:
				if fuzz.ratio(item[1], songMetaData['album']['name']) > 95:
					print('Second Match')
					for artistSongMetaData in songMetaData['artists']:
						print('third')
						#print(item[2], artistSongMetaData['name'],"\n\n------------")
						if fuzz.ratio(item[2], artistSongMetaData['name']) > 95:
							print('x')
							aftersong.append([item[0],songMetaData['album']['name'],songMetaData['uri']])
							break
						if fuzz.ratio(item[3], artistSongMetaData['name']) > 95:
							print('y')
							aftersong.append([item[0],songMetaData['album']['name'],songMetaData['uri']])
							break
						if fuzz.ratio(item[4], artistSongMetaData['name']) > 95:
							print('z')
							aftersong.append([item[0],songMetaData['album']['name'],songMetaData['uri']])
							break

	i = i + 1
	print(len(aftersong))
	if len(aftersong) > 100:
		for item in aftersong:
			url=item[2].split(':')
			mycursor.execute('update songdetailsfinal set spotifyurl="https://open.spotify.com/track/'+url[2]+'" where id = '+ str(item[0]))
		con.commit()
		aftersong=list()