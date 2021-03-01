require "./buildconfig"

desc "Build framework For a given XCode version"
private_lane :buildForXcodeVersion do |options|
	#configuration
	buildConfig = getBuildConfigs()
	version = options[:version]

	if version == nil	
		UI.message("'version' not specified in 'buildForXcodeVersion")
	elsif version.include? "12"
		archVariable = "EXCLUDED_ARCHS=arm64"
	else
		archVariable = ""
	end
	if options[:project_directory] == nil	
		UI.message("'project_directory' not specified in 'buildForXcodeVersion")
	end   

	version = options[:version]
	project_directory = options[:project_directory]

	paths = Paths.new(version, project_directory, buildConfig['configuration'])
	xcversion(version: version)

	sh("xcodebuild -derivedDataPath #{paths.projectDirectory}/build -project #{paths.projectDirectory}/Usabilla.xcodeproj -scheme #{paths.scheme_name} -configuration #{buildConfig['configuration']} -sdk iphoneos OTHER_CFLAGS=-fembed-bitcode BITCODE_GENERATION_MODE=bitcode GCC_INSTRUMENT_PROGRAM_FLOW_ARCS=NO BUILD_LIBRARY_FOR_DISTRIBUTION=YES CLANG_ENABLE_CODE_COVERAGE=NO SWIFT_SERIALIZE_DEBUGGING_OPTIONS=NO")
	sh("xcodebuild -derivedDataPath #{paths.projectDirectory}/build -project #{paths.projectDirectory}/Usabilla.xcodeproj -scheme #{paths.scheme_name} -configuration #{buildConfig['configuration']}  -sdk iphonesimulator OTHER_CFLAGS=-fembed-bitcode-marker BITCODE_GENERATION_MODE=bitcode GCC_INSTRUMENT_PROGRAM_FLOW_ARCS=NO BUILD_LIBRARY_FOR_DISTRIBUTION=YES CLANG_ENABLE_CODE_COVERAGE=NO SWIFT_SERIALIZE_DEBUGGING_OPTIONS=NO #{archVariable}")

	#remove Module name error in swiftinterface files
	sh("find \"#{paths.projectDirectory}/build/Build/Products/#{buildConfig['configuration']}-iphoneos/#{paths.framework_name}/Modules/Usabilla.swiftmodule/\" -name \"*.swiftinterface\" -exec sed -i -e 's/Usabilla\\.//g' {} \\;") 
	sh("find \"#{paths.projectDirectory}/build/Build/Products/#{buildConfig['configuration']}-iphonesimulator/#{paths.framework_name}/Modules/Usabilla.swiftmodule/\" -name \"*.swiftinterface\" -exec sed -i -e 's/Usabilla\\.//g' {} \\;") 
end

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
		UI.message("'version' not specified in 'buildForXcodeVersion")
	elsif version.include? "12"
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

desc "Copy artefacts to the Pods directory"
private_lane :copyToPodsFromBuild do |options|
	#configuration
	buildConfig = getBuildConfigs()

	if options[:version] == nil	
		UI.message("'version' not specified in 'copyToPodsFromBuild")
	end   
	if options[:project_directory] == nil	
		UI.message("'project_directory' not specified in 'copyToPodsFromBuild")
	end   
	version = options[:version]
	project_directory = options[:project_directory]
	paths = Paths.new(version, project_directory, buildConfig['configuration'])

	sh("rm -rf #{projectDirectory}#{paths.xcode_directory}/#{paths.pods_directory}")
	sh("mkdir -p #{paths.framework_path}")

	sh("lipo -create -output \"#{paths.framework_outputFile}\" \"#{paths.iphoneos_outputFile}\" \"#{paths.simulator_outputFile}\"")
	sh("dsymutil -o=\"#{paths.framework_path}.dSYM\" \"#{paths.framework_outputFile}\"")
	sh("cp #{paths.iphoneos_path}/Assets.car #{paths.framework_path}/." )
	sh("cp #{paths.iphoneos_path}/Info.plist #{paths.framework_path}/." )
	sh("cp #{paths.iphoneos_path}/usa_localizable.strings #{paths.framework_path}/." )
	sh("cp -rf #{paths.iphoneos_path}/Headers #{paths.framework_path}/." )
	sh("cp -rf #{paths.iphoneos_path}/Modules #{paths.framework_path}/." )
	sh("cp -rf #{paths.simulator_path}/Modules/* #{paths.framework_path}/Modules/." )
	sh("cd #{projectDirectory}#{paths.xcode_directory}/#{paths.pods_directory}/ && zip -r ./#{paths.podsFileName} .")
