node('mac') {
    withEnv(['RBENV_VERSION=2.4.2','SWIFTLINT_VERSION=0.24.0']) {
        stage('Checkout') {
            checkout([
                $class: 'GitSCM',
                branches: scm.branches,
                doGenerateSubmoduleConfigurations: false,
                extensions: [[$class: 'SubmoduleOption',
                disableSubmodules: false,
                parentCredentials: true,
                recursiveSubmodules: true,
                reference: '',
                trackingSubmodules: false]],
                submoduleCfg: [],
                userRemoteConfigs: [[credentialsId: 'jenkins-github-user', url: 'git@github.com:usabilla/usabilla-u4a-ios-swift.git']]
            ])
        }

        stage('Install') {
            sh "env"
            sh "bundle check --path=vendor/bundle || bundle install --path=vendor/bundle --jobs=4 --retry=3"
            sh "bundle update fastlane"
            sh "bin/bootstrap-if-needed"
        }

        //All branches gets unit and code integration tests
        stage('Run Unit Tests') {
            sh "bundle exec fastlane runUnitTests"
            sh "bundle exec fastlane buildAll"
        }

		stage("Create Artefacts") {
			sh "bundle exec fastlane createArtefacts"
		}

		stage("Validate framework") {
			sh "bundle exec fastlane validateFrameWork"
		} 

        stage('System tests') {
          systemTest()
        }

        if(env.BRANCH_NAME == 'master') {   
            stage('Validation'){
                sh "bundle exec fastlane validateAll"
            }
            currentBuild.result = 'SUCCESS'
            return
        }

        if(env.BRANCH_NAME ==~ '(develop|release|hotfix|feature|task)/?.*') {
            if(env.BRANCH_NAME ==~ 'task/.*') {
                //Task does not get UI or system tests
                currentBuild.result = 'SUCCESS'
                return
            }
            stage('UI Tests') {
                uiTest()
            }
            currentBuild.result = 'SUCCESS'
            return
        }
        currentBuild.result = 'SUCCESS'
        return
    }
}

def unitTest() {
    sh "bundle exec fastlane unitTestAllDevices"
    withCredentials(
        [usernamePassword(credentialsId: '34dc9a59-1608-4470-9860-bd19030cadbb',
                          passwordVariable: 'DANGER_GITHUB_API_TOKEN',
                          usernameVariable: 'JENKINS_USER')]) {
        sh "./automation/danger.sh"
    }
    sh "bundle exec slather coverage --html --output-directory slather-coverage"
    publishHTML([
                allowMissing: true,
                alwaysLinkToLastBuild: true,
                keepAll: true,
                reportDir: 'slather-coverage',
                reportFiles: 'index.html',
                reportName: 'Coverage Report'
    ])
}

def uiTest() {
    sh "bundle exec fastlane uiTest"
}

def systemTest() {
    sh "bundle exec fastlane systemTests"
}