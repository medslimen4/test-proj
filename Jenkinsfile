pipeline {
  agent any
  options {
    buildDiscarder(logRotator(numToKeepStr: '5'))
  }
  environment {
    IMAGE_NAME = 'medslimen4/test-proj'
    IMAGE_TAG = 'latest'
    APP_NAME = 'test-proj'
  }
  stages {
    stage('Build') {
      steps {
        powershell 'docker build -t $IMAGE_NAME:$IMAGE_TAG .'
      }
    }
    stage('Login') {
      steps {
        powershell '''
          $token = & heroku auth:token
          echo $token | docker login --username=_ --password-stdin registry.heroku.com
        '''
      }
    }
    stage('Push to Heroku registry') {
      steps {
        powershell '''
          docker tag $IMAGE_NAME:$IMAGE_TAG registry.heroku.com/$APP_NAME/web
          docker push registry.heroku.com/$APP_NAME/web
        '''
      }
    }
    stage('Release the image') {
      steps {
        powershell 'heroku container:release web --app=$APP_NAME'
      }
    }
  }
  post {
    always {
      powershell 'docker logout'
    }
  }
}
