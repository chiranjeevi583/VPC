pipeline {
    agent any

    environment {
        GIT_CREDENTIALS = credentials('your-credentials-id') // Replace with your credentials ID
    }

    stages {
        stage('Checkout') {
            steps {
                script {
                    // Set the Git tool to use
                    def gitTool = 'Default' // Change if you have a specific tool configured
                    // Checkout the repository
                    checkout([$class: 'GitSCM', 
                              branches: [[name: '*/main']], // Change branch name if necessary
                              userRemoteConfigs: [[url: 'https://github.com/chiranjeevi583/VPC-TF-Auto.git', credentialsId: 'your-credentials-id']]])
                }
            }
        }
        // Add other stages as needed
        stage('Terraform Init') {
            steps {
                sh 'terraform init'
            }
        }
        stage('Terraform Apply') {
            steps {
                sh 'terraform apply -auto-approve'
            }
        }
    }

    post {
        always {
            archiveArtifacts artifacts: '**/*', fingerprint: true
        }
        failure {
            mail to: 'youremail@example.com', // Replace with your email
                 subject: "Pipeline '${env.JOB_NAME}' failed",
                 body: "Something went wrong. Please check the Jenkins console output."
        }
    }
}
