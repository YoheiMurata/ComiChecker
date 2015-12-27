require_relative '../../Exception/ArgumentException'

# ページ組み込み型のツイートを
# 扱うクラス
class EmbededTweet
	
	# ツイートのソースURL
	attr_accessor :url
	# 呟いた人の名前
	attr_accessor :author_name
	# 呟いた人のページへのリンク
	attr_accessor :author_url
	# 組み込みツイートのタグ
	attr_accessor :html

	# イニシャライザ
	# @param[ Hash ] obj 組み込みツイート取得API( GET statuses/oembed )を使用して取得したJSONデータ
	# @return なし
	def initialize( obj )
		if( !obj.kind_of?( Hash ) ) then
			throw ArgumentException.new( "invalid argument @EmbededTweet.new!" )
		end

		@url = obj['url'];
		@author_name = obj['author_name']
		@author_url = obj['author_url']
		@html = obj['html']
	end
end
	
	
