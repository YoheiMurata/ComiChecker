require_relative '../../Exception/ArgumentException'
require_relative './User'
require_relative './Entities'
# TwitterクラスはTweetの呼び出し元なので
# いらない気がするけど一応
require_relative '../Twitter'

# ツイートのデータクラス
class Tweet
	
	# いつツイートしたのか
	attr_accessor :created_at
	# ツイートしたユーザの情報
	attr_accessor :user
	# テキストの解析結果
	# Entitiesクラスのインスタンス
	attr_accessor :entities
	# ふぁぼ数
	attr_accessor :favorite_count
	# ツイートのID
	attr_accessor :id
	# リツイート数
	attr_accessor :retweet_count
	# ツイート内容
	attr_accessor :text
	
	def initialize( tweet )
		if( !tweet.kind_of?( Hash ) ) then
			raise ArgumentException.new( "invalid argument @Tweet.initialize" )
		end

		@created_at = Twitter.convertToDate( tweet['created_at'] )
		@user = User.new( tweet['user'] )
		@entities = Entities.new( tweet['entities'] )
		@favorite_count = tweet['favorite_count'].to_i
		@id = tweet['id'].to_i
		@retweet_count = tweet['retweet_count'].to_i
		@text = tweet['text']
	end
end
