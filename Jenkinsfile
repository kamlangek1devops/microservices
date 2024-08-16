pipeline {
    agent any
    
    environment {
        DOCKER_CREDENTIALS = credentials('Docker_Hub_Credential')
        AWS_CREDENTIALS = credentials('AWS_CREDENTIAL')

        TELEGRAM_BOT_TOKEN = '7266212019:AAHroBm24b6FmgkfQ5Xl8S7IqW4NJMjosS8'
        TELEGRAM_CHAT_ID = '-4245520118'
    }

    stages {
        stage('Checkout') {
            steps {
                // Checkout the code from the Git repository
                git branch: 'main', url: 'https://github.com/kamlangek1devops/microservices.git'
            }
        }

        stage('Build Docker') {
            steps {
                script {
                    bat '''
                        echo "Building the project on Windows..."

                        E:
                        cd E:\\
                        cd MSIT(UP)\\DevOps\\DevOps2\\Assessment\\2\\microservices\\microservices
                        docker build -t kamlangek2devops/app1:3.0.2 service1\\.
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
                    docker push kamlangek2devops/app1:3.0.2
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
                        bat ''' 
                            echo "Deploying application on dev"
                            curl -X POST "https://api.telegram.org/bot7266212019:AAHroBm24b6FmgkfQ5Xl8S7IqW4NJMjosS8/sendMessage" -d "chat_id=-4245520118" -d "text=Deploying on dev"
                            

                            aws configure set aws_access_key_id %AWS_CREDENTIALS_USR%
                            aws configure set aws_secret_access_key %AWS_CREDENTIALS_PSW%
                            aws configure set region us-east-1
                            E:
                            cd E:\\
                            cd MSIT(UP)\\DevOps\\DevOps2\\Assessment\\2\\microservices
                            make apply ENV=dev
                        '''
                    } 
                    else if(params.WORKSPACE == "uat"){
                        bat ''' 
                            echo "Deploying application on uat"
                            curl -X POST "https://api.telegram.org/bot7266212019:AAHroBm24b6FmgkfQ5Xl8S7IqW4NJMjosS8/sendMessage" -d "chat_id=-4245520118" -d "text=Deploying on uat"
                            
                            E:
                            cd E:\\
                            cd MSIT(UP)\\DevOps\\DevOps2\\Assessment\\2\\microservices
                            make apply ENV=uat
                        '''
                    }
                     else {
                        bat '''
                            echo "Deploying application on prod"
                            curl -X POST "https://api.telegram.org/bot7266212019:AAHroBm24b6FmgkfQ5Xl8S7IqW4NJMjosS8/sendMessage" -d "chat_id=-4245520118" -d "text=Deploying on prod"
                            
                            E:
                            cd E:\\
                            cd MSIT(UP)\\DevOps\\DevOps2\\Assessment\\2\\microservices
                            make apply ENV=prod
                        '''
                    }
                }
            }
        }
    }

    post {
        // always {
        //     echo 'Cleaning up...'
        // }
        success {
            echo 'Build succeeded!'
            bat 'curl -X POST "https://api.telegram.org/bot7266212019:AAHroBm24b6FmgkfQ5Xl8S7IqW4NJMjosS8/sendMessage" -d "chat_id=-4245520118" -d "text=Deployment is succeeded"'
        }
        failure {
            echo 'Build failed.'
            bat 'curl -X POST "https://api.telegram.org/bot7266212019:AAHroBm24b6FmgkfQ5Xl8S7IqW4NJMjosS8/sendMessage" -d "chat_id=-4245520118" -d "text=Deployment is failed"'
        }
    }
}
