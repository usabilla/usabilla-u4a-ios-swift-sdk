    # def xcode_version 
    #     sh("xcodebuild -version | head -1 | sed -e 's@.*\([0-9]..\).*@\1@'")
    # end
    def projectDirectory
        "#{File.expand_path(File.dirname(__FILE__))}/../"
    end

    def cleanReleaseProject
        sh("rm -rf #{projectDirectory}automation/ReleaseValidator/Usabilla.Framework")        
    end 

	def config
        JSON.parse(File.read("config.json"), {:symbolize_names => true})
    end

    def xcodeVersions
		config[:xcodeVersions]
    end

    def lastXcodeVersion
        config[:lastXcodeVersion]
    end
    def uiTestDevices
        config[:uiTestDevices]
    end

    def unitTestDevices
        config[:unitTestDevices]
    end

    def resetSimulator
       sh("killall -9 'Simulator' || echo 'No simulator launched'")
       sh("launchctl remove com.apple.CoreSimulator.CoreSimulatorService || true")
    end
    
    
class Paths

	def initialize(version, projectDirectory)
        @version = version
		@xcode_directory = "XcodeBuilds/Xcode-#{version}"
		@projectDirectory = projectDirectory
    end
    
    def projectDirectory
    	@projectDirectory
    end
	
	def target 
		"Release"
	end
    def xcode_directory 
    	 @xcode_directory
    end

    def framework_name 
    	 "Usabilla.framework"
    end
    def framework_execFile 
    	 "Usabilla"
    end
    def framework_path  
    	 "#{projectDirectory}#{xcode_directory}/Pods/#{framework_name}"
    end
	def framework_outputFile
		 "#{framework_path}/#{framework_execFile}"
	end
    
    def simulator_path
     	"#{projectDirectory}/build/Build/Products/#{target}-iphonesimulator/#{framework_name}"
    end
    def simulator_outputFile
	    "#{simulator_path}/#{framework_execFile}"
	end
    def iphoneos_path
       "#{projectDirectory}/build/Build/Products/#{target}-iphoneos/#{framework_name}"
    end
    def iphoneos_outputFile
       "#{iphoneos_path}/#{framework_execFile}"
    end
    def carthage_outputPath
    	"#{projectDirectory}#{xcode_directory}/Carthage/Carthage/Build/iOS"
    end
    
    def carthage_symbolsPath
    	 "#{projectDirectory}/build/Build/Products/#{target}-iphoneos"
    end
    def carthage_dSYMPath
	    "#{projectDirectory}#{xcode_directory}/Pods"
	end
    def carthage_path
	    "#{projectDirectory}#{xcode_directory}/Carthage"
	end
	def carthageFileName 
		"Carthage.framework.zip"
	end
	
end
