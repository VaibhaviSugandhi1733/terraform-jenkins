pipeline {
  agent any

  environment {
    AWS_REGION = "ap-south-1"
    TF_VERSION = "1.6.0"
  }

  parameters {
    choice(name: 'ACTION', choices: ['apply', 'destroy'], description: 'Terraform action to perform')
  }

  stages {

    stage('Checkout') {
      steps {
        checkout scm
      }
    }

    stage('Install Terraform (Local)') {
      steps {
        sh '''
          set -e
          
          echo "Downloading Terraform ${TF_VERSION}..."
          wget -q https://releases.hashicorp.com/terraform/${TF_VERSION}/terraform_${TF_VERSION}_linux_amd64.zip
          
          echo "Extracting Terraform..."
          unzip -o terraform_${TF_VERSION}_linux_amd64.zip
          
          echo "Preparing binary..."
          chmod +x terraform
          mv terraform terraform-bin

          echo "Terraform Binary Installed Locally:"
          ./terraform-bin -v
        '''
      }
    }

    stage('Configure AWS Credentials') {
      steps {
        withCredentials([
          string(credentialsId: 'AWS_ACCESS_KEY', variable: 'AWS_ACCESS_KEY_ID'),
          string(credentialsId: 'AWS_SECRET_KEY', variable: 'AWS_SECRET_ACCESS_KEY')
        ]) {
          sh '''
            export AWS_ACCESS_KEY_ID="${AWS_ACCESS_KEY_ID}"
            export AWS_SECRET_ACCESS_KEY="${AWS_SECRET_ACCESS_KEY}"
            export AWS_DEFAULT_REGION="${AWS_REGION}"

            echo "AWS credentials configured successfully."
          '''
        }
      }
    }
