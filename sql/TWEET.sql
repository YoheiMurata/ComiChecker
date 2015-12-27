# ツイート内容を記録するためのテーブル
# 削除されない限りはリンクから情報を引き出せるので
# 削除された時に必要最低限の情報だけここに記録する
CREATE TABLE TWEET (
	# Twitter内でユニークなツイートのIDらしい。
	TWEET_ID BIGINT UNSIGNED PRIMARY KEY,
	# ツイートした日時
	TWEETED_AT TIMESTAMP NOT NULL,
	# 誰がツイートしたのか。Twitter IDが入る予定
	TWEETED_BY BIGINT UNSIGNED NOT NULL,
	# ツイートの内容
	TEXT VARCHAR( 280 ) NOT NULL,
	# 画像などが付いてたらバッチ側で魚拓として画像を保存する。
	# その画像が保存されたローカルホストの位置を参照する
	# ＊よく考えたらメディアは１つとは限らないので、
	#   別のテーブルに保存する必要がある
	# TWEET_MEDIA_PATH VARCHAR( 256 ) DEFAULT NULL,
	# メディアのURL.HTTP版とHTTPS版があるがHTTPS版を
	# 記録することにする
	# 上の＊と同じ理由でこれも削除し、別のテーブルに保存する
	# TWEET_MEDIA_URL_PATH VARCHAR( 512 ) DEFAULT NULL,
	# 誰がツイートしたのかカラムの外部キー制約
	FOREIGN KEY(TWEETED_BY)
	REFERENCES TWITTER_USER(TWITTER_USER_ID)
);
