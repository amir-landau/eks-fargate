pipeline {
    agent any
    environment {
        aws_creds =	credentials("aws_creds")
    }
    
    tools {
        terraform 'terraform'
    }
    stages {
        stage('Git checkout') {
           steps{
                git branch: 'main', credentialsId: '4222859d-cbce-48ff-b875-b49761e95971', url: 'https://github.com/amir-landau/eks-fargate'
            }
        }
        stage('terraform Init') {
            steps{
                sh 'terraform init'
            }
        }
        stage('terraform Plan') {
            steps{
                sh 'terraform plan -input=false'
            }
        }
    }
}