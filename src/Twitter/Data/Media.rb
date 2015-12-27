require_relative './Sizes'
require_relative '../../Exception/ArgumentException'

# Twitterにアップロードされた
# 画像、動画などのメディア情報を
# 格納したクラス
class Media
	# Twitterクライアント上で見るための短縮URL
	attr_accessor :display_url
	# フルURL
	attr_accessor :expanded_url
	# id（本ツール上集めても意味がない気がする)
	# 本当は64-bit Integer型のidがあるが、片方
	# あればいいのでid_strを収集する
	attr_accessor :id_str
	# ツイート内にURLを埋め込まれてるタイプだと
	# この配列の添え字0及び添え字1にそれぞれURL
	# の開始位置、終了位置のオフセットが入る
	# Arrayかどうかの判定をする必要があり、
	# attr_accessor修飾子が使えない
	attr_accessor :indices
	# 本ツール上一番大事なプロパティ
	# メディアファイルのURL
	attr_accessor :media_url
	# media_urlと同じだがこちらはhttps通信を
	# 使用している。
	# Twitter REST APIでTwitterと接続している
	# セッション上でじゃないとこのURLから
	# メディアのダウンロードはできない。
	attr_accessor :media_url_https
	# HTML形式メールに埋め込むならこのプロパティは重要
	# しかし今の所予定なし
	# Size クラスのインスタンスじゃないといけないので、
	# attr_accessor修飾子は使えない
	attr_accessor :size
	# メディアが埋め込まれたツイートのTweet ID
	attr_accessor :source_status_id_str
	# メディアのタイプ
	attr_accessor :type

	# イニシャライザ
	def initialize( media )
		@display_url = media[ 'display_url' ]
		@expanded_url = media[ 'expanded_url' ]
		@indices = nil
		@media_url = media[ 'media_url' ]
		@media_url_https = media[ 'media_url_https' ]
		@size = Sizes.new( media[ 'sizes' ] )
		@source_status_id_str = nil
		@type = nil		
	end
	
	# indicesのgetter
	def indices
		return @indices
	end

	# indicesのsetter
	def indices=(indices)
		if( indices.kind_of?( Array ) ) then
			@indices = indices
		else
			raise ArgumentException.new( "invalid argument @Media.indices" )
		end
	end

	# sizeのgetter
	def size
		return @size
	end

	# sizeのsetter
	def size=(size)
		if( size.instance_of?( Sizes ) ) then
			@size = size
		else
			raise ArgumentException.new( "invalid argument @Media.size" )
		end
	end	
			

end	
