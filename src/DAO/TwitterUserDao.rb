require_relative './BaseDao'

#Twitterのユーザを扱うクラス
class TwitterUserDao

	SQL_SEARCH_TWITTER_USER = 
			'SELECT TWITTER_USER_ID, TWITTER_USER_NAME FROM TWITTER_USER
			WHERE TWITTER_USER_ID = ?'
	
	SQL_SEARCH_CHECK_USER =
			'SELECT TWITTER_USER_ID, TWITTER_USER_NAME FROM TWITTER_USER
			WHERE USER_TWEET_CHECK = 1'

	SQL_INSERT_TWITTER_USER =
			'INSERT INTO TWITTER_USER(
			TWITTER_USER_ID,
			TWITTER_USER_NAME,
			TWITTER_USER_SCREEN_NAME,
			USER_TWEET_CHECK
			) VALUES (
			?,
			?,
			?,
			0)'
	
	SQL_SEARCH_FAVORITE_TWITTER_USER =
			'SELECT TWITTER_USER_ID, TWITTER_USER_NAME
			FROM TWITTER_USER WHERE TWITTER_USER_ID 
			= ( SELECT TWITTER_USER_ID FROM USER_FAVORITE WHERE 
			USER_ID = ? ) AND USER_TWEET_CHECK = 1'
	
	SQL_INSERT_TWITTER_FAVORITE = 
			'INSERT INTO USER_FAVOLITE (
			USER_ID,
			TWITTER_USER_ID
			) VALUES (
			?,
			? )'
	
	# DBにTwitterユーザ情報を登録する
	# @param [DBConnection] connection DBへのコネクション
	# @param [Array?] params SQLに埋め込むパラメータの配列
	#  以下の順番で値を格納
	#  ユーザID
	#  ユーザ名
	#  スクリーン名(@で始まるユーザ名)
	def self.insertUser( connection, *params )
	#	connection.prepare( SQL_INSERT_TWITTER_USER ).execute( *params )
		return BaseDao.execute( connection, SQL_INSERT_TWITTER_USER, *params )
	end

	# ユーザがチェックしようとしている
	# Twitter上のユーザ情報を取得
	# @param[ Connection ] connection　DBへのコネクション
	# @param[ Array ] params 以下の順番で格納されている配列
	#  システムのユーザID
	def self.getTwitterUserList( connection, *params )
		return BaseDao.execute( connection, SQL_SEARCH_FAVORITE_TWITTER_USER, *params )
	end

	# DB上にユーザが登録されているかチェックする
	# @param[ Connection ] connection DBへのコネクション
	# @param[ Array? ] param ユーザのID
	# @return [ Array ] 検索結果。1件だけ返却または0件
	def self.searchUser( connection, *params )
		return BaseDao.execute( connection, SQL_SEARCH_TWITTER_USER, *params )
	end

	# チェック対象になっているユーザを検索
	# @param[ Connection ] connection DBへのコネクション
	# @return[ Array ] 検索結果
	def self.searchCheckUser( connection )
		return BaseDao.query( connection, SQL_SEARCH_CHECK_USER )
	end

end
