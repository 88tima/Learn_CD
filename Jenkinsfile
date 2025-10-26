pipeline {
    agent any

    environment {
        SCRIPT_NAME = 'run-chess-app.sh'
    }

    stages {
        stage('Connecting to the server Ubuntu') {
            steps {
                script {
                    withCredentials([
                        string(credentialsId: 'SSH_PORT', variable: 'SSH_PORT'),
                        string(credentialsId: 'IP_FOR_REMOTE', variable: 'IP_FOR_REMOTE'),
                        string(credentialsId: 'REMOTE_USER', variable: 'REMOTE_USER')
                    ]) {
                        sshagent (credentials: ['ubuntu-ssh']) {
                            sh """
                                ssh -o ConnectTimeout=10 -o StrictHostKeyChecking=no \
                                    -p \${SSH_PORT} \
                                    \${REMOTE_USER}@\${IP_FOR_REMOTE}
                            """
                        }
                    }
                }
            }
        }

        stage('Copying the script to the server') {
            steps {
                script {
                    withCredentials([
                        string(credentialsId: 'SSH_PORT', variable: 'SSH_PORT'),
                        string(credentialsId: 'IP_FOR_REMOTE', variable: 'IP_FOR_REMOTE'),
                        string(credentialsId: 'REMOTE_USER', variable: 'REMOTE_USER')
                    ]) {
                        sshagent (credentials: ['ubuntu-ssh']) {
                            sh """
                                scp -o StrictHostKeyChecking=no -P \${SSH_PORT} \
                                    ${SCRIPT_NAME} \
                                    \${REMOTE_USER}@\${IP_FOR_REMOTE}:/tmp/${SCRIPT_NAME}
                            """
                        }
                    }
                }
            }
        }

        stage('Running the script on the server') {
            steps {
                script {
                    withCredentials([
                        string(credentialsId: 'SSH_PORT', variable: 'SSH_PORT'),
                        string(credentialsId: 'IP_FOR_REMOTE', variable: 'IP_FOR_REMOTE'),
                        string(credentialsId: 'REMOTE_USER', variable: 'REMOTE_USER')
                    ]) {
                        sshagent (credentials: ['ubuntu-ssh']) {
                            sh """
                                ssh -o StrictHostKeyChecking=no -p \${SSH_PORT} \
                                    \${REMOTE_USER}@\${IP_FOR_REMOTE} "
                                        chmod +x /tmp/${SCRIPT_NAME} &&
                                        /tmp/${SCRIPT_NAME}
                                    "
                            """
                        }
                    }
                }
            }
        }
    }

    post {
        always {
            withCredentials([
                string(credentialsId: 'SSH_PORT', variable: 'SSH_PORT'),
                string(credentialsId: 'IP_FOR_REMOTE', variable: 'IP_FOR_REMOTE'),
                string(credentialsId: 'REMOTE_USER', variable: 'REMOTE_USER')
            ]) {
                sshagent (credentials: ['ubuntu-ssh']) {
                    sh """
                        ssh -o StrictHostKeyChecking=no -p \${SSH_PORT} \
                            \${REMOTE_USER}@\${IP_FOR_REMOTE} \
                            'rm -f /tmp/${SCRIPT_NAME}'
                    """
                }
            }
        }
    }
}
