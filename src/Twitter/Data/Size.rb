# サイズの定義
class Size
	
	#画像の高さ（ピクセル）
	attr_accessor :h
	#リサイズのしかた.取りうるあたいは以下の２つ
	#fix:アスペクト比はそのままリサイズ	
	#crop: なんらかの事情によりトリミングされたもの
	attr_accessor :resize
	#画像の幅（ピクセル）
	attr_accessor :w

	# イニシャライザ
	def initialize( size )
		if( !size.kind_of?( Hash ) ) then
			raise ArgumentException.new( "Invalid Argument @Size.initialize" )
		end
		@h = size['h'].to_i
		@w = size['w'].to_i
		@resize = size['resize']
	end
end
