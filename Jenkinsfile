pipeline {
    agent any
    options {
        buildDiscarder(logRotator(numToKeepStr: '5'))
    }
    environment {
        HEROKU_API_KEY = credentials('heroku-api-key')
        IMAGE_NAME = 'medslimen/test-proj'
        IMAGE_TAG = 'latest'
        APP_NAME = 'test-proj'
    }
    stages {
        stage('Verify Docker') {
            steps {
                sh 'docker version'  // Change to 'sh' if on Linux
            }
        }
        stage('Check Heroku Connectivity') {
            steps {
                sh 'curl -Is https://registry.heroku.com | head -n 1'  // Test connection using curl
            }
        }
        stage('Verify Heroku CLI') {
            steps {
                sh 'heroku --version'
            }
        }
        stage('Debug') {
            steps {
                sh '''
                  echo "HEROKU_API_KEY is set: ${HEROKU_API_KEY != ''}"
                  echo "First 4 characters of HEROKU_API_KEY: ${HEROKU_API_KEY.take(4)}"
                '''
            }
        }
        stage('Login') {
            steps {
                script {
                    echo "Attempting Docker login with Heroku API key..."
                    echo "${HEROKU_API_KEY}" | docker login --username=_ --password-stdin registry.heroku.com
                }
            }
        }
        stage('Build') {
            steps {
                sh 'docker build -t ${IMAGE_NAME}:${IMAGE_TAG} .'
            }
        }
        stage('Push to Heroku registry') {
            steps {
                sh '''
                  docker tag ${IMAGE_NAME}:${IMAGE_TAG} registry.heroku.com/${APP_NAME}/web
                  docker push registry.heroku.com/${APP_NAME}/web
                '''
            }
        }
        stage('Release the image') {
            steps {
                sh 'heroku container:release web --app=${APP_NAME}'
            }
        }
    }
    post {
        always {
            sh 'docker logout'
        }
    }
}
