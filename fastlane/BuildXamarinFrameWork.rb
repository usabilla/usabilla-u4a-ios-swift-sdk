require "./buildconfig"

desc "Build framework For a given XCode version"
private_lane :buildForXamarin do |options|
    #configuration
    buildConfig = getBuildConfigs()
    version = options[:version]

    if version == nil
        UI.message("'version' not specified in 'buildForXcodeVersion")
    elsif version.include? "12"
        archVariable = "EXCLUDED_ARCHS=arm64 i386"
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

	sh("xcodebuild -derivedDataPath #{paths.projectDirectory}/build -project #{paths.projectDirectory}/Usabilla.xcodeproj -scheme #{paths.scheme_xamarin_name} -configuration #{buildConfig['configuration']} -sdk iphoneos OTHER_CFLAGS=-fembed-bitcode BITCODE_GENERATION_MODE=bitcode GCC_INSTRUMENT_PROGRAM_FLOW_ARCS=NO BUILD_LIBRARY_FOR_DISTRIBUTION=YES CLANG_ENABLE_CODE_COVERAGE=NO SWIFT_SERIALIZE_DEBUGGING_OPTIONS=NO")
	sh("xcodebuild -derivedDataPath #{paths.projectDirectory}/build -project #{paths.projectDirectory}/Usabilla.xcodeproj -scheme #{paths.scheme_xamarin_name} -configuration #{buildConfig['configuration']}  -sdk iphonesimulator OTHER_CFLAGS=-fembed-bitcode-marker BITCODE_GENERATION_MODE=bitcode GCC_INSTRUMENT_PROGRAM_FLOW_ARCS=NO BUILD_LIBRARY_FOR_DISTRIBUTION=YES CLANG_ENABLE_CODE_COVERAGE=NO SWIFT_SERIALIZE_DEBUGGING_OPTIONS=NO #{archVariable}")

	#remove Module name error in swiftinterface files
	sh("find \"#{paths.projectDirectory}/build/Build/Products/#{buildConfig['configuration']}-iphoneos/#{paths.framework_xamarin_name}/Modules/#{paths.scheme_xamarin_name}.swiftmodule/\" -name \"*.swiftinterface\" -exec sed -i -e 's/Usabilla\\.//g' {} \\;") 
	sh("find \"#{paths.projectDirectory}/build/Build/Products/#{buildConfig['configuration']}-iphonesimulator/#{paths.framework_xamarin_name}/Modules/#{paths.scheme_xamarin_name}.swiftmodule/\" -name \"*.swiftinterface\" -exec sed -i -e 's/Usabilla\\.//g' {} \\;") 
end

private_lane :buildForXamarinAndRunUITest do |options|

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

	sh("xcodebuild clean -workspace #{paths.projectDirectory}/Usabilla.xcworkspace -scheme #{paths.scheme_xamarin_name} -configuration #{buildConfig['configuration']} -sdk iphonesimulator")
	sh("xcodebuild build -workspace #{paths.projectDirectory}/Usabilla.xcworkspace -scheme #{paths.scheme_xamarin_name} -configuration #{buildConfig['configuration']} -sdk iphonesimulator")

	devices.each do |deviceModel|
		sh("xcodebuild  test -workspace #{paths.projectDirectory}/Usabilla.xcworkspace -scheme UsabillaUITestApp -destination '#{deviceModel}'")
	end

end

desc "Vallidate build for non LLVM and GCC code" 
private_lane :validateXamarinBuildLLVMGCC do |options|
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

	sh("sh validateLLVM_NO_GCC.sh #{paths.framework_xamarin_path}/")
end

desc "Copy artefacts to the Pods directory"
private_lane :copyToPodsFromXamarinBuild do |options|
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

	sh("rm -rf #{projectDirectory}#{paths.xcode_directory}/#{paths.pods_xamarin_directory}")
	sh("mkdir -p #{paths.framework_xamarin_path}")

	sh("lipo -create -output \"#{paths.framework_xamarin_outputFile}\" \"#{paths.iphoneos_xamarin_outputFile}\" \"#{paths.simulator_xamarin_outputFile}\"")
	sh("dsymutil -o=\"#{paths.framework_xamarin_path}.dSYM\" \"#{paths.framework_xamarin_outputFile}\"")
	sh("cp #{paths.iphoneos_xamarin_path}/Assets.car #{paths.framework_xamarin_path}/." )
	sh("cp #{paths.iphoneos_xamarin_path}/Info.plist #{paths.framework_xamarin_path}/." )
	sh("cp #{paths.iphoneos_xamarin_path}/usa_localizable.strings #{paths.framework_xamarin_path}/." )
	sh("cp -rf #{paths.iphoneos_xamarin_path}/Headers #{paths.framework_xamarin_path}/." )
	sh("cp -rf #{paths.iphoneos_xamarin_path}/Modules #{paths.framework_xamarin_path}/." )
	sh("cp -rf #{paths.simulator_xamarin_path}/Modules/* #{paths.framework_xamarin_path}/Modules/." )
end
