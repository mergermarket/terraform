// vim: filetype=groovy
// variables
def version

@Library(value='jenkins-shared-library', changelog=false) _

pipeline {
    options {
        timestamps()
        ansiColor('xterm')
        disableConcurrentBuilds()
    }
    agent {
        node {
            label "swarm2"
        }
    }
    environment {
        DOCKER_HUB = credentials('dockerhub')
        DOCKER_HUB_USER = "${env.DOCKER_HUB_USR}"
        DOCKER_HUB_PASSWORD = "${env.DOCKER_HUB_PSW}"
    }
    stages {
        stage ("Deploy") {
            steps {
                sh "./publish.sh $TERRAFORM_VERSION"
            }
        }
    }
}