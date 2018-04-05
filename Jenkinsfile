pipeline {
    agent any
    stages {
        stage('Build') {
            steps {
                 sh 'printenv'
                 sh 'make build'
            }
        }
        stage('Tag') {
            steps {
                 sh 'make tag'
            }
        }
        stage('Push') {
            steps {
                 sh 'make push-to-repo'
            }
        }
        stage('Release') {
            steps {
                 sh 'make release-to-repo'
            }
        }
    }
}