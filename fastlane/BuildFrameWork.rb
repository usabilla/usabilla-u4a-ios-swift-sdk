require "./buildconfig"

private_lane :buildAndRunUITest do |options|

	#configuration
	buildConfig = getBuildConfigs()

	if options[:version] == nil
		UI.message("'version' not specified in 'buildAndRunUITest")
	end
	if options[:devices] == nil
		UI.message("'devices' not specified in 'buildAndRunUITest")
	end

	if options[:project_directory] == nil
		UI.message("'project_directory' not specified in 'buildAndRunUITest")
	end

	version =  options[:version]
	project_directory = options[:project_directory]
	devices = options[:devices]
	paths = Paths.new(version, project_directory, buildConfig['configuration'])
	xcversion(version: version)

	sh("xcodebuild clean -workspace #{paths.projectDirectory}/Usabilla.xcworkspace -scheme #{paths.scheme_name} -configuration #{buildConfig['configuration']} -sdk iphonesimulator")
	sh("xcodebuild build -workspace #{paths.projectDirectory}/Usabilla.xcworkspace -scheme #{paths.scheme_name} -configuration #{buildConfig['configuration']} -sdk iphonesimulator")

	devices.each do |deviceModel|
		sh("xcodebuild  test -workspace #{paths.projectDirectory}/Usabilla.xcworkspace -scheme UsabillaUITestApp -destination '#{deviceModel}'")
	end

end

private_lane :removeAllBuilds do |options|
	#configuration
	buildConfig = getBuildConfigs()
	if options[:version] == nil
		UI.message("'version' not specified in 'buildForXcodeVersion")
	end
	if options[:project_directory] == nil
		UI.message("'project_directory' not specified in 'buildForXcodeVersion")
	end
	version = options[:version]
	project_directory = options[:project_directory]
	paths = Paths.new(version, project_directory, buildConfig['configuration'])

	UI.message("Remove all previous builds before build")
	sh("rm -rf #{paths.projectDirectory}/build")

end

desc "Vallidate build with UsabillaSystemTest app"
private_lane :systemTestsAfterBuild do |options|
	#configuration
	buildConfig = getBuildConfigs()
	version = options[:version]
	validateBuildLLVMGCC(version: version)
	project_directory = options[:project_directory]
	paths = Paths.new(version, project_directory, buildConfig['configuration'])

	if version == nil
		UI.message("'version' not specified in 'systemTestsAfterBuild")
    elsif version.include?("12") || version.include?("13")
		archVariable = "VALIDATE_WORKSPACE=YES EXCLUDED_ARCHS=arm64"
	else
		archVariable = ""
	end

	#Copy the newly created artefacts to the UsabillaSystemTest direcotry
	sh("rm -rf #{paths.projectDirectory}/automation/UsabillaSystemTest/UsabillaSystemTest/#{paths.framework_name}")
	sh("cp -rf #{paths.projectDirectory}#{paths.xcode_directory}/Pods/#{paths.framework_name} #{paths.projectDirectory}/automation/UsabillaSystemTest/UsabillaSystemTest/.")
	xcversion(version: version)
	sh("xcodebuild clean -project #{paths.projectDirectory}/automation/UsabillaSystemTest/UsabillaSystemTest.xcodeproj -scheme #{buildConfig['scheme_name_test']} -configuration #{buildConfig['configuration']} -sdk iphonesimulator -destination '#{uiTestDevices.first}' #{archVariable} test")

	# scan(
	# 	project: './automation/UsabillaSystemTest/UsabillaSystemTest.xcodeproj',
	# 	scheme: buildConfig['scheme_name_test'],
	# 	clean: true,
	# 	devices: unitTestDevices,
	# 	slack_only_on_failure: true
	# )
end

