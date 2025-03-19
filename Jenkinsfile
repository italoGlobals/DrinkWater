pipeline {
    agent any

    parameters {
        choice(name: 'PROJECT', choices: ['DrinkWater'], description: 'Escolha o projeto a ser buildado')
    }

    environment {
        PROJECT_PATH = '/app'
        DOCKER_IMAGE = ''
    }

    stages {
        stage('Checkout') {
            steps {
                script {
                    git "https://github.com/italoGlobals/${params.PROJECT}.git"
                }
            }
        }

        stage('Select Docker Image') {
            steps {
                script {
                    if (params.PROJECT == 'DrinkWater') {
                        DOCKER_IMAGE = 'drinkwater-builder'
                    } else {
                        echo 'Não tem projeto selecionado'
                    }
                }
            }
        }

        stage('Build APK') {
            steps {
                script {
                    sh "docker exec ${DOCKER_IMAGE} bash -c 'cd ${PROJECT_PATH} && nvm use 22 && fastlane android beta'"
                }
            }
        }

        stage('Publish APK') {
            steps {
                echo 'Publicando APK...'
                echo 'AAAAAAAAAAAAAAAAAAAAAAA' 
            }
        }
    }

    post {
        always {
            echo 'Pipeline finalizada!'
        }
    }
}
