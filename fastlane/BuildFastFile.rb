desc "Build framework with Production configuration"
private_lane :buildFramework do
    xcodebuild(
        workspace: "Usabilla.xcworkspace",
        scheme: "Usabilla",
        configuration: "Production",
        clean: true,
        archive: true
    )
end

desc "Create Release Directory"
private_lane :crateReleaseDirectory do |options|
    unless options[:version]
        UI.error("missing Xcode version")
    end
    unless options[:project_directory]
        UI.error("missing project directory path")
    end
    xcode_directory = "Xcode-#{options[:version]}"
    project_directory = options[:project_directory]
    pod_framework_path = "Usabilla.xcarchive/Products/Library/Frameworks/Usabilla.framework"
    pod_symbols_path = "Usabilla.xcarchive/dSYMS/Usabilla.framework.dSYM"
    carthage_framework_path = "Usabilla.framework.zip"
    sh("rm -rf #{project_directory}#{xcode_directory}")
    sh("mkdir -p #{project_directory}#{xcode_directory}/Pods")
    sh("mkdir -p #{project_directory}#{xcode_directory}/Carthage")
    sh("cp -r #{project_directory}#{pod_framework_path} #{project_directory}#{xcode_directory}/Pods/")
    sh("cp -r #{project_directory}#{pod_symbols_path} #{project_directory}#{xcode_directory}/Pods/")
    sh("cp -r #{project_directory}#{carthage_framework_path} #{project_directory}#{xcode_directory}/Carthage/Carthage.framework.zip")
end

desc "Clean Project folder"
private_lane :cleanProject do 
    sh("rm ../Usabilla.framework.zip")
    sh("rm -rf ../Usabilla.xcarchive")
    sh("rm -rf ../Usabilla.framework")
end