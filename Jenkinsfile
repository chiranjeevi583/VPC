pipeline {
  agent any
  parameters {
    choice(name: 'ACTION', choices: ['apply', 'destroy'], description: 'Choose action: apply or destroy')
  }
  environment {
    GOOGLE_APPLICATION_CREDENTIALS = credentials('TERRAFORM-AUTHE') // Replace 'TERRAFORM-AUTHE' with the ID of your secret file credential
  }
  stages {
    stage('Setup Credentials') {
      steps {
        // Save the secret file to a known path for Terraform to use
        sh 'echo $GOOGLE_APPLICATION_CREDENTIALS > service-account-key.json'
      }
    }
    stage('Terraform Init') {
      steps {
        sh '''
          export GOOGLE_APPLICATION_CREDENTIALS=$PWD/service-account-key.json
          terraform init
        '''
      }
    }
    stage('Terraform Apply/Destroy') {
      steps {
        script {
          if (params.ACTION == 'apply') {
            sh '''
              export GOOGLE_APPLICATION_CREDENTIALS=$PWD/service-account-key.json
              terraform apply -auto-approve
            '''
          } else if (params.ACTION == 'destroy') {
            sh '''
              export GOOGLE_APPLICATION_CREDENTIALS=$PWD/service-account-key.json
              terraform destroy -auto-approve
            '''
          }
        }
      }
    }
  }
}
