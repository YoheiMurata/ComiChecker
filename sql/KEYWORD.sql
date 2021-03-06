# 検索するキーワード
CREATE TABLE KEYWORD(
	# キーワード
	KEYWORD VARCHAR( 16 ) NOT NULL UNIQUE,
	# 有効期間開始期間
	VALID_START TIMESTAMP NOT NULL,
	# 有効期間終了時間
	VALID_END TIMESTAMP NOT NULL,
	# そもそも有効かどうかを指定
	# 0:無効 1:有効
	VALID INT NOT NULL DEFAULT 0
	);
