require "./propertiesFile"

#--------------------------------------------------------------------- Get Build Configuration -------------------------------------------------------------------#

def getBuildConfigs()
	buildConfig = Hash.new
	branchname = sdkBranchName()
	buildConfig["branch"] = branchname
	config = "Debug"
	scheme_name = "UsabillaSystemTest"
	if index = branchname.downcase.index("release")
		config = "Release"
		scheme_name = "UsabillaSystemTestProd"
	end
	UI.important "#{config} Configuration Found!"
	UI.important "Scheme Found - #{scheme_name}"
	buildConfig["configuration"] = config
	buildConfig["scheme_name_test"] = scheme_name
	UI.important "buildConfig - #{buildConfig}"
	return buildConfig
end

#--------------------------------------------------------------------- Get Build Configuration End ---------------------------------------------------------------#

#------------------------------------------------------------------------ SDK Branch Name ------------------------------------------------------------------------#

def sdkBranchName()
	gitlabBranchname = ENV['CI_COMMIT_REF_NAME']
	if !gitlabBranchname.nil?
		then UI.important "Checking out gitlabBranchname #{gitlabBranchname}"
		return gitlabBranchname
	else 
		branchname = sh 'git name-rev --name-only HEAD | sed -e "s/^remotes\/origin\///"'
		UI.important "Checking out branchname #{branchname}"
		return branchname
	end
end

#--------------------------------------------------------------------- SDK Branch Name End -----------------------------------------------------------------------#