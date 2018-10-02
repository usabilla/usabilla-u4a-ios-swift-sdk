desc "Build framework For XCode 10"
private_lane :buildXcode10FrameWork do |options|
    target = "Release"
    version = options[:version]
    if options[:target] == nil
       UI.message("Version not specified in 'buildXcode10FrameWork, USING 'Release'")
    else 
	   UI.message("Version not specified in 'buildXcode10FrameWork, USING 'Release'")
    end
 	xcversion(version: version)
    xcode_directory = "Xcode-10"
    project_directory = options[:project_directory]
    pod_framework_path = "Usabilla.xcarchive/Products/Library/Frameworks/Usabilla.framework"
    pod_symbols_path = "Usabilla.xcarchive/dSYMS/Usabilla.framework.dSYM"
    framework_name = "Usabilla.framework"
    framework_execFile = "Usabilla"
    carthage_framework_path = "Usabilla.framework.zip"
	sh("rm -rf #{project_directory}#{xcode_directory}")
    sh("mkdir -p #{project_directory}#{xcode_directory}/Pods")
    sh("mkdir -p #{project_directory}#{xcode_directory}/Pods/#{framework_name}")
    sh("mkdir -p #{project_directory}#{xcode_directory}/Carthage")

	sh("xcodebuild -derivedDataPath #{project_directory}/build -project #{project_directory}/UsabillaLib.xcodeproj -scheme Usabilla -configuration Release -sdk iphoneos OTHER_CFLAGS=-fembed-bitcode BITCODE_GENERATION_MODE=bitcode")
	sh("xcodebuild -derivedDataPath #{project_directory}/build -project #{project_directory}/UsabillaLib.xcodeproj -scheme Usabilla -configuration Release -sdk iphonesimulator OTHER_CFLAGS=-fembed-bitcode-marker BITCODE_GENERATION_MODE=bitcode")
  
#   sh("xcodebuild -derivedDataPath #{project_directory}/build -workspace #{project_directory}/Usabilla.xcworkspace -scheme Usabilla -configuration Release -sdk iphoneos")
#	sh("xcodebuild -derivedDataPath #{project_directory}/build -workspace #{project_directory}/Usabilla.xcworkspace -scheme Usabilla -configuration Release -sdk iphonesimulator")

	sh("lipo -create -output \"#{project_directory}#{xcode_directory}/Pods/#{framework_name}/#{framework_execFile}\" \"#{project_directory}/build/Build/Products/#{target}-iphoneos/#{framework_name}/#{framework_execFile}\" \"#{project_directory}/build/Build/Products/#{target}-iphonesimulator/#{framework_name}/#{framework_execFile}\"")
	sh("dsymutil -o=\"#{project_directory}#{xcode_directory}/Pods/#{framework_name}.dSYM\" \"#{project_directory}#{xcode_directory}/Pods/#{framework_name}/Usabilla\"")
	sh("cp #{project_directory}/build/Build/Products/#{target}-iphoneos/#{framework_name}/Assets.car #{project_directory}#{xcode_directory}/Pods/#{framework_name}/." )
	sh("cp #{project_directory}/build/Build/Products/#{target}-iphoneos/#{framework_name}/Info.plist #{project_directory}#{xcode_directory}/Pods/#{framework_name}/." )
	sh("cp #{project_directory}/build/Build/Products/#{target}-iphoneos/#{framework_name}/usa_localizable.strings #{project_directory}#{xcode_directory}/Pods/#{framework_name}/." )
	sh("cp -rf #{project_directory}/build/Build/Products/#{target}-iphoneos/#{framework_name}/Headers #{project_directory}#{xcode_directory}/Pods/#{framework_name}/." )
	sh("cp -rf #{project_directory}/build/Build/Products/#{target}-iphoneos/#{framework_name}/Modules #{project_directory}#{xcode_directory}/Pods/#{framework_name}/." )
	sh("cp -rf #{project_directory}/build/Build/Products/#{target}-iphonesimulator/#{framework_name}/Modules/* #{project_directory}#{xcode_directory}/Pods/#{framework_name}/Modules/." )

	sh("sh validateLLVM_NO_GCC.sh #{project_directory}#{xcode_directory}/Pods/#{framework_name}/")


	#this should be done somewhere else
	sh("rm -rf #{project_directory}/automation/UsabillaSystemTest/UsabillaSystemTest/#{framework_name}")
	sh("cp -rf #{project_directory}#{xcode_directory}/Pods/#{framework_name} #{project_directory}/automation/UsabillaSystemTest/UsabillaSystemTest/.")
end

#desc "Create Release Directory"
#private_lane :crateReleaseDirectory do |options|
#    unless options[:version]
#        UI.error("missing Xcode version")
#    end
#    unless options[:project_directory]
#        UI.error("missing project directory path")
#    end
#    xcode_directory = "Xcode-#{options[:version]}"
#    project_directory = options[:project_directory]
#    pod_framework_path = "Usabilla.xcarchive/Products/Library/Frameworks/Usabilla.framework"
#    pod_symbols_path = "Usabilla.xcarchive/dSYMS/Usabilla.framework.dSYM" 
#    carthage_framework_path = "Usabilla.framework.zip"
#    sh("rm -rf #{project_directory}#{xcode_directory}")
#    sh("mkdir -p #{project_directory}#{xcode_directory}/Pods")
#    sh("mkdir -p #{project_directory}#{xcode_directory}/Carthage")
#    sh("cp -r #{project_directory}#{pod_framework_path} #{project_directory}#{xcode_directory}/Pods/")
#    sh("cp -r #{project_directory}#{pod_symbols_path} #{project_directory}#{xcode_directory}/Pods/")
#    sh("cp -r #{project_directory}#{carthage_framework_path} #{project_directory}#{xcode_directory}/Carthage/Carthage.framework.zip")
#end

#desc "Clean Project folder"
#private_lane :cleanProject do 
#   sh("rm -f ../Usabilla.framework.zip")
#    sh("rm -rf ../Usabilla.xcarchive")
#    sh("rm -rf ../Usabilla.framework")
#end