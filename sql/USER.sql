# TwitterCheckerのユーザを記録するテーブル
CREATE TABLE USER(
	# ユーザのID。いらない気もしなくはない
	USER_ID INT UNSIGNED PRIMARY KEY, 
	# ユーザ名
	USER_NAME VARCHAR( 128 ) NOT NULL,
	# メールアドレス。ここに通知メールを送る
	USER_MAIL_ADDR VARCHAR( 512 ) NOT NULL
	# ユーザが有効かチェック
	# 0: 無効, 1:有効
	USER_VALID INT NOT NULL DEFAULT 0
);
