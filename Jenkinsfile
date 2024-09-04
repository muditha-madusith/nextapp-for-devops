pipeline {
    agent any

    environment {
        DOCKER_IMAGE = 'mud2003/my-nextjs-app:latest'
        AWS_CREDENTIALS_ID = 'your-aws-credentials-id' // Jenkins credential ID
    }

    stages {
        // stage('Checkout Code') {
        //     steps {
        //         git branch: 'main', url: 'https://github.com/your-repo/your-nextjs-app.git'
        //     }
        // }
        stage('Build Docker Image') {
            steps {
                script {
                    docker.build(DOCKER_IMAGE)
                }
            }
        }

        stage('Run Tests') {
            steps {
                script {
                    echo "Run Tests..."
                }
            }
        }

        stage('Push Docker Image') {
            steps {
                script {
                    docker.withRegistry('https://index.docker.io/v1/', 'dockerhub-credentials-id') {
                        docker.image(DOCKER_IMAGE).push()
                    }
                }
            }
        }

        stage('Deploy with Terraform') {
            steps {
                withCredentials([[$class: 'AmazonWebServicesCredentialsBinding', credentialsId: AWS_CREDENTIALS_ID]]) {
                    script {
                        sh '''
                        cd terraform
                        terraform init
                        terraform apply -auto-approve
                        '''
                    }
                }
            }
        }
    }

    post {
        always {
            cleanWs()
        }
    }
}
