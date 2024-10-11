pipeline {
  agent any
  options {
    buildDiscarder(logRotator(numToKeepStr: '5'))
  }
  environment {
    HEROKU_API_KEY = credentials('heroku-api-key')
    IMAGE_NAME = 'medslimen4/test-proj'
    IMAGE_TAG = 'latest'
    APP_NAME = 'test-proj'
  }
  stages {
    stage('Build') {
      steps {
        script {
          if (isUnix()) {
            sh 'docker build -t $IMAGE_NAME:$IMAGE_TAG .'
          } else {
            bat 'docker build -t %IMAGE_NAME%:%IMAGE_TAG% .'
          }
        }
      }
    }
    stage('Login') {
      steps {
        script {
          if (isUnix()) {
            sh '''
              # For testing only - replace with your actual API key
              HEROKU_API_KEY=HRKU-9d4551b7-316f-40d0-80a9-c6b39490274d
              echo $HEROKU_API_KEY | docker login --username=_ --password-stdin registry.heroku.com
            '''
          } else {
            bat '''
              @REM For testing only - replace with your actual API key
              set HEROKU_API_KEY=your_api_key_here
              echo %HEROKU_API_KEY% | docker login --username=_ --password-stdin registry.heroku.com
            '''
          }
        }
      }
    }
    stage('Push to Heroku registry') {
      steps {
        script {
          if (isUnix()) {
            sh '''
              docker tag $IMAGE_NAME:$IMAGE_TAG registry.heroku.com/$APP_NAME/web
              docker push registry.heroku.com/$APP_NAME/web
            '''
          } else {
            bat '''
              docker tag %IMAGE_NAME%:%IMAGE_TAG% registry.heroku.com/%APP_NAME%/web
              docker push registry.heroku.com/%APP_NAME%/web
            '''
          }
        }
      }
    }
    stage('Release the image') {
      steps {
        script {
          if (isUnix()) {
            sh 'heroku container:release web --app=$APP_NAME'
          } else {
            bat 'heroku container:release web --app=%APP_NAME%'
          }
        }
      }
    }
  }
  post {
    always {
      script {
        if (isUnix()) {
          sh 'docker logout'
        } else {
          bat 'docker logout'
        }
      }
    }
  }
}