require 'mysql'

# DAOのベースになるもの
class BaseDao

	# SQLを実行
	# keysがnilでも大丈夫か、配列でも大丈夫か検証する必要が有る
	def self.execute( connection, sql, *keys )
		# sql内の動的な部分は?にしてある
		statement = connection.prepare( sql )
		# ?を左から順番に埋める値の配列
		result = statement.execute( *keys )
		return result
	end

	# SQLを実行
	# ?パラメータを使用しない場合の処理
	def self.query( connection, sql )
		return connection.query( sql )
	end

end