end

desc "Copy artefacts to the Carthage directory"
private_lane :copyToCarthageFromBuild do |options|
	#configuration
	buildConfig = getBuildConfigs()
	if options[:version] == nil	
		UI.message("'version' not specified in 'copyToCarthageFromBuild")
	end   
	if options[:project_directory] == nil	
		UI.message("'project_directory' not specified in 'copyToCarthageFromBuild")
	end   

	version = options[:version]
	project_directory = options[:project_directory]
	paths = Paths.new(version, project_directory, buildConfig['configuration'])
	sh("mkdir -p #{paths.projectDirectory}#{paths.xcode_directory}/Carthage/Carthage/Build/iOS")

	sh("cp -rf #{paths.framework_path} #{paths.carthage_outputPath}/." )
	sh("cp -rf #{paths.carthage_dSYMPath}/*.dSYM #{paths.carthage_outputPath}/." )
	sh("cp #{paths.carthage_symbolsPath}/*.bcsymbolmap #{paths.carthage_outputPath}/." )
	sh("cd #{paths.carthage_path}/ && zip -r #{paths.carthage_path}/#{paths.carthageFileName} Carthage/")
	sh("rm -rf #{paths.carthage_path}/Carthage")
end

desc "Copy artefacts to the Swift Package directory"
private_lane :copyToSwiftPackage do
	sh("find \"#{projectDirectory}XcodeBuilds/xcframeworks/Usabilla.xcframework/\" -name \"*.swiftinterface\" -exec sed -i -e 's/Usabilla\\.//g' {} \\;")
	sh("rm -rf #{projectDirectory}UsabillaSDK/Usabilla.xcframework")
	sh("cp -rf #{projectDirectory}XcodeBuilds/xcframeworks/Usabilla.xcframework #{projectDirectory}UsabillaSDK/Usabilla.xcframework")
	sh("cd #{projectDirectory}XcodeBuilds/xcframeworks && zip -r ./UsabillaXCFramework.zip ./Usabilla.xcframework ./Usabilla.dSYMs")
	CHECKSUM = sh("cd #{projectDirectory}UsabillaSDK && swift package compute-checksum #{projectDirectory}XcodeBuilds/xcframeworks/Usabilla.xcframework.zip | xargs")
	sh("echo '#{CHECKSUM}' > #{projectDirectory}XcodeBuilds/xcframeworks/CHECKSUM.txt")
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
	name = "v#{version}-Xcode-#{xcode}"
	UI.message("Creating for #{name}")
	carthage = "XcodeBuilds/Xcode-#{xcode}/Carthage/UsabillaCarthage.zip"
	pods = "XcodeBuilds/Xcode-#{xcode}/Pods/UsabillaPods.zip"
	assets = ["#{carthage}","#{pods}"]
	if branch == "master"
		xcframework = "XcodeBuilds/xcframeworks/UsabillaXCFramework.zip"
		assets = ["#{carthage}","#{pods}","#{xcframework}"]
	end
	set_github_release(
		repository_name: "usabilla/usabilla-u4a-ios-swift-sdk",
		name: name,
		tag_name: name,
		is_draft: true,
		description: (File.read("../changelog") rescue "No changelog provided"),
		api_token: "2d12a433ea301e041de5dbdd82902a5108b7aee5",
		commitish: branch,
		upload_assets: assets
	)
end