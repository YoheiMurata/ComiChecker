require 'net/http'
require 'uri'
require 'json'
require_relative '../Exception/ArgumentException'

class HttpConnector
	
	# ホスト名	
	@host = nil
	# ポート番号
	@port = nil	
	# SSL通信を使用するか否か
	@useSSL = nil
	# コネクション
	@connection = nil

	# イニシャライザ
	# @param [String] hostname ホスト名
	# @param [bool] useSSL SSL通信で行うのかどうか
	# @return [HttpConnector] HttpConnectorクラスのインスタンス
	def initialize( hostname, useSSL )
		
		# SSL通信を行うかどうかを決定	
		@useSSL = useSSL
		setHost( hostname )
		@connection = createHttpConnection
		#debug
		puts "hostname = #{ @host }"
		puts "port = #{ @port }"
		puts "connection = #{ @connection }"
	end	

	# ホスト名のセッタ
	# @param [String] hostname 新しいホスト名
	# @return なし
	def setHost( hostname )
		begin
			tmp = URI.parse( hostname )
			@host = tmp.host
			@port = tmp.port
 		rescue
			raise ArgumentException.new( "ホスト名が無効です" )
		end
	end

	# 受け取ったURIとクエリを使ってGETリクエストを投げる
	# @param [String] uri リクエストを投げるURI
	# @param [Hash] headers HTTPヘッダを指定する
	# @param [Hash] query クエリパラメータのキー=>値のペア
	# @return [Object] Getリクエストを行った結果受け取った情報が格納されたオブジェクト
	#         HTTPクラスのrequestメソッドで返される値
	def doGet( uri, headers, query )
		begin
			# debug
			puts "doGet: start"
			# resultは結果を代入する変数
			result = nil
			str = nil
			# クエリが何もないのであればURIだけ指定する
			if query != nil then 
				str = makeUriWithQuery( uri, query )
			end	

			httpHeader = nil

			# ヘッダがnilか判定
			if headers != nil then 

				# 第2引数がHashじゃなかったら例外スロー
				if !headers.kind_of?( Hash ) then
					raise ArgumentException.new( "無効なヘッダ指定.ヘッダはHashで指定してください" )
				end

				# ヘッダを指定するハッシュが空でなければ
				# HTTPヘッダに指定
				if !headers.empty? then
					httpHeader = headers
				end

			end	
			puts "httpHeader = #{ httpHeader }"
			# 受け取ったURI、ヘッダを使用してGETリクエストを生成
			get = createGetRequest( str, httpHeader )
			# debug
			puts "get = #{ get }"

			# 生成したGETリクエストを投げる
			response = @connection.request( get )
			
			return response
			
		rescue ArgumentException => e
			puts "doGetメソッド実行中にエラーが発生: #{e}"
			e.backtrace
		end
	end
	
	# 受け取ったURIを使ってPOSTリクエストを投げる
	# @param [String] uri リクエストを投げるURI
	# @param [Hash] headers HTTPヘッダを指定する
	# @param [String] body POSTリクエストのボディ
	# @return [Object] POSTリクエストを行った結果受け取った情報が格納されたオブジェクト
	#         HTTPクラスのrequestメソッドで返される値
	def doPost( uri, headers, body )
		begin
			# debug
			puts "doPost: start"
			# resultは結果を代入する変数
			result = nil
			str = uri
			httpHeader = nil

			# ヘッダがnilか判定
			if headers != nil then 

				# 第2引数がHashじゃなかったら例外スロー
				if !headers.kind_of?( Hash ) then
					raise ArgumentException.new( "無効なヘッダ指定.ヘッダはHashで指定してください" )
				end

				# ヘッダを指定するハッシュが空でなければ
				# HTTPヘッダに指定
				if !headers.empty? then
					httpHeader = headers
				end

			end	

			puts "httpHeader = #{ httpHeader }"
			# 受け取ったURI、ヘッダを使用してPOSTリクエストを生成
			post = createPostRequest( uri, httpHeader, body )
			# debug
			puts "post = #{ post }"
			puts "post.body = #{ post.body }"

			# 生成したPOSTリクエストを投げる
			response = @connection.request( post )
			
			return response
			
		rescue ArgumentException => e
			puts "doPostメソッド実行中にエラーが発生: #{e}"
			e.backtrace
		end
	end

	# ここから先のメソッドはprivate
	private

	# Net::HTTPクラスのインスタンスを生成する
	# @param なし
	# @return [Net::HTTP] Net::HTTPクラスのインスタンス
	def createHttpConnection
		https = Net::HTTP.new( @host, @port )
		https.use_ssl = @useSSL
		
		# debug
		# httpのリクエストヘッダを出力
		#https.set_debug_output $stderr

		return https
	end

	# 引数の情報を持つNet::HTTP::Postクラスのインスタンスを生成する
	# @param [String] uri コンストラクタまたはsetHostで設定したホスト名以下のURIを指定する
	# @param [Hash] headers POSTヘッダに記述するHTTPヘッダを指定する
	# @param [String] data HTTPヘッダのデータ部に記述するデータを指定する
	# @return [Net::HTTP:Post] POSTヘッダ
	def createPostRequest( uri, headers, data )
		req = Net::HTTP::Post.new( uri, headers )
		req.body = data
		return req
	end

	# 引数の情報を持つNet::HTTP::Getクラスのインスタンスを生成する
	# @param [String] uri コンストラクタまたはsetHostで設定したホスト名以下のURIを指定する
	# @param [Hash] headers GETヘッダに記述するHTTPヘッダを指定する
	# @return [Net::HTTP:Get] GETヘッダ
	def createGetRequest( uri, headers )
		req = Net::HTTP::Get.new( uri, headers )
		return req
	end
		
	
	# クエリ文字列付きのURIを作成する
	# @param [String] uri URI文字列
	# @param [Hash] queries "ヘッダ名" => "値"の形式で生成したハッシュ
	# @return [String] クエリ付きのURI文字列
	def makeUriWithQuery( uri, queries )
		str = uri
		# 第2引数がHashじゃなかったら例外スロー
		if !queries.kind_of?( Hash ) then
			raise ArgumentException.new( "想定していないオブジェクトが指定されています" )
		end

		# クエリを指定するハッシュが空でなければ
		if !queries.empty? then
			str += '?'
			queries.each do | key, value |
				str += "#{ key }=#{ URI.escape value }&"
			end
				
			# 末尾についてるはずの'&'を取り除く
			str = str[ 0, str.length - 1 ]	
				
			# debug
			puts "str = #{ str }"
		end

		return str
	end

end		
