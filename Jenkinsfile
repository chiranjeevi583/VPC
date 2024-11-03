pipeline {
    agent any

    parameters {
        choice(name: 'ACTION', choices: ['apply', 'destroy'], description: 'Select the action to perform')
    }

    stages {
        stage('Checkout') {
            steps {
                git 'https://github.com/chiranjeevi583/VPC-TF-Auto.git'
            }
        }
        stage('Setup Credentials') {
            steps {
                withCredentials([file(credentialsId: 'TERRAFORM-AUTHE', variable: 'GOOGLE_APPLICATION_CREDENTIALS')]) {
                    echo "Using Google Cloud service account credentials."
                }
            }
        }
        stage('Terraform Init') {
            steps {
                sh 'echo $PATH' // For debugging
                sh 'terraform init'
            }
        }
        stage('Terraform Apply/Destroy') {
            steps {
                script {
                    if (params.ACTION == 'apply') {
                        sh 'terraform apply -auto-approve'
                    } else {
                        sh 'terraform destroy -auto-approve'
                    }
                }
            }
        }
    }

    post {
        always {
            archiveArtifacts artifacts: '**/*.tfstate', fingerprint: true
            cleanWs()
        }
    }
}
