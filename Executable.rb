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
			base_path = File.readlink @path
			base_path.split( "/" ).reverse[3]
		else
			@path.split( "/" ).reverse[3]
		end
	end
	
	def deploy( destination_path )
	  unless File.symlink? @path
	    executable_name = File.basename File.expand_path( @path )
	    new_link = destination_path + '/' + executable_name
	    File.symlink( File.expand_path( @path ), new_link )
    end
    return self
  end
  
  def un_deploy
    if File.symlink? @path
      File.unlink( File.expand_path @path )
    end
    return self
  end  
end