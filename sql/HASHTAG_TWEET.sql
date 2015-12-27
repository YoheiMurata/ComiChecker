# ツイートの中にどんなハッシュタグが
# 付いていたかを記録するテーブル
CREATE TABLE HASHTAG_TWEET(
	# ツイートID
	TWEET_ID BIGINT UNSIGNED NOT NULL,
	# ハッシュタグの文字列
	HASHTAG_TEXT VARCHAR( 128 ) NOT NULL,

	# ツイートIDはTWEETテーブルのTWEET_ID
	# の外部キー
	FOREIGN KEY( TWEET_ID )
	REFERENCES TWEET( TWEET_ID ),

	# ツイートIDとハッシュタグの組み合わせ
	# はユニークじゃないといけない
	UNIQUE( TWEET_ID, HASHTAG_TEXT )
);
