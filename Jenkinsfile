pipeline {
    agent any

    environment {
        ANDROID_HOME = "/var/jenkins_home/Android/Sdk"
        ANDROID_NDK_HOME = "/var/jenkins_home/Android/Sdk/ndk/26.1.10909125"
        FASTLANE_SKIP_UPDATE_CHECK = "true"
        CI = "true"
        PATH = "$PATH:$HOME/.yarn/bin:$HOME/.config/yarn/global/node_modules/.bin:/var/lib/gems/3.0.0/bin:$HOME/.nvm/versions/node/v22.14.0/bin:$HOME/Android/Sdk/cmdline-tools/latest/bin:$HOME/Android/Sdk/platform-tools:$HOME/Android/Sdk/ndk/26.1.10909125"
        NVM_DIR = "$HOME/.nvm"
        GEM_HOME = "/var/lib/gems/3.0.0"
    }

    stages {
        stage('Install Dependencies') {
            steps {
                sh '''
                    chmod +x jenkins_scripts/*.sh
                    ./jenkins_scripts/install_dependencies.sh
                '''
            }
        }

        stage('Build') {
            steps {
                script {
                    if (env.BRANCH_NAME == "main") {
                        sh './jenkins_scripts/build.sh production'
                    } else {
                        sh './jenkins_scripts/build.sh development'
                    }
                }
            }
        }
    }
}
