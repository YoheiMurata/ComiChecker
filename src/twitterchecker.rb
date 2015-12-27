require_relative './Twitter/Twitter'
require_relative './Twitter/Data/Statuses'
require_relative './Twitter/Data/EmbededTweet'
require_relative './DBConnector/MySQLConnector'
require_relative './DAO/TwitterUserDao'
require_relative './Mailer/Mailer'
require_relative './DAO/UserDao'
require_relative './DAO/TweetDao'
require_relative './DAO/KeywordDao'
require_relative './FileDownloader/FileDownloader'
require 'erb'

PATH = 'IMAGE_DIRECTORY'

TWITTER_CONSUMER_KEY = 'YOUR_TWITTER_CONSUMER_KEY'
TWITTER_CONSUMER_SECRET = 'YOUR_TWITTER_CONSUMER_SECRET'

ERB_FILE = '../../template/OshiraseMail.erb'

checker = Twitter.new( TWITTER_CONSUMER_KEY, TWITTER_CONSUMER_SECRET )
connection = MySQLConnector.connectDB( 'YOUR_DB_HOST', 'YOUR_DB_USER_NAME', 'YOUR_DB_USER_PASS', 'DB_NAME' )

checker.authorize 

searchUserList = TwitterUserDao.searchCheckUser( connection )

checker.authorize 

# キーワードを検索
mailText = "#{ DateTime.now }時点でのサークル情報を報告します"
mailHTMLText = ''
mailBodyData = []

searchUserList.each{ |user|
	
	# 最新のツイートのIDを手にいれる
	tweetList = TweetDao.getLatestTweet( connection, user[ 0 ] )
	# ユーザ名を表示
	puts "USERNAME: #{ user[ 1 ] }"

	since_id = nil
	tweetList.each{ |tweet|
		since_id = tweet[ 0 ]
	}

	result = nil
	if since_id then
		result = checker.getTimelineWithSinceId( user[ 0 ], since_id.to_s, '100' )
	else
		result = checker.getTimeline( 'user_id', user[ 0 ] , '100' )
	end
	
	status = Statuses.new( result )
	status.statuses.each{ |tweet|
		tweetResult = TweetDao.searchTweet( connection, tweet.id )
			
		isRegistered = false

		tweetResult.each{ |result|
			isRegistered = true
		}

		tweetData = []
		tweetData.push( tweet.id )
		tweetData.push( tweet.text )
		tweetData.push( tweet.created_at.strftime )
		tweetData.push( tweet.user.id )

		if !isRegistered then	
			TweetDao.insertTweet( connection, *tweetData )
		end

		localpath = ""
		if tweet.entities.media then
			tweet.entities.media.each{ |m|
				localpath = FileDownloader.downloadFile( m.media_url_https, PATH )
				mediaData = []
				mediaData.push( tweet.id )
				mediaData.push( localpath )
				mediaData.push( m.media_url_https )
				TweetDao.insertMedia( connection, *mediaData )
			}
		end

	}
}

searchResult = TweetDao.getSearchTweet( connection, 60.0 )

searchResult.each{ |element|
	tmp = EmbededTweet.new( checker.getTweetEmbed( element[ 0 ].to_s ) )
	# debug
	puts '================================='
	puts 'debug'
	puts tmp.html
	puts tmp.author_name
	puts '================================='
	mailBodyData.push( tmp )
}

erb = ERB.new( File.read( ERB_FILE ) )
erb.filename = ERB_FILE

mailData = { 'mailTo' => 'fullmetaljacket893@gmail.com', 'mailSubject' => 'サークル情報更新報告' }

# DEBUG
mailBodyData.each{ |element|
	puts element.html
}

mailData[ 'mailBody' ] = mailText
mailData[ 'mailHTMLBody' ] = erb.result( binding )

userName = 'YOUR_RELAY_USER_EMAIL_ADDR'
userPass = 'YOUR_RELAY_USER_EMAIL_PASS'
senderName = 'サークル情報報告バッチ'

mail = Mailer.new( userName, userPass, senderName, mailData )
mail.sendMail

checker.invalidateToken


