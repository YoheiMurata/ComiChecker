# Twitterのユーザ情報をまとめるテーブル
CREATE TABLE TWITTER_USER (
	# Twitter内でユニークなID。しかしこれは表側からはわからない
	# このIDを収集するバッチを別に作る必要がありそう
	TWITTER_USER_ID	BIGINT UNSIGNED PRIMARY KEY,
	#Twitterのユーザ名（表示されてる名前）
	# これは変えられるものなので検索には使わないほうがいいだろう
	TWITTER_USER_NAME VARCHAR( 128 ) NOT NULL,
	#Twitterの@で始まる名前
	# これも変えられるので検索には使わないほうがいいだろう
	TWITTER_USER_SCREEN_NAME VARCHAR( 128 ) NOT NULL,
	# ユーザ個別にツイートを調査するか否か
	# Twitter APIのAPI呼び出し制限上、全てのユーザの
	# ツイートを調査するわけには行かないので優先順位が高い物を
	# チェックする。これは本ツールの管理者が利用者の要望の元決定する
	# 1: チェックする 0:チェックしない
	USER_TWEET_CHECK INT( 1 ) NOT NULL DEFAULT 0
);