#used in lane  "validateAll"
desc "Validate integrating the framework (with specified version) into a sample project"
private_lane :validateSDK do |options|
	unless options[:version]
		UI.error("missing Xcode version")
	end
	version = options[:version]
	UI.message("Validating for Xcode-#{version}")
	configuration = options[:configuration]
	UI.message("Validating for #{configuration} configuration")

	# if version == nil
	# 	UI.message("'version' not specified in 'validateSDK")
    # elsif version.include?("12") || version.include?("13")
	# 	archVariable = "VALIDATE_WORKSPACE=YES EXCLUDED_ARCHS=arm64"
	# else
	# 	archVariable = ""
	# end

	resetSimulator
	xcversion(version: version)
	framework_path = "#{projectDirectory}/XcodeBuilds/Xcode-#{version}/xcframeworks"
	cleanReleaseProject
	sh("unzip -d #{framework_path}/ #{framework_path}/UsabillaXCFramework.zip && cp -r #{framework_path}/Usabilla.xcframework #{projectDirectory}automation/ReleaseValidator/ReleaseValidator && rm -rf #{framework_path}/Usabilla.xcframework")

	scan(
		configuration: configuration,
		project: 'automation/ReleaseValidator/ReleaseValidator.xcodeproj',
		clean: true,
		devices: unitTestDevices,
		slack_only_on_failure: true
	)
	#sh("xcodebuild clean -project #{projectDirectory}automation/ReleaseValidator/ReleaseValidator.xcodeproj -scheme ReleaseValidator -configuration #{configuration} -sdk iphonesimulator -destination '#{uiTestDevices.first}' #{archVariable} test")
	cleanReleaseProject
	resetSimulator
end

desc "Vallidate build for non LLVM and GCC code"
private_lane :validateBuildLLVMGCC do |options|
	#configuration
	buildConfig = getBuildConfigs()

	if options[:version] == nil
		UI.message("'version' not specified in 'validateBuildLLVMGCC")
	end
	if options[:project_directory] == nil
		UI.message("'project_directory' not specified in 'validateBuildLLVMGCC")
	end
	version = options[:version]
	project_directory = options[:project_directory]
	paths = Paths.new(version, project_directory, buildConfig['configuration'])

	sh("sh validateLLVM_NO_GCC.sh #{paths.framework_path}/")
end

desc "Copy artefacts to the Swift Package directory"
private_lane :copyToSwiftPackage do |options|
	version = options[:version]
	sh("find \"#{projectDirectory}XcodeBuilds/Xcode-#{version}/xcframeworks/Usabilla.xcframework/\" -name \"*.swiftinterface\" -exec sed -i -e 's/Usabilla\\.//g' {} \\;")
	sh("cd #{projectDirectory}XcodeBuilds/Xcode-#{version}/xcframeworks && zip -r ./UsabillaXCFramework.zip ./Usabilla.xcframework")
	CHECKSUM = sh("shasum -a 256  #{projectDirectory}XcodeBuilds/Xcode-#{version}/xcframeworks/UsabillaXCFramework.zip | sed 's/ .*//'")
	sh("echo '#{CHECKSUM}' > #{projectDirectory}XcodeBuilds/Xcode-#{version}/xcframeworks/CHECKSUM.txt")
	sh("cd #{projectDirectory}XcodeBuilds/Xcode-#{version}/xcframeworks/ && find . -not -name UsabillaXCFramework.zip -not -name CHECKSUM.txt -delete")
	if version == masterXcodeVersion
		sh("mkdir -p #{projectDirectory}XcodeBuilds/master && cp -rf #{projectDirectory}XcodeBuilds/Xcode-#{version}/xcframeworks/UsabillaXCFramework.zip #{projectDirectory}XcodeBuilds/master/UsabillaXCFramework.zip")
	end
end

