require_relative './Size'

# Mediaクラス内で使用する、メディアのサイズを
# 取得するためのクラス
class Sizes
	# サムネイルサイズ
	attr_accessor :thumb
	# 大きい
	attr_accessor :large
	# 普通
	attr_accessor :medium
	# 小さい
	attr_accessor :small
	
	# イニシャライザ
	def initialize( sizes )
		if( !sizes.kind_of?( Hash ) ) then
			raise ArgumentException.new( "Invalid Argument @Sizes.initialize" )
		end

		@thumb = Size.new( sizes['thumb'] )
		@large = Size.new( sizes['large'] )
		@medium = nil
		@small = nil
	end

	# thumbのgetter
	def thumb
		return @thumb
	end

	# thumbのsetter
	def thumb=(thumb)
		if( thumb.instance_of?( Thumbnail ) ) then
			@thumb = thumb
		else
			ArgumentException.new( "@Sizes.thumb: Invalid Argument" )
		end
	end
	
	# largeのgetter
	def large
		return @large
	end

	# largeのsetter
	def large=(large)
		if( large.instance_of?( Large ) ) then
			@large = large
		else
			ArgumentException.new( "@Sizes.large: Invalid Argument" )
		end
	end

	# mediumのgetter
	def medium
		return @medium
	end

	# mediumのsetter
	def medium=(medium)
		if( medium.instance_of?( Medium ) ) then
			@medium = medium
		else
			ArgumentException.new( "@Sizes.medium: Invalid Argument" )
		end
	end

	# smallのgetter
	def small
		return @small
	end

	# smallのsetter
	def small=(small)
		if( small.instance_of?( Small ) ) then
			@small = small
		else
			ArgumentException.new( "@Sizes.small: Invalid Argument" )
		end
	end
	class Thumbnail
		# メディアの縦方向の長さ
		@h
		# リサイズの方法
		@resize
		# メディアの横方向の長さ
		@w

		# イニシャライザ
		def initialize
			@h = nil
			@resize = nil
			@w = nil
		end

		# hのgetter
		def h
			return @h
		end
		
		# hのsetter
		def h=(h)
			@h = h
		end

		# resizeのgetter
		def resize
			return @resize
		end

		# resizeのsetter
		def resize=(resize)
			@resize = resize
		end

		# wのgetter
		def w
			return @w
		end
		
		# wのsetter
		def w=(w)
			@w = w
		end
			
	end

	class Large
		# メディアの縦方向の長さ
		@h
		# リサイズの方法
		@resize
		# メディアの横方向の長さ
		@w

		# イニシャライザ
		def initialize
			@h = nil
			@resize = nil
			@w = nil
		end

		# hのgetter
		def h
			return @h
		end
		
		# hのsetter
		def h=(h)
			@h = h
		end

		# resizeのgetter
		def resize
			return @resize
		end

		# resizeのsetter
		def resize=(resize)
			@resize = resize
		end

		# wのgetter
		def w
			return @w
		end
		
		# wのsetter
		def w=(w)
			@w = w
		end
			
	end

	class Medium
		# メディアの縦方向の長さ
		@h
		# リサイズの方法
		@resize
		# メディアの横方向の長さ
		@w

		# イニシャライザ
		def initialize
			@h = nil
			@resize = nil
			@w = nil
		end

		# hのgetter
		def h
			return @h
		end
		
		# hのsetter
		def h=(h)
			@h = h
		end

		# resizeのgetter
		def resize
			return @resize
		end

		# resizeのsetter
		def resize=(resize)
			@resize = resize
		end

		# wのgetter
		def w
			return @w
		end
		
		# wのsetter
		def w=(w)
			@w = w
		end
			
	end

	class Small
		# メディアの縦方向の長さ
		@h
		# リサイズの方法
		@resize
		# メディアの横方向の長さ
		@w

		# イニシャライザ
		def initialize
			@h = nil
			@resize = nil
			@w = nil
		end

		# hのgetter
		def h
			return @h
		end
		
		# hのsetter
		def h=(h)
			@h = h
		end

		# resizeのgetter
		def resize
			return @resize
		end

		# resizeのsetter
		def resize=(resize)
			@resize = resize
		end

		# wのgetter
		def w
			return @w
		end
		
		# wのsetter
		def w=(w)
			@w = w
		end
			
	end
end
