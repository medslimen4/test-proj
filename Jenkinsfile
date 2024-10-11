pipeline {
  agent any
  options {
    buildDiscarder(logRotator(numToKeepStr: '5'))
  }
  environment {
    HEROKU_API_KEY = credentials('heroku-api-key') // Ensure this is correct
    IMAGE_NAME = 'medslimen/test-proj'
    IMAGE_TAG = 'latest'
    APP_NAME = 'test-proj'
  }
  stages {
    stage('Build') {
      steps {
        powershell 'docker build -t $Env:IMAGE_NAME:$Env:IMAGE_TAG .'
      }
    }
    stage('Login') {
      steps {
        powershell '''
          echo $Env:HEROKU_API_KEY | docker login --username=_ --password-stdin registry.heroku.com
        '''
      }
    }
    stage('Push to Heroku registry') {
      steps {
        powershell '''
          docker tag $Env:IMAGE_NAME:$Env:IMAGE_TAG registry.heroku.com/$Env:APP_NAME/web
          docker push registry.heroku.com/$Env:APP_NAME/web
        '''
      }
    }
    stage('Release the image') {
      steps {
        powershell '''
          heroku container:release web --app=$Env:APP_NAME
        '''
      }
    }
  }
  post {
    always {
      powershell 'docker logout'
    }
  }
}
