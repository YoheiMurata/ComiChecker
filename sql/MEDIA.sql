# メディア情報を記録するためのテーブル
CREATE TABLE MEDIA(
	# どのツイートに貼られていたものか
	TWEET_ID BIGINT UNSIGNED NOT NULL,
	# メディアを保存した場所のフルパス
	# ツイート収集時は記録せず、後でバッチで
	# ダウンロードして埋める
	MEDIA_LOCAL_PATH VARCHAR( 128 ),
	# メディアのURL( HTTPS )
	MEDIA_URL_PATH VARCHAR( 128 ) NOT NULL,

	# ツイートIDは外部キー
	#FOREIGN KEY( TWEET_ID )
	#REFERENCES TWEET( TWEET_ID ),

	# ツイートIDとメディアのURLの組み合わせは
	# ユニーク
	UNIQUE( TWEET_ID, MEDIA_URL_PATH )
);
