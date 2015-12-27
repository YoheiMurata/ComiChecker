class Contributor
	# Twitter ID
	@id
	@screen_name

	def initialize
		@id = nil
		@screen_name = nil
	end
	
	def id
		return @id
	end

	def id=(id)
		@id = id
	end

	def screen_name
		return @screen_name
	end
	
	def screen_name=(name)
		@screen_name = name
	end
end
