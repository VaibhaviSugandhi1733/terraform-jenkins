pipeline {
  agent any

  // default environment values
  environment {
    AWS_REGION = "ap-south-1"
    TF_VERSION = "1.6.0"
  }

  // parameter replaces workflow_dispatch input
  parameters {
    choice(name: 'ACTION', choices: ['apply', 'destroy'], description: 'Terraform action to perform')
  }

  stages {
    stage('Checkout') {
      steps {
        checkout scm
      }
    }

    stage('Install prerequisites') {
      steps {
        sh '''
          set -e
          # install unzip if missing
          if ! command -v unzip >/dev/null 2>&1; then
            sudo apt-get update -y
            sudo apt-get install -y unzip
          fi

          # install terraform if missing or different version
          if ! command -v terraform >/dev/null 2>&1 || [ "$(terraform version -json | jq -r .terraform_version 2>/dev/null || echo '')" != "${TF_VERSION}" ]; then
            wget -q https://releases.hashicorp.com/terraform/${TF_VERSION}/terraform_${TF_VERSION}_linux_amd64.zip
            unzip -o terraform_${TF_VERSION}_linux_amd64.zip
            sudo mv -f terraform /usr/local/bin/terraform
            rm -f terraform_${TF_VERSION}_linux_amd64.zip
          fi

          terraform -v
        '''
      }
    }

    stage('Configure AWS credentials') {
      steps {
        // expects Jenkins credentials with IDs: AWS_ACCESS_KEY and AWS_SECRET_KEY
        withCredentials([
          string(credentialsId: 'AWS_ACCESS_KEY', variable: 'AWS_ACCESS_KEY_ID'),
          string(credentialsId: 'AWS_SECRET_KEY', variable: 'AWS_SECRET_ACCESS_KEY')
        ]) {
          sh '''
            export AWS_ACCESS_KEY_ID="${AWS_ACCESS_KEY_ID}"
            export AWS_SECRET_ACCESS_KEY="${AWS_SECRET_ACCESS_KEY}"
            export AWS_DEFAULT_REGION="${AWS_REGION}"
            echo "AWS creds loaded (masked in logs)."
          '''
        }
      }
    }

    stage('Terraform Init') {
      steps {
        sh '''
          terraform init -input=false
        '''
      }
    }

    stage('Terraform Plan') {
      steps {
        sh '''
          terraform plan -input=false -out=tfplan
        '''
      }
    }

    stage('Terraform Apply') {
      when {
        expression { return params.ACTION == 'apply' }
      }
      steps {
        sh '''
          terraform apply -input=false -auto-approve tfplan || terraform apply -input=false -auto-approve
        '''
      }
    }

    stage('Terraform Destroy') {
      when {
        expression { return params.ACTION == 'destroy' }
      }
      steps {
        sh '''
          terraform destroy -input=false -auto-approve
        '''
      }
    }
  }

  post {
    always {
      archiveArtifacts artifacts: '**/tfplan,**/*.tfstate', allowEmptyArchive: true
      cleanWs()
      echo "Pipeline finished. ACTION=${params.ACTION}"
    }
    failure {
      echo "Pipeline failed — check logs."
    }
  }
}
