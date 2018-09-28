desc "Build framework For XCode 10"
private_lane :buildXcode10FrameWork do |options|
    target = "Release"
    if options[:target] == nil
       UI.message("Version not specified in 'buildXcode10FrameWork, USING 'Release'")
    else 
	   UI.message("Version not specified in 'buildXcode10FrameWork, USING 'Release'")
    end
    xcode_directory = "Xcode-10"
    project_directory = options[:project_directory]
    pod_framework_path = "Usabilla.xcarchive/Products/Library/Frameworks/Usabilla.framework"
    pod_symbols_path = "Usabilla.xcarchive/dSYMS/Usabilla.framework.dSYM"
    framework_name = "Usabilla.framework"
    carthage_framework_path = "Usabilla.framework.zip"
	sh("rm -rf #{project_directory}#{xcode_directory}")
    sh("mkdir -p #{project_directory}#{xcode_directory}/Pods")
    sh("mkdir -p #{project_directory}#{xcode_directory}/Pods/#{framework_name}")
    sh("mkdir -p #{project_directory}#{xcode_directory}/Carthage")

	sh("xcodebuild -derivedDataPath #{project_directory}/build -workspace #{project_directory}/Usabilla.xcworkspace -scheme Usabilla -configuration Release -sdk iphoneos ONLY_ACTIVE_ARCH=NO CODE_SIGNING_REQUIRED=NO CODE_SIGN_IDENTITY= CARTHAGE=YES  SKIP_INSTALL=NO GCC_INSTRUMENT_PROGRAM_FLOW_ARCS=NO -CLANG_ENABLE_CODE_COVERAGE=NO STRIP_INSTALLED_PRODUCT=NO")
	sh("xcodebuild -derivedDataPath #{project_directory}/build -workspace #{project_directory}/Usabilla.xcworkspace -scheme Usabilla -configuration Release -sdk iphonesimulator ONLY_ACTIVE_ARCH=NO CODE_SIGNING_REQUIRED=NO CODE_SIGN_IDENTITY= CARTHAGE=YES  SKIP_INSTALL=NO GCC_INSTRUMENT_PROGRAM_FLOW_ARCS=NO --CLANG_ENABLE_CODE_COVERAGE=NO  STRIP_INSTALLED_PRODUCT=NO")

	sh("lipo -create -output \"#{project_directory}#{xcode_directory}/Pods/#{framework_name}/Usabilla\" \"#{project_directory}/build/Build/Products/#{target}-iphoneos/Usabilla.framework/Usabilla\" \"#{project_directory}/build/Build/Products/#{target}-iphonesimulator/Usabilla.framework/Usabilla\"")
	sh("dsymutil -o=\"#{project_directory}#{xcode_directory}/Pods/#{framework_name}.dSYM\" \"#{project_directory}#{xcode_directory}/Pods/#{framework_name}/Usabilla\"")
	sh("cp #{project_directory}/build/Build/Products/#{target}-iphoneos/#{framework_name}/Assets.car #{project_directory}#{xcode_directory}/Pods/#{framework_name}/." )
	sh("cp #{project_directory}/build/Build/Products/#{target}-iphoneos/#{framework_name}/Info.plist #{project_directory}#{xcode_directory}/Pods/#{framework_name}/." )
	sh("cp #{project_directory}/build/Build/Products/#{target}-iphoneos/#{framework_name}/usa_localizable.strings #{project_directory}#{xcode_directory}/Pods/#{framework_name}/." )
	sh("cp -rf #{project_directory}/build/Build/Products/#{target}-iphoneos/#{framework_name}/Headers #{project_directory}#{xcode_directory}/Pods/#{framework_name}/." )
	sh("cp -rf #{project_directory}/build/Build/Products/#{target}-iphoneos/#{framework_name}/Modules #{project_directory}#{xcode_directory}/Pods/#{framework_name}/." )
	sh("cp -rf #{project_directory}/build/Build/Products/#{target}-iphonesimulator/#{framework_name}/Modules/* #{project_directory}#{xcode_directory}/Pods/#{framework_name}/Modules/." )

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