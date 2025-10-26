pipeline {
    agent any

    environment {

	SSH_PORT = credentials('SSH_PORT')
	IP_FOR_REMOTE = credentials('IP_FOR_REMOTE')
	REMOTE_USER = credentials('REMOTE_USER')
        SCRIPT_NAME = 'run-chess-app.sh'
    }

    stages {
        stage('Connecting to the server Ubuntu') {
            steps {
                script {
                    // Простая проверка подключения
                    sh "ssh -o ConnectTimeout=10 -o StrictHostKeyChecking=no -p ${SSH_PORT} ${REMOTE_USER}@${IP_FOR_REMOTE} 'echo \"✅ Подключение успешно\"'"
                }
            }
        }

        stage('Copying the script to the server') {
            steps {
                script {
                    // Копирование cкрипта на сервер
                    sh """
                        scp -o StrictHostKeyChecking=no -P ${SSH_PORT} \
                            ${SCRIPT_NAME} \
                            ${REMOTE_USER}@${IP_FOR_REMOTE}:/tmp/${SCRIPT_NAME}
                    """
                }
            }
        }

        stage('Running the script on the server') {
            steps {
                script {
		    // Запуск скрипта
                    sshagent (credentials: ['ubuntu-ssh']) {
                        sh """
                            ssh -o StrictHostKeyChecking=no -p ${SSH_PORT} ${REMOTE_USER}@${IP_FOR_REMOTE} "
                                chmod +x /tmp/${SCRIPT_NAME} &&
                                /tmp/${SCRIPT_NAME}
                            "
                        """
                    }
                }
            }
        }
    }

    post {
        always {
            // Очистка временного файла на сервере
            sshagent (credentials: ['ubuntu-ssh']) {
                sh "ssh -o StrictHostKeyChecking=no -p ${SSH_PORT} ${REMOTE_USER}@${IP_FOR_REMOTE} 'rm -f /tmp/${SCRIPT_NAME}'"
            }
        }
    }
}
