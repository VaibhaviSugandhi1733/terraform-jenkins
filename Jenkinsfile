pipeline {
    agent any

    environment {
        AWS_REGION   = "ap-south-1"
        TF_VERSION   = "1.6.0"
        ACTION       = "${params.ACTION}"
    }

    parameters {
        choice(
            name: 'ACTION',
            choices: ['apply', 'destroy'],
            description: 'Terraform action to perform'
        )
    }

    stages {

        stage('Checkout Code') {
            steps {
                checkout scm
            }
        }

        stage('Install Terraform') {
            steps {
                sh """
                  sudo apt-get update -y
                  wget https://releases.hashicorp.com/terraform/${TF_VERSION}/terraform_${TF_VERSION}_linux_amd64.zip
                  unzip terraform_${TF_VERSION}_linux_amd64.zip
                  sudo mv terraform /usr/local/bin/
                """
            }
        }

        stage('Configure AWS Credentials') {
            steps {
                withCredentials([
                    string(credentialsId: 'AWS_ACCESS_KEY', variable: 'AWS_ACCESS_KEY_ID'),
                    string(credentialsId: 'AWS_SECRET_KEY', variable: 'AWS_SECRET_ACCESS_KEY')
                ]) {
                    sh """
                      export AWS_ACCESS_KEY_ID=$AWS_ACCESS_KEY_ID
                      export AWS_SECRET_ACCESS_KEY=$AWS_SECRET_ACCESS_KEY
                      export AWS_DEFAULT_REGION=$AWS_REGION
                    """
                }
            }
        }

        stage('Terraform Init') {
            steps {
                sh "terraform init"
            }
        }

        stage('Terraform Plan') {
            steps {
                sh "terraform plan"
            }
        }

        stage('Terraform Apply') {
            when {
                expression { return params.ACTION == "apply" }
            }
            steps {
                sh "terraform apply -auto-approve"
            }
        }

        stage('Terraform Destroy') {
            when {
                expression { return params.ACTION == "destroy" }
            }
            steps {
                sh "terraform destroy -auto-approve"
            }
        }

    }

    post {
        always {
            echo "Pipeline completed."
        }
    }
}
