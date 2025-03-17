pipeline {
    agent any

    environment {
        ANDROID_HOME = "/home/${sh(script: 'whoami', returnStdout: true).trim()}/Android/Sdk"
        FASTLANE_SKIP_UPDATE_CHECK = "true"
        CI = "true"
        PATH = "$PATH:$HOME/.yarn/bin:$HOME/.config/yarn/global/node_modules/.bin"
    }

    stages {
        stage('Install Yarn') {
            steps {
                sh 'curl -o- -L https://yarnpkg.com/install.sh | bash'
            }
        }

        stage('Instalar Dependências') {
            steps {
                sh 'yarn install'
            }
        }

        stage('Build APK ou AAB') {
            steps {
                script {
                    if (env.BRANCH_NAME == "main") {
                        sh 'fastlane android build_aab'
                    } else {
                        sh 'fastlane android build_apk'
                    }
                }
            }
        }

        stage('Salvar Artefatos') {
            steps {
                script {
                    if (env.BRANCH_NAME == "main") {
                        sh 'mv app/build/outputs/bundle/release/app-release.aab $WORKSPACE/DrinkWater.aab'
                    } else {
                        sh 'mv app/build/outputs/apk/release/app-release.apk $WORKSPACE/DrinkWater.apk'
                    }
                }
            }
        }
    }
}
