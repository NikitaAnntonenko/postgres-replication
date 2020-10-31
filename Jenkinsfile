pipeline {
    agent any
    stages {
        stage('Build pg-replication-master image') {
             when {
               branch 'master'
             }
             
             steps {
                 script {
                     echo "1. Build image"
                     def currentImage = docker.build("localhost:5000/postgres-master:11", "master/")
                     echo "2. Push Image"
                     currentImage.push()
                 }
             }
        }

        stage('Build pg-replication-slave image') {
             when {
               branch 'master'
             }
             
             steps {
                 script {
                     echo "1. Build image"
                     def currentImage = docker.build("localhost:5000/postgres-slave:11", "slave/")
                     echo "2. Push Image"
                     currentImage.push()
                 }
             }
        }
    }
}