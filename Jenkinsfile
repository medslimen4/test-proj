pipeline {
  agent any
  options {
    buildDiscarder(logRotator(numToKeepStr: '5'))
  }
  environment {
    HEROKU_API_KEY = credentials('heroku-api-key') // Assuming you have set this in Jenkins credentials
    IMAGE_NAME = 'medslimen4/test-proj'
    IMAGE_TAG = 'latest'
    APP_NAME = 'test-proj'
  }
  stages {
    stage('Build') {
      steps {
        bat 'docker build -t %IMAGE_NAME%:%IMAGE_TAG% .'
      }
    }
    stage('Login') {
      steps {
        bat """
          @echo off
          echo heroku container:login
          echo heroku auth:token | docker login --username=_ registry.heroku.com --password-stdin
        """
      }
    }
    stage('Push to Heroku registry') {
      steps {
        bat """
          docker tag %IMAGE_NAME%:%IMAGE_TAG% registry.heroku.com/%APP_NAME%/web
          docker push registry.heroku.com/%APP_NAME%/web
        """
      }
    }
    stage('Release the image') {
      steps {
        bat "heroku container:release web --app=%APP_NAME%"
      }
    }
  }
  post {
    always {
      bat 'docker logout'
    }
  }
}
