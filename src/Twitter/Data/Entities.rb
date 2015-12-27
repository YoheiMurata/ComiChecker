require_relative './Url'
require_relative './Media'
require_relative './Hashtag'

# Twitterでのツイートの解析結果
class Entities
	
	# ハッシュタグの配列
	attr_accessor :hashtags
	# URLの配列
	attr_accessor :urls
	# 直訳すると「主張」
	# リプライを誰かに飛ばした場合はこれに
	# 値が入る
	# 集めてもあまり意味がないので一時見送り
	# attr_accessor :user_mentions
	# 画像、動画。
	attr_accessor :media
	
	# イニシャライザ
	def initialize( entities )
		# hashtags,urls,user_mentionsは配列
		@hashtags = []
		@urls = []
		@media = []
		# @user_mentions = []
		
		if( !entities.kind_of?( Hash ) ) then
			raise ArgumentException.new( "Invalid Argument(Entities) @Entities.initialize" )
		end
		
		# hashtags,urls,user_mentions,mediaはそれぞれ
		# nilを取りうるプロパティなので、nilチェックが必要
		if( entities['hashtags'] != nil ) then
			if( !entities['hashtags'].kind_of?( Array ) ) then
				raise ArgumentException.new( "Invalid Argument @Entities.new( hashtags )" )
			end
			
			entities['hashtags'].each{ |element|
				@hashtags.push( Hashtag.new( element ) )
			}
		end
		
		if( entities['urls'] != nil ) then
			if( !entities['urls'].kind_of?( Array ) ) then
				raise ArgumentException.new( "Invalid Argument @Entities.new( urls )" )
			end
			
			entities['urls'].each{ |element|
				puts "============================="
				puts element
				puts "============================="
				@urls.push( Url.new( element ) )
			}
		end

		if( entities['media'] != nil ) then
			if( !entities['media'].kind_of?( Array ) ) then
				raise ArgumentException.new( "Invalid Argument @Entities.new( media )" )
			end

			puts "============================="
			puts entities['media']
			puts "============================="
			
			entities['media'].each{ |element|
				@media.push( Media.new( element ) )
			}
		end

		
		
	##	entities['user_mentions'].each{ |element|
	##		@user_mentions.push( 
	##	@mentions = nil
	end

	# hashtagsのgetter
	def hashtags
		return @hashtags
	end

	# hashtagsのsetter
	def hashtags=(hashtags)
		@hashtags = hashtags
	end

	# urlsのgetter
	def urls
		return @urls
	end

	# urlsのsetter
	def urls=(urls)
		@urls = urls
	end

	# mentionsのgetter
	def mentions
		return @mentions
	end

	# mentionsのsetter
	def mentions=(mentions)
		@mentions = mentions
	end
end
