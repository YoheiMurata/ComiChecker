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

end
