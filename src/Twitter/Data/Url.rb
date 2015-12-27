# URLの定義
class Url
	# 表示されているURL
	# （短縮URL）
	attr_accessor :display_url
	# フルサイズのURL
	attr_accessor :expanded_url
	# URLが記載されているツイート内の
	# オフセット
	# [開始位置, 終了位置]の構成
	attr_accessor :indices
	# indicesが示してるURL
	attr_accessor :url

	# イニシャライザ
	def initialize( url )
		# indicesは配列
		@indices = []
		
		if( !url.kind_of?( Hash ) ) then
			raise ArgumentException.new( "Invalid Argument @Url.initialize" )
		end	
		
		if( !url['indices'].kind_of?( Array ) ) then
			raise ArgumentException.new( "Invalid Argment( url ) @Url.initialize" )
		end		

		@display_url = url['display_url']
		@expanded_url = url['expanded_url']
		
		url['indices'].each{ |element|
			@indices.push( element.to_i )		
		}
	end
end		
	
