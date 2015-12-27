require 'mail'

require_relative '../Exception/ArgumentException'

# メールを送信するクラス
# Gmailのリレーを利用することを前提としている
class Mailer
	# ユーザ名
	@userName = nil
	# パスワード
	@password = nil
	# メールの送信者名
	@senderName = nil
	# メールの送信データ
	@mailData = nil

	# 定数
	MAIL_TO = 'mailTo'
	MAIL_BODY = 'mailBody' 
	MAIL_HTML_BODY = 'mailHTMLBody'
	MAIL_SUBJECT = 'mailSubject'

	# イニシャライザ
	def initialize( username, password, senderName, mailData )
		if( !mailData.kind_of?( Hash ) ) then
			raise ArgumentException.new( "Invalid Argument @Mailer.initialize" )
		end
		@userName = username
		@password = password
		
		@senderName = senderName
		@mailData = mailData
	end

	# メールを送信する
	# @param なし
	# @return なし
	def sendMail
		mailer = Mail.new	
		options = { 
			:address    => "smtp.gmail.com",
            		:port       => 587,
            		:domain     => @senderName,
            		:user_name  => @userName,
            		:password   => @password,
            		:authentication => :plain,
            		:enable_starttls_auto => true }		
		mailer.charset = 'utf-8'
		mailer.from = "#{ @senderName } <#{ @userName }>"
		mailer.to = @mailData[ MAIL_TO ]
		mailer.subject = @mailData[ MAIL_SUBJECT ]

		# debug
		puts "msildata: #{ @mailData[ MAIL_BODY ] }"		

		text = @mailData[ MAIL_BODY ]
		html = @mailData[ MAIL_HTML_BODY ]
		if( @mailData[ MAIL_HTML_BODY ] ) then
			text_part = Mail::Part.new do
				body text
			end
	
			html_part = Mail::Part.new do
				content_type 'text/html; charset=UTF-8'
				body html 
			end

			mailer.text_part = text_part
			mailer.html_part = html_part
		else
			mailer.body = @mailData[ MAIL_BODY ]
		end

		mailer.delivery_method(:smtp, options)
		mailer.deliver

	end
		
end
