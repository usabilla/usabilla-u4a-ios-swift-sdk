import "./propertiesFile.rb"

desc "Build framework For a given XCode version"
private_lane :buildForXcodeVersion do |options|
  testAndChangeURLS
  if options[:version] == nil	
    UI.message("'version' not specified in 'buildForXcodeVersion")
  end
	if options[:project_directory] == nil	
    UI.message("'project_directory' not specified in 'buildForXcodeVersion")
  end   

  version = options[:version]
  project_directory = options[:project_directory]

  paths = Paths.new(version, project_directory)
 	xcversion(version: version)

	sh("xcodebuild -derivedDataPath #{paths.projectDirectory}/build -project #{paths.projectDirectory}/Usabilla.xcodeproj -scheme Usabilla -configuration Release -sdk iphoneos OTHER_CFLAGS=-fembed-bitcode BITCODE_GENERATION_MODE=bitcode GCC_INSTRUMENT_PROGRAM_FLOW_ARCS=NO CLANG_ENABLE_CODE_COVERAGE=NO ")
	sh("xcodebuild -derivedDataPath #{paths.projectDirectory}/build -project #{paths.projectDirectory}/Usabilla.xcodeproj -scheme Usabilla -configuration Release  -sdk iphonesimulator OTHER_CFLAGS=-fembed-bitcode-marker BITCODE_GENERATION_MODE=bitcode GCC_INSTRUMENT_PROGRAM_FLOW_ARCS=NO CLANG_ENABLE_CODE_COVERAGE=NO ")
end

private_lane :buildAndRunUITest do |options|

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
	
  	paths = Paths.new(version, project_directory)
 	xcversion(version: version)

	sh("xcodebuild clean -workspace #{paths.projectDirectory}/Usabilla.xcworkspace -scheme Usabilla -configuration Debug -sdk iphonesimulator")
	sh("xcodebuild build -workspace #{paths.projectDirectory}/Usabilla.xcworkspace -scheme Usabilla -configuration Debug -sdk iphonesimulator")

    devices.each do |deviceModel|
		sh("xcodebuild  test -workspace #{paths.projectDirectory}/Usabilla.xcworkspace -scheme UsabillaUITestApp -destination '#{deviceModel}'")
        end

end

private_lane :removeAllBuilds do |options|
  	if options[:version] == nil	
   	 	UI.message("'version' not specified in 'buildForXcodeVersion")
  	end
		if options[:project_directory] == nil	
   	 	UI.message("'project_directory' not specified in 'buildForXcodeVersion")
  	end   
  	version = options[:version]
  	project_directory = options[:project_directory]
  	paths = Paths.new(version, project_directory)

 	UI.message("Remove all previous builds before build")
	sh("rm -rf #{paths.projectDirectory}/build")

end

desc "Vallidate build with UsabillaSystemTest app" 
private_lane :systemTestsAfterBuild do |options|
  version = options[:version]
  validateBuildLLVMGCC(version: version)
  project_directory = options[:project_directory]
  paths = Paths.new(version, project_directory)

#Copy the newly created artefacts to the UsabillaSystemTest direcotry
	sh("rm -rf #{paths.projectDirectory}/automation/UsabillaSystemTest/UsabillaSystemTest/#{paths.framework_name}")
	sh("cp -rf #{paths.projectDirectory}#{paths.xcode_directory}/Pods/#{paths.framework_name} #{paths.projectDirectory}/automation/UsabillaSystemTest/UsabillaSystemTest/.")
    xcversion(version: version)
        scan(
            project: './automation/UsabillaSystemTest/UsabillaSystemTest.xcodeproj',
            scheme: "UsabillaSystemTest",
            clean: true,        
            devices: [ "iPhone X (11.4)"]
    )
end

desc "Vallidate build for non LLVM and GCC code" 
private_lane :validateBuildLLVMGCC do |options|

	if options[:version] == nil	
     UI.message("'version' not specified in 'validateBuildLLVMGCC")
  end   
	if options[:project_directory] == nil	
     UI.message("'project_directory' not specified in 'validateBuildLLVMGCC")
  end  
     
    version = options[:version]
    project_directory = options[:project_directory]
    paths = Paths.new(version, project_directory)

	sh("sh validateLLVM_NO_GCC.sh #{paths.framework_path}/")
end

desc "Copy artefacts to the Pods directory"
private_lane :copyToPodsFromBuild do |options|

  if options[:version] == nil	
     UI.message("'version' not specified in 'copyToPodsFromBuild")
  end   
	if options[:project_directory] == nil	
     UI.message("'project_directory' not specified in 'copyToPodsFromBuild")
  end   
    
  version = options[:version]
  project_directory = options[:project_directory]
  paths = Paths.new(version, project_directory)

	sh("rm -rf #{projectDirectory}#{paths.xcode_directory}")
  sh("mkdir -p #{paths.framework_path}")

	sh("lipo -create -output \"#{paths.framework_outputFile}\" \"#{paths.iphoneos_outputFile}\" \"#{paths.simulator_outputFile}\"")
	sh("dsymutil -o=\"#{paths.framework_path}.dSYM\" \"#{paths.framework_outputFile}\"")
	sh("cp #{paths.iphoneos_path}/Assets.car #{paths.framework_path}/." )
	sh("cp #{paths.iphoneos_path}/Info.plist #{paths.framework_path}/." )
	sh("cp #{paths.iphoneos_path}/usa_localizable.strings #{paths.framework_path}/." )
	sh("cp -rf #{paths.iphoneos_path}/Headers #{paths.framework_path}/." )
	sh("cp -rf #{paths.iphoneos_path}/Modules #{paths.framework_path}/." )
	sh("cp -rf #{paths.simulator_path}/Modules/* #{paths.framework_path}/Modules/." )
end

desc "Copy artefacts to the Carthage directory"
private_lane :copyToCarthageFromBuild do |options|
    if options[:version] == nil	
       UI.message("'version' not specified in 'copyToCarthageFromBuild")
    end   
	if options[:project_directory] == nil	
       UI.message("'project_directory' not specified in 'copyToCarthageFromBuild")
    end   

  version = options[:version]
  project_directory = options[:project_directory]
  paths = Paths.new(version, project_directory)
  sh("mkdir -p #{paths.projectDirectory}#{paths.xcode_directory}/Carthage/Carthage/Build/iOS")

	sh("cp -rf #{paths.framework_path} #{paths.carthage_outputPath}/." )
	sh("cp -rf #{paths.carthage_dSYMPath}/*.dSYM #{paths.carthage_outputPath}/." )
	sh("cp #{paths.carthage_symbolsPath}/*.bcsymbolmap #{paths.carthage_outputPath}/." )
	sh("cd #{paths.carthage_path}/ && zip -r #{paths.carthage_path}/#{paths.carthageFileName} Carthage/")
	sh("rm -rf #{paths.carthage_path}/Carthage")
end

