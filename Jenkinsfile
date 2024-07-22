pipeline {
    agent any
    environment {
        AWS_ACCESS_KEY_ID = credentials('AWS_ACCESS_KEY_ID')
        AWS_SECRET_ACCESS_KEY = credentials('AWS_SECRET_ACCESS_KEY')
        region = "ap-south-1"
    }

    stages {
        stage('git checkout SCM') {
            steps {
               git branch: 'main', url: 'https://github.com/hemanthreddy00992/terraform-flask-sanity.git'
            }
        }
       
        stage('Initialize terraform') {
            steps {
                script {
                 dir('root'){
                  sh "terraform init"
                 }
                 
                }
            }
        }
     
        stage('Format the terraform files') {
            steps {
                script {
                 dir('root'){
                  sh "terraform fmt"
                 }
                 
                }
            }
        }
        
        
        stage('validating terraform') {
            steps {
                script {
                 dir('root'){
                  sh "terraform validate"
                 }
                 
                }
            }
        }
        
        stage('infra preview') {
            steps {
                script {
                 dir('root'){
                  sh "terraform plan"
                 }
                }
            }
        }
        
        stage('Applying terraform') {
            steps {
                script {
                 dir('root'){
                  sh "terraform apply --auto-approve"
                 }
                 
                }
            }
        }
        
        
    }
    
}
