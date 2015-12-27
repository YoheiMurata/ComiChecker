require_relative './BaseDao'

# Twitterで検索をかけるキーワードを扱うクラス
class KeywordDao
	
	# キーワード
	SQL_GET_KEYWORD_LIST = 
		'SELECT KEYWORD FROM KEYWORD
		WHERE VALID_START < ? AND VALID_END > ? 
		AND VALID = 1'
	
	# キーワードを検索する
	# @param[ Connection ] DBへのコネクション
	# @param[ String ] 検索するキーワードの基準日時
	# @return[ Array ] キーワードのリスト
	def self.getKeywordList( connection, date )
		params = []
		params.push( date )
		params.push( date )
		return BaseDao.execute( connection, SQL_GET_KEYWORD_LIST, *params )
	end
end 