desc "Copy artefacts to the Swift Package directory"
private_lane :copyToCSSwiftPackage do |options|
	version = options[:version]
	sh("find \"#{projectDirectory}XcodeBuilds/Xcode-#{version}/CSXCFrameworks/UsabillaCS.xcframework/\" -name \"*.swiftinterface\" -exec sed -i -e 's/Usabilla\\.//g' {} \\;")
	sh("cd #{projectDirectory}XcodeBuilds/Xcode-#{version}/CSXCFrameworks && zip -r ./UsabillaCSXCFramework.zip ./UsabillaCS.xcframework")
	CHECKSUM = sh("shasum -a 256  #{projectDirectory}XcodeBuilds/Xcode-#{version}/CSXCFrameworks/UsabillaCSXCFramework.zip | sed 's/ .*//'")
	sh("echo '#{CHECKSUM}' > #{projectDirectory}XcodeBuilds/Xcode-#{version}/CSXCFrameworks/CHECKSUM.txt")
	sh("cd #{projectDirectory}XcodeBuilds/Xcode-#{version}/CSXCFrameworks/ && find . -not -name UsabillaCSXCFramework.zip -not -name CHECKSUM.txt -delete")
	if version == masterXcodeVersion
		sh("mkdir -p #{projectDirectory}XcodeBuilds/master && cp -rf #{projectDirectory}XcodeBuilds/Xcode-#{version}/CSXCFrameworks/UsabillaCSXCFramework.zip #{projectDirectory}XcodeBuilds/master/UsabillaCSXCFramework.zip")
	end
end

desc "Copy artefacts to the github public repository and create draft release"
private_lane :createAReleaseDraft do |options|
	unless options[:xcode]
		UI.error("missing Xcode version")
	end
	unless options[:version]
		UI.error("missing version")
	end
	xcode = options[:xcode]
	version = options[:version]
	branch = options[:branch]
    tag = "#{version}-Xcode-#{xcode}"
	UI.message("Creating for #{tag}")
	xcframework = "XcodeBuilds/Xcode-#{xcode}/xcframeworks/UsabillaXCFramework.zip"
	assets = ["#{xcframework}"]
	if branch == "master"
        tag = "#{version}"
	end
    name = "v#{tag}"
	git_token = "893008a57b830b2cd3f4d6d337c86fafb7d0c6b6"
	user_name = "hiteshjain29"

	repo_dir = "usabilla-u4a-ios-swift-sdk"
	repo_name = "usabilla/#{repo_dir}"
	repo_path = "github.com/#{repo_name}"
	git_url = "https://#{repo_path}"
	git_push_url = "https://#{user_name}:#{git_token}@#{repo_path}.git"
	source_url = "https://#{repo_path}/releases/download/#{name}/UsabillaXCFramework.zip"

	sh("mkdir -p #{projectDirectory}publicrepo && cd #{projectDirectory}publicrepo && git clone #{git_url} && cd #{repo_dir} &&
	if [[ #{branch} == 'master' ]]; then checksum=`cat #{projectDirectory}XcodeBuilds/Xcode-#{xcode}/xcframeworks/CHECKSUM.txt` &&
		sed -i '' -e '/version =/ s/= .*/= \"#{version}\"/; /checksum =/ s/= .*/= \"'$checksum'\"/' ./Package.swift; \
	else git checkout --track origin/#{branch}  &&
		checksum=`cat #{projectDirectory}XcodeBuilds/Xcode-#{xcode}/xcframeworks/CHECKSUM.txt` &&
		sed -i '' -e '/version =/ s/= .*/= \"#{tag}\"/; /checksum =/ s/= .*/= \"'$checksum'\"/' ./Package.swift; \
	fi &&
	cat #{projectDirectory}changelog ./CHANGELOG.MD > temp && mv temp ./CHANGELOG.MD && cat #{projectDirectory}PublicReadme.md  > ./Readme.MD &&
	sed -i '' -e '/version =/ s/= .*/= \"#{tag}\"/' ./Usabilla.podspec && jq '{ \"#{version}\" : \"#{source_url}\" } + .' Usabilla.json >tmp.json &&
	mv tmp.json Usabilla.json &&
	git add . && git commit -m \"Release #{version}\" && git diff --stat --cached origin/#{branch} && git push #{git_push_url} &&
	rm -rf #{projectDirectory}publicrepo")
    UI.message("Drafting Release for #{tag}")
	set_github_release(
		repository_name: repo_name,
		name: name,
		tag_name: name,
		is_draft: true,
		description: (File.read("../changelog") rescue "No changelog provided"),
		api_token: git_token,
		commitish: branch,
		upload_assets: assets
	)
end
