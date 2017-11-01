desc "Clean old Carthage Data"
def removeCarthageData
    desc "remove symbols"
    sh("rm -f ../Carthage/Build/iOS/*.bcsymbolmap")
    sh("rm -rf ../Carthage/Build/iOS/Usabilla.framework")
    sh("rm -rf ../Carthage/Build/iOS/Usabilla.framework.dSYM")
end

desc "Build and Archive Framework with Carthage"
private_lane :buildCarthage do
    removeCarthageData
    carthage(
        command: "build",
        no_skip_current: true,
        platform: "iOS", 
        configuration: "Release",
        cache_builds: true,
    )
    
    carthage(
        frameworks: ["Usabilla"],
        command: "archive",
        output: "Usabilla.framework.zip",
    )
end