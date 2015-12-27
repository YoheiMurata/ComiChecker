# HttpConnectorクラスを作成するので、
# このクラスで通信を行うことはない
#require 'net/http'
require 'uri'
require 'base64'
require 'json'
require 'date'
require_relative './Data/Statuses'
require_relative '../HttpConnector/HttpConnector'

# Twitter REST APIをRubyでラップしたクラス
class Twitter

	# 使用するヘッダ名
	HEADER_NAME_CONTENT_TYPE = 'Content-Type'
	HEADER_NAME_AUTH = 'Authorization'

	# 使用する各リクエストのURL&URI
	TWITTER_API_HOST_URL = 'https://api.twitter.com'
	# 認証を行うURL
	TWITTER_URI_OAUTH = '/oauth2/token'
	# 認証で使用したトークンを無効化するURL
	TWITTER_URI_OAUTH_INVALIDATE = '/oauth2/invalidate_token'
	# キーワードをもとにツイートを検索するURL
	TWITTER_URI_GET_TWEET = '/1.1/search/tweets.json'
	# IDで指定したユーザのタイムラインを取得するURL
	TWITTER_URI_GET_TIMELINE = '/1.1/statuses/user_timeline.json'
	# IDで指定したユーザの情報を取得するURL
	TWITTER_URI_GET_USERINFO = '/1.1/users/show.json'
	# IDで指定したツイートのHTMLファイルへの埋め込み
	# これの後ろに受け取るツイートのフォーマットを指定する
	# JSON or XML
	TWITTER_URI_GET_TWEET_OEMBED = '/1.1/statuses/oembed.'

	# 使用する各リクエストのヘッダまたはデータ部に格納する値
	# のうち、決まって入れないといけない部分
	REQUEST_DATA_OAUTH = 'grant_type=client_credentials'
	REQUEST_HEADER_CONTENT_TYPE = 'application/x-www-form-urlencoded;charset=UTF-8'
	# 認証後に行う各リクエストにつけるヘッダの中身。
	# この後に受け取ったトークンを追記する
	REQUEST_HEADER_BEARER = 'Bearer '
	# 認証を行う際に投げるリクエストにつけるヘッダの中身。
	# この後にコンシューマキー、コンシューマシークレット
	# を結合&Base64エンコードしたものを追記する
	REQUEST_HEADER_OAUTH = 'Basic '
	# トークンを無効化するときにリクエストボディに
	# つけるデータ。この後ろにトークンを追記する
	REQUEST_BODY_INVALIDATE_TOKEN = 'access_token='

	# 使用する各レスポンスボディの名前
	RESPONSE_BODY_ACCESS_TOKEN = 'access_token'

	# Twitter APIで返される日付文字列のフォーマット
	TWITTER_DATE_FORMAT = '%a %b %d %H:%M:%S %z %Y'
	
	# Twitter APIのコンシューマキー
	@consumerKey = nil
	# Twitter APIのコンシューマシークレット
	@consumerSecret = nil
	# コンシューマキーとコンシューマシークレットで作成する
	# クレデンシャルコード
	@credentialCode = nil
	# アクセストークン
	@accessToken = nil
	# コネクションを取り持つクラス
	@connection = nil

	# イニシャライザ
	# @param [String] key Twitterのコンシューマキー
	# @param [String] code Twitterのコンシューマシークレット
	# @return [Twitter] Twitterクラスのインスタンス
	def initialize( key, code )
		@consumerKey = key
		@consumerSecret = code
		#受け取ったコンシューマキーとシークレットを
		#使ってくれデンシャルコードを生成する
		@credentialCode = 
			Base64.strict_encode64 key +':'+ code
		@connection = HttpConnector.new( TWITTER_API_HOST_URL, true )	
	end

	# 認証トークンを取得。リクエストを投げる前に
	# 必ず実行しないといけない
	# @param なし
	# @return なし　
	def authorize
	
		headers = makePostHeader
		
		result = @connection.doPost( TWITTER_URI_OAUTH, headers, REQUEST_DATA_OAUTH )	
		
		@accessToken = JSON.parse( result.body )[ RESPONSE_BODY_ACCESS_TOKEN ]
		
	end	

	# 取得した認証トークンを無効化して乗っ取りを防ぐ。
	# アプリケーション終了の際は必ず実行すること。
	# @param なし
	# @return なし
	def invalidateToken
		# ヘッダーの作成。authorizeと同じヘッダなので
		# メソッド化して共用
		headers = makePostHeader
		# トークンを無効化するにはリクエストボディに
		# 以下の文字列を書く
		body = REQUEST_BODY_INVALIDATE_TOKEN + @accessToken
		
		result = @connection.doPost( TWITTER_URI_OAUTH_INVALIDATE, headers, body )	

	end

	# キーワードをもとにツイートを検索する
	# @param [String] keyword キーワードを入力。複数の場合は半角スペースで。
	#  URLエンコードはする必要なし
	# @param [String] result_type 
	#  mixed 最近のツイート、人気のツイートを検索する
	#  recent 最近のツイートを検索する
	#  popular 人気のツイートを検索する
	# @param [Integer] count ツイート数
	# @return [Hash] ツイート検索結果をHash化したもの
	def getTweet( keyword, result_type, count )
		headers = makeGetHeader
		
		queries = {}
		queries[ 'q' ] = URI.escape( keyword )
		queries[ 'lang' ] = 'ja'
		queries[ 'result_type' ] = result_type
		queries[ 'count' ] = count

		result = @connection.doGet( TWITTER_URI_GET_TWEET, headers, queries )
		body = JSON.parse( result.body )
		
		body = Statuses.new( body['statuses'] )
		return body
	end
	
	# 特定のユーザのツイートを検索する
	# @param [String] user_type 
	#  user_id: ユーザIDで検索。Twitterのサイトなどからは見えないがユニークなので
	#   確実に見つけられる
	#  screen_name: @以降の名前を指定。変えられるらしいので確度はuser_idより低い
	# @param [String] idOrName ユーザIDまたは@以降の名前
	# @param [String] count 取得するツイート数
	# @return [Hash] 取得した検索結果をHash化したもの
	def getTimeline( user_type, idOrName, count )
		headers = makeGetHeader
		
		queries = {}
		if( user_type == 'user_id' ) then
			queries[ 'user_id' ] = idOrName
		elsif( user_type == 'screen_name' ) then
			queries[ 'screen_name' ] = idOrName
		else
			raise ArgumentException.new( "Invalid argument \"user_type\"  @Twitter.getTimeline \n user_id or screen_name")
		end
		
		queries[ 'count' ] = count

		result = @connection.doGet( TWITTER_URI_GET_TIMELINE, headers, queries )
		body = JSON.parse( result.body )
		return body
	end

	# 指定したIDの、指定したTweet ID以降のタイムラインを取得する
	# @param[ String ] id TwitterのユーザID
	# @param[ String ] since_id 基準となるTweet ID。これ以降のツイートを検索する
	# @param[ String ] count 取得するツイート数
	# @return[ Object ] 基準以降のツイートのリスト
	def getTimelineWithSinceId( id, since_id, count )
		headers = makeGetHeader

		queries = {}
		queries[ 'user_id' ] = id
		queries[ 'since_id' ] = since_id
		queries[ 'count' ] = count

		result = @connection.doGet( TWITTER_URI_GET_TIMELINE, headers, queries ) 
		body = JSON.parse( result.body )
		return body
	end

	# ユーザ名(@で始まるやつ)からユーザID(Twitter内でユニーク、変更不可)などの
	#  情報を引き出す
	# @param [String] screen_name ユーザ名(@はいらない)
	# @return [Hash] ユーザ情報
	def getUserInfo( screen_name )
		headers = makeGetHeader
	
		queries = {}
		queries[ 'screen_name' ] = screen_name
		
		result = @connection.doGet( TWITTER_URI_GET_USERINFO, headers, queries )
		body = JSON.parse( result.body )
		return body
	end

	# 指定したIDのツイートをHTML埋め込み形式のものを返却する
	# @param [String] id ツイートのID
	# @return [Object] ツイートの埋め込みHTML形式のデータを
	#  含むオブジェクト
	def getTweetEmbed( id )
		headers = makeGetHeader
		
		queries = {}
		queries[ 'hide_media' ] = "false"
		queries[ 'lang' ] = "ja"
		queries[ 'id' ] = id

		result = @connection.doGet( TWITTER_URI_GET_TWEET_OEMBED + 'json', headers, queries ) 
		body = JSON.parse( result.body )	
		return body
	end
	

	# 日付文字列をRubyのDate型に変換する
	# @param [String] dateString 日付文字列
	# @return [Date] RubyのDateTime型に変換した文字列
	def self.convertToDate( dateString )
		return DateTime.strptime( dateString, TWITTER_DATE_FORMAT )
	end

	# RubyのDateTime型をMySQLのTIMESTAMP型文字列に変換
	# @param [ DateTime ] dateTime RubyのDateTime型
	# @return [ String ] MySQLで使用可能なTimeStam型
	def self.convertToMysqlDate( dateTime )
		result = "#{ dateTime.year }-#{ dateTime.month }-#{ dateTime.day } #{ dateTime.hour }:#{ dateTime.minute }:#{ dateTime.second }"
		return result
	end
	
	private
	
	# POSTヘッダを作成
	# @param なし
	# @return [Hash] 共通のPOSTヘッダ
	def makePostHeader
		headers = {}
		headers[ HEADER_NAME_CONTENT_TYPE ] = REQUEST_HEADER_CONTENT_TYPE
		headers[ HEADER_NAME_AUTH ] = REQUEST_HEADER_OAUTH + @credentialCode
		return headers	
	end

	# GETヘッダを作成
	# @param なし
	# @return [Hash] 共通のGETヘッダ
	def makeGetHeader
		headers = {}
		headers[ HEADER_NAME_AUTH ] = REQUEST_HEADER_BEARER + @accessToken
		return headers
	end
end
