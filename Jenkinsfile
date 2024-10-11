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
        powershell 'docker version'
      }
    }
    stage('Check Heroku Connectivity') {
      steps {
        powershell 'Test-NetConnection registry.heroku.com -Port 443'
      }
    }
    stage('Verify Heroku CLI') {
      steps {
        powershell 'heroku --version'
      }
    }
    stage('Debug') {
      steps {
        powershell '''
          Write-Host "HEROKU_API_KEY is set: $(-not [string]::IsNullOrEmpty($Env:HEROKU_API_KEY))"
          Write-Host "First 4 characters of HEROKU_API_KEY: $($Env:HEROKU_API_KEY.Substring(0,4))"
        '''
      }
    }
    stage('Build') {
      steps {
        powershell 'docker build -t $Env:IMAGE_NAME:$Env:IMAGE_TAG .'
      }
    }
    stage('Login') {
      steps {
        powershell '''
           try {
            $apiKey = $Env:HEROKU_API_KEY
            if ([string]::IsNullOrEmpty($apiKey)) {
              throw "HEROKU_API_KEY is empty or not set"
            }
            echo $apiKey | docker login --username=_ --password-stdin registry.heroku.com
            if ($LASTEXITCODE -ne 0) {
              throw "Docker login failed with exit code $LASTEXITCODE"
            }
          } catch {
            Write-Error "Error during login: $_"
            exit 1
          }
        '''
      }
      }
    }
    stage('Push to Heroku registry') {
      steps {
        powershell '''
          docker tag $Env:IMAGE_NAME:$Env:IMAGE_TAG registry.heroku.com/$Env:APP_NAME/web
          docker push registry.heroku.com/$Env:APP_NAME/web
          if ($LASTEXITCODE -ne 0) {
            throw "Docker push failed with exit code $LASTEXITCODE"
          }
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
