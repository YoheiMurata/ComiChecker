require_relative './BaseDao'

# 本システムのユーザのDAO
class UserDao
	
	SQL_INSERT_USER = "INSERT INTO USER( USER_ID, USER_NAME, USER_MAIL_ADDR ) VALUES ( ?, ?, ? )"
	SQL_SELECT_USER_NAME_AND_ADDR = "SELECT USER_NAME, USER_MAIL_ADDR FROM USER WHERE USER_ID = ?"
	SQL_GET_USER_LIST = "SELECT USER_ID, USER_NAME, USER_MAIL_ADDR FROM USER WHERE USER_VALID = 1"
	
	# チェックをするユーザのリストを取得
	# @params[ Connection ] connection
	# @return[ Array ] ユーザの情報リスト（ユーザID、ユーザ名、メールアドレス）
	def self.getUserList( connection )
		return BaseDao.query( connection, SQL_GET_USER_LIST )
	end

	# ユーザを登録
	# 必要ない気がする・・・いずれユーザ管理機能のようなものを
	# 作る時までは保留 
	# @param[ Connection ] connection DBとのコネクション
	# @param[ Array ] params 以下の順番でデータが格納された配列
	#  params[ 0 ] : ユーザ名
	#  params[ 1 ] : 通知メール送信先メールアドレス
	# def registerUser( connection, *params )
	#	# ランダムなIDを生成
	#	id = ( 0...10 ).map{ ('0'..'9').to_a[ rand( 10 ) ] }.join.to_i
	#	p = []
	#	p.push( id )
	# 	params.each{ | i |
	#		p.push( i )
	#	}
	#	return BaseDao.execute( connection, SQL_INSER_USER, p )
	# end
	
end
