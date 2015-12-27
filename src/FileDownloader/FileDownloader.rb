require 'open-uri'

class FileDownloader

	# URLをファイルとして保存する
	# @param [String] url ファイルのURL
	# @param [String] path 保存先のパス。
	#  /を末尾につけた状態
	# @return [String] 保存したファイルのパス
	def self.downloadFile( url, path )
		filename = File.basename( url )
		
		# wbはバイナリ形式で書き込むという意味
		open( path + filename, 'wb' ) do | output |
			open( url ) do | data |
				output.write( data.read )
			end
		end
		return path + filename
	end
end	
