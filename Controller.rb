#
#  Controller.rb
#  Deploy Manager
#
#  Created by Ed Schmalzle on 10/29/08.
#  Copyright (c) 2008 __MyCompanyName__. All rights reserved.
#

require 'find'

class Controller
	
	attr_writer :availableApplicationsTableView, :deployedApplicationsTableView, :searchBaseTextField, :deployDirectoryTextField, :deployedStatusIndicator, :availableStatusIndicator
	
	# Called when the UI loads, setup all outlets.
	def awakeFromNib
		@availableApplications = Array.new
		@deployedApplications = Array.new
	
    @availableApplicationsTableView.dataSource = self
    @deployedApplicationsTableView.dataSource = self		
		
		@searchBaseTextField.stringValue = '/Users/edwards/Development/workspaces/V9/JIRAS/'
		@deployDirectoryTextField.stringValue = '/Users/edwards/Applications/jboss-4.2.2.GA/server/default/deploy/'		
  end
	
	def refreshApplications( sender )		
		populate_application_lists		
		reload_table_views
	end
	
	def reload_table_views
		@availableApplicationsTableView.reloadData
		@deployedApplicationsTableView.reloadData
	end
	
	def deployApplication( sender )
		if @deployedApplications.empty? 
			selected_row_index = @availableApplicationsTableView.selectedRow
			undeployed_executable = @availableApplications[ selected_row_index ]
			undeployed_executable.deploy @deployDirectoryTextField.stringValue
			@availableApplications.delete_at( selected_row_index )
			@deployedApplications << undeployed_executable
			reload_table_views
		end
	end
	
	def unDeployApplication( sender ) 
		selected_row_index = @deployedApplicationsTableView.selectedRow
		deployed_executable = @deployedApplications[ selected_row_index ]
		deployed_executable.un_deploy
		#new_undeployed = File.readlink( File.expand_path deployed_executable.path )
		@deployedApplications.delete_at( selected_row_index )
		#@availableApplications << Executable.new( new_undeployed )
		reload_table_views
	end
	
	def numberOfRowsInTableView( view )
		if view == @availableApplicationsTableView
			@availableApplications.size
		else
			@deployedApplications.size
		end
  end
  
  def tableView(view, objectValueForTableColumn:column, row:index)    
		if view == @availableApplicationsTableView
			currentApplication = @availableApplications[ index ]
		else
			currentApplication = @deployedApplications[ index ]
		end
		
    case column.identifier
      when 'path'
        currentApplication.name	
    end
  end
	
	def populate_application_lists	
		@availableApplications = find_executables( File.expand_path @searchBaseTextField.stringValue )
		@deployedApplications = find_deployed_executables( File.expand_path @deployDirectoryTextField.stringValue )
	end
	
	def find_executables( path )
		executables = Array.new
		Find.find( path ) do | current_path |
			if File.file?( current_path ) && current_path.include?( '.war' )
				executables << Executable.new( current_path )
			end
		end
		return executables
	end		
	
	def find_deployed_executables( path )
		executables = Array.new
		Find.find( path ) do | current_path |
			if File.file?( current_path ) && current_path.include?( '.war' ) && File.symlink?( current_path )
				executables << Executable.new( current_path )
			end
		end
		return executables
	end		
	
end