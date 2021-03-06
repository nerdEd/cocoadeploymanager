#
#  Executable.rb
#  Deploy Manager
#
#  Created by Ed Schmalzle on 11/2/08.
#  Copyright (c) 2008 __MyCompanyName__. All rights reserved.
#

class Executable
	attr_accessor :path
	
	def initialize( path )
		@path = path
	end
	
	def name 
		if File.symlink? @path
			pertinent_path = File.readlink @path
		else
			pertinent_path = @path
		end
		pertinent_path.scan( /ASJVN-.../ )
	end
	
	def deploy( destination_path )
		unless File.symlink? @path
			executable_name = File.basename( File.expand_path( @path ), '.war' )
			extension = File.extname( File.expand_path( @path ) )
			new_link = destination_path + executable_name + extension
			File.symlink( File.expand_path( @path ), new_link )
		end
		return Executable.new( new_link )
	end
  
	def un_deploy
		if File.symlink? @path
			File.unlink( File.expand_path @path )
		end
		return self
	end  
	
	def find_base_file
		if File.symlink? @path
			return File.readlink @path
		else
			return @path
		end
	end
end