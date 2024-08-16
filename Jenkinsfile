pipeline {
    agent any
    
    environment {
        DOCKER_CREDENTIALS = credentials('Docker_Hub_Credential')

        TELEGRAM_BOT_TOKEN = '7266212019:AAHroBm24b6FmgkfQ5Xl8S7IqW4NJMjosS8'
        TELEGRAM_CHAT_ID = '-4245520118'
    }

    stages {
        stage('Checkout') {
            steps {
                // Checkout the code from the Git repository
                git branch: 'main', url: 'https://github.com/kamlangek1devops/service1.git'
            }
        }

        stage('Build Docker') {
            steps {
                script {
                    bat '''
                        echo "Building the project on Windows..."
                        docker build -t kamlangek2devops/app1:1.0.2 .
                        '''
                }
            }
        }

        stage('Push Docker to Registry') {
            steps {
                //docker login -u $DOCKER_USERNAME -p $DOCKER_PASSWORD
                //echo $DOCKER_PASSWORD | docker login -u $DOCKER_USERNAME --password-stdin
                bat '''
                    echo "Logging into Docker registry..."
                    echo %DOCKER_CREDENTIALS_USR%
                    docker login -u %DOCKER_CREDENTIALS_USR% -p %DOCKER_CREDENTIALS_PSW%
                                
                    echo "Pushing Docker image to registry..."
                    docker push kamlangek2devops/app1:1.0.2
                '''
            }
        }

        stage('Test') {
            steps {
                echo 'Running tests...'
            }
        }

        stage('Deploy') {
            steps {
                script {
                    if(params.WORKSPACE == "dev"){
                        bat ''' echo "Deploying on dev" '''
                    } 
                    else if(params.WORKSPACE == "uat"){
                        bat ''' echo "Deploying on uat" '''
                    }
                     else {
                        bat '''
                            echo "Deploying the application..."
                            E:
                            cd E:\\
                            cd MSIT(UP)\\DevOps\\DevOps2\\Assessment\\2\\microservices
                        '''
                    }
                }
            }
        }
    }

    post {
        always {
            echo 'Cleaning up...'
        }
        success {
            // Actions that run only if the pipeline succeeds
            echo 'Build succeeded!'
            sendTelegramMessage( "Deployment is done.")
        }
        failure {
            // Actions that run only if the pipeline fails
            echo 'Build failed.'
        }
    }
}

def sendTelegramMessage(String message) {
    httpRequest(
        acceptType: 'APPLICATION_JSON',
        contentType: 'APPLICATION_JSON',
        httpMode: 'POST',
        url: "https://api.telegram.org/bot${env.TELEGRAM_BOT_TOKEN}/sendMessage",
        requestBody: "{\"chat_id\": \"${env.TELEGRAM_CHAT_ID}\", \"text\": \"${message}\"}"
    )
}