require 'mysql'

class MySQLConnector
	
	# MySQLに接続し、コネクションを返却する
	# @param [String] path 接続先アドレス
	# @param [String] username DBのユーザ名
	# @param [String] pass ユーザのパスワード
	# @param [String] dname データベース名
	# @return [Object] DBへのコネクション
	def self.connectDB( path, username, pass, dbname )
		mysql = Mysql.init
		mysql.options( Mysql::SET_CHARSET_NAME, 'utf8' )
		mysql.real_connect( path, username, pass, dbname )
		return mysql
	end

end
