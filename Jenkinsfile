pipeline {
    agent any

    environment {
        AWS_REGION = "ap-south-1"
    }

    parameters {
        choice(
            name: 'ACTION',
            choices: ['apply', 'destroy'],
            description: 'Select Terraform Action'
        )
    }

    stages {

        stage('Checkout') {
            steps {
                git url: 'https://github.com/VaibhaviSugandhi1733/terraform-jenkins.git', branch: 'main'
            }
        }

        stage('Install Terraform') {
            steps {
                sh """
                    if ! [ -x "\$(command -v terraform)" ]; then
                        echo "Installing Terraform..."
                        sudo apt-get update -y
                        sudo apt-get install -y wget unzip
                        wget https://releases.hashicorp.com/terraform/1.5.7/terraform_1.5.7_linux_amd64.zip
                        unzip terraform_1.5.7_linux_amd64.zip
                        sudo mv terraform /usr/local/bin/
                    else
                        echo "Terraform already installed."
                    fi
                """
            }
        }

        stage('Terraform Init') {
            steps {
                sh 'terraform init'
            }
        }

        stage('Terraform Plan') {
            steps {
                sh 'terraform plan'
            }
        }

        stage('Terraform Apply or Destroy') {
            steps {
                script {
                    if (params.ACTION == 'apply') {
pipeline {
    agent any

    environment {
        AWS_REGION = "ap-south-1"
    }

    parameters {
        choice(
            name: 'ACTION',
            choices: ['apply', 'destroy'],
            description: 'Select Terraform Action'
        )
    }

    stages {

        stage('Checkout') {
            steps {
                git url: 'https://github.com/VaibhaviSugandhi1733/terraform-jenkins.git', branch: 'main'
            }
        }

        stage('Install Terraform') {
            steps {
                sh """
                    if ! [ -x "\$(command -v terraform)" ]; then
                        echo "Installing Terraform..."
                        sudo apt-get update -y
                        sudo apt-get install -y wget unzip
                        wget https://releases.hashicorp.com/terraform/1.5.7/terraform_1.5.7_linux_amd64.zip
                        unzip terraform_1.5.7_linux_amd64.zip
                        sudo mv terraform /usr/local/bin/
                    else
                        echo "Terraform already installed."
                    fi
                """
            }
        }

        stage('Terraform Init') {
            steps {
                sh 'terraform init'
            }
        }

        stage('Terraform Plan') {
            steps {
                sh 'terraform plan'
            }
        }

        stage('Terraform Apply or Destroy') {
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
            echo "Pipeline Completed"
        }
    }
}
