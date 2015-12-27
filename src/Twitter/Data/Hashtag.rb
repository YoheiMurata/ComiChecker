require_relative '../../Exception/ArgumentException'

# ハッシュタグの情報解析結果
class Hashtag
	# ツイート本文内のハッシュタグの位置
	# を示す配列。長さは必ず2。
	# 添え字0が本文中のハッシュタグ開始位置オフセット
	# 添え字1が本文中のハッシュタグ終了位置オフセット
	attr_accessor :indices
	# '#'を除いたハッシュタグの本文
	attr_accessor :text
	
	# イニシャライザ
	def initialize( hashtag )
		if( !hashtag.kind_of?( Hash ) ) then
			raise ArgumentException.new( "invalid argument @Hashtag.initialize" )
		end
		@indices = hashtag['indices']
		@text = hashtag['text']
	end
	
end	
