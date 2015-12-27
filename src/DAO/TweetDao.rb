require_relative './BaseDao'
require_relative './KeywordDao'
require_relative '../Twitter/Twitter'

# DBにツイートを保存したり、操作するための
# DAO
class TweetDao < BaseDao

	SQL_INSERT_TWEET = 
			'INSERT INTO TWEET ( 
			TWEET_ID, 
			TEXT,
			TWEETED_AT, 
			TWEETED_BY
			) VALUES ( 
			?,
			?, 
			?, 
			? )'
	SQL_GET_SEARCHED_TWEET =
			'SELECT TWEET_ID FROM TWEET WHERE TWEETED_AT > ?'

	SQL_GET_LATEST_TWEET =
			'SELECT TWEET_ID FROM TWEET WHERE TWEETED_BY = ?
			AND TWEETED_AT = ( SELECT MAX( TWEETED_AT ) FROM TWEET
			WHERE TWEETED_BY = ? )'

	SQL_SEARCH_TWEET =
			'SELECT TWEET_ID FROM TWEET WHERE TWEET_ID = ?'

	SQL_SEARCH_TWEET_ID_WITH_USER =
			'SELECT TWEET_ID FROM TWEET
			WHERE TWEETED_BY = ? AND TWEETED_AT > ?'

	SQL_INSERT_MEDIA_INFO =
			'INSERT INTO MEDIA(
			TWEET_ID,
			MEDIA_LOCAL_PATH,
			MEDIA_URL_PATH
			) VALUES (
			?,
			?,
			?)'
	
	SQL_GET_MEDIA_PATH =
			'SELECT TWEET_MEDIA_PATH FROM MEDIA
			WHERE TWEET_ID = ?'

	SQL_GET_MEDIA_URL =
			'SELECT TWEET_MEDIA_URL_PATH FROM MEDIA
			WHERE TWEET_ID = ?'

	SQL_GET_TWEET_TEXT =
			'SELECT TEXT FROM TWEET WHERE TWEET_ID = ?'
	
	# ツイート情報をDBに記録
	# @param [Connection] connection <br/>
	#  DBとのコネクション
	# @param [Array] tweet <br/>
	#  それぞれ以下の順番で値が格納された配列
	#    ツイートID(id)
	#    ツイートした日時(created_at)
	#    誰のツイートか(created_by)
	# @return [?]
	def self.insertTweet( connection, *tweet )
		return BaseDao.execute( connection, SQL_INSERT_TWEET, *tweet )
	end

	# ツイートIDをユーザIDとツイート時期から検索
	# @param [Connection] connection <br/>
	#  DBとのコネクション
	# @param [Array] param 
	#  以下の順番で値が格納された配列
	#   TwitterのユーザID
	#   基準となる日時（ここに設定した日付以降のツイートを検索）
	# @return [Array] Twitter IDの配列
	def self.getTwitterId( connection, *param )
		return BaseDao.execute( connection, SQL_SEARCH_TWEET_ID_WITH_USER, *param )
	end

	# ツイートIDを検索
	# @param [Connection] connection
	#  DBとのコネクション
	# @param [String] id Tweet ID
	# @return [Mysql::Stmt] Tweet ID
	def self.searchTweet( connection, id )
		return BaseDao.execute( connection, SQL_SEARCH_TWEET, id )
	end

	# 指定したユーザがつぶやいた最新ツイートを取得する
	# @param [Connection] connection
	#  DBとのコネクション
	# @param [String] id ユーザのID
	# @return [Mysql::Stmt] Tweet ID
	def self.getLatestTweet( connection, id )
		param = [ id, id ]
		return BaseDao.execute( connection, SQL_GET_LATEST_TWEET, *param )
	end 	

	# ツイートに付属している画像、動画などのメディアを記録
	# @param [Connection] connection <br/>
	#  DBとのコネクション
	# @param [Array] param <br/>
	#  以下の順番で値が格納された配列
	#   ツイートID
	# @return [Array] メディアパスの配列
	def self.insertMedia( connection, *param )
		return BaseDao.execute( connection, SQL_INSERT_MEDIA_INFO, *param )
	end

	# ツイートに付属していた画像、動画などのメディアのパスを入手
	# @param [Connection] connection <br/>
	#  DBとのコネクション
	# @param [String] param
	#  ツイートのID
	# @return [Array] ツイートに付属していた画像、動画のパスの配列
	def self.getLocalMediaPath( connection, *param )
		return BaseDao.execute( connection, SQL_GET_MEDIA_PATH, *param)
	end
		
	# ツイートに付属していた画像、動画などのメディアのURLを入手
	# @param [Connection] connection <br/>
	#  DBとのコネクション
	# @param [String] param <br/>
	#  ツイートのID
	# @return [Array] ツイートに付属していた画像、動画のURLの配列
	def self.getMediaPath( connection, *param )
		return BaseDao.execute( connection, SQL_GET_MEDIA_URL, *param )
	end

	# ツイートのテキスト内容を入手
	# @param[ Connection ] connection DBとのコネクション
	# @param[ String ] id ツイートID
	# @return[ Object ] ツイートのテキストを含んだオブジェクト
	def self.getTweetInfo( connection, id )
		return BaseDao.execute( connection, SQL_GET_TWEET_TEXT, *id )
	end

	# 取得したツイートの中から、チェック対象のツイートを
	# 抽出する
	# @param[ Connection ] connection DBとのコネクション
	# @param[ Float ] numMinute
	#  現在から何分前からのツイートを検索対象とするか
	def self.getSearchTweet( connection, numMinute )
		keywordList = KeywordDao.getKeywordList( connection, Twitter.convertToMysqlDate( DateTime.now ) )
		sql = ''
		keywordList.each{ |keyword|
			sql += "TEXT LIKE '%#{ keyword[ 0 ] }%' OR "
		}

		sql = sql[0..(sql.length - 4)]

		# DBに記載されている時刻はグリニッジ標準時
		return BaseDao.execute( connection, SQL_GET_SEARCHED_TWEET + " AND ( #{ sql } )",   Twitter.convertToMysqlDate( ( DateTime.now - ( 9.0 / 24.0 ) ) - ( numMinute / ( 24.0 * 60.0 ) ) ) )

	end
	
end
			
