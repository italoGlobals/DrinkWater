pipeline {
    agent any

    environment {
        ANDROID_HOME = "/home/$(whoami)/Android/Sdk"
        FASTLANE_SKIP_UPDATE_CHECK = "true"
        CI = "true"
    }

    stages {
        stage('Setup SSH') {
            steps {
                script {
                    sshagent(['8fff38fe-e685-446f-befb-b67edbbe694a']) {
                        sh 'ssh-add ~/.ssh/id_ed25519'
                        sh 'ssh-keyscan -H github.com >> ~/.ssh/known_hosts'
                    }
                }
            }
        }

        stage('Checkout') {
            steps {
                git branch: 'develop', url: 'git@github.com:italoGlobals/DrinkWater.git'
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
                sh 'mv app-release.apk $WORKSPACE/DrinkWater.apk'
            }
        }
    }
}
