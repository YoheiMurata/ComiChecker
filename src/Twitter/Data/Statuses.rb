require_relative './Tweet.rb'
require_relative '../../Exception/ArgumentException'

# Twitterのツイート検索結果を表すクラス
class Statuses
	attr_accessor :statuses
	
	def initialize( statuses )
		@statuses = []

		if( !statuses.kind_of?( Array ) ) then 
			raise ArgumentException.new( "invalid argument @Statuses.initialize" )
		end
		statuses.each{ | element |
			@statuses.push( Tweet.new( element ) )
		}
	
	end
end
