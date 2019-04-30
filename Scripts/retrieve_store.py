import firebase_admin
from firebase_admin import credentials,firestore
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

mycursor.execute('SELECT * FROM songdetailsfinal where spotifyurl is not null')

dbResult = mycursor.fetchall()

cred = credentials.Certificate("C:\TRANSFER\Bucky\serviceAccountKey.json")
firebase_admin.initialize_app(cred)

i=1

db = firestore.client()

for songs in dbResult:
	if i >2500:
		break
	i = i + 1
	doc_ref = db.collection(u'lol').document(u''+str(songs[0]))
	if songs[4] is not None :
		if songs[5] is not None:
				doc_ref.set({
			   u'songName': u''+songs[1],
			   u'albumName': u''+songs[2],
			   u'singer1': u''+songs[3],
			   u'singer2': u''+songs[4],
			   u'singer3': u''+songs[5],
			   u'wynkUrl': u''+songs[6],
			   u'wynkShortUrl': u''+songs[7],
			   u'gaanaUrl' : u'',
			   u'spotifyUrl' : u''+songs[9],
			   u'itunesUrl' : u'',
			   u'search' : u''+songs[1][0]	
			   })
	elif songs[4] is not None :
		doc_ref.set({
			   u'songName': u''+songs[1],
			   u'albumName': u''+songs[2],
			   u'singer1': u''+songs[3],
			   u'singer2': u''+songs[4],
			   u'singer3': u'',
			   u'wynkUrl': u''+songs[6],
			   u'wynkShortUrl': u''+songs[7],
			   u'gaanaUrl' : u'',
			   u'spotifyUrl' : u''+songs[9],
			   u'itunesUrl' : u'',
			   u'search' : u''+songs[1][0]	
			   })
	else:
		doc_ref.set({
			   u'songName': u''+songs[1],
			   u'albumName': u''+songs[2],
			   u'singer1': u''+songs[3],
			   u'singer2': u'',
			   u'singer3': u'',
			   u'wynkUrl': u''+songs[6],
			   u'wynkShortUrl': u''+songs[7],
			   u'gaanaUrl' : u'',
			   u'spotifyUrl' : u''+songs[9],
			   u'itunesUrl' : u'',
			   u'search' : u''+songs[1][0]	
			   })