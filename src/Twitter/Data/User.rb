# Twitterのユーザ定義
class User
	# ユーザのTwitter ID
	attr_accessor :id
	# ユーザの現在のTwitter上の表記名
	# (@が付いてないやつ）
	# ここはイベントの旅コロコロ変わるので、
	# 最初以外はユーザが入力し、アップデートは自動で
	# 行わないこととする
	attr_accessor :name
	# ユーザのプロファイルについてる
	# 画像のURL
	attr_accessor :profile_image_url
	# profile_image_urlのhttps通信版。
	attr_accessor :profile_image_url_https
	# ユーザ名（@がついてるやつ）
	attr_accessor :screen_name
	
	def initialize( user )
		if( !user.kind_of?( Hash ) ) then
			raise ArgumentException.new( "invalid argument @User.initialize")
		end

		@id = user['id'].to_i
		@name = user['name']
		@profile_image_url = user['profile_image_url']
		@profile_image_url_https = user['profile_image_url_https']
		@screen_name = user['screen_name']
	end
end
