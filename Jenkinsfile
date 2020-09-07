pipeline {
	agent any
	stages {

		stage('Lint Blue server HTML') {
			steps {
				sh 'tidy -q -e ./Blue/*.html'
			}
		}
		
		stage('Build Blue Docker Image') {
			steps {
				withCredentials([[$class: 'UsernamePasswordMultiBinding', credentialsId: 'dockerhub', usernameVariable: 'DOCKER_USERNAME', passwordVariable: 'DOCKER_PASSWORD']]){
					sh "./Blue/run_docker.sh"
				}
			}
		}

		stage('Push Blue Image To Dockerhub') {
			steps {
				withCredentials([[$class: 'UsernamePasswordMultiBinding', credentialsId: 'dockerhub', usernameVariable: 'DOCKER_USERNAME', passwordVariable: 'DOCKER_PASSWORD']]){
					sh './Blue/upload_docker.sh'
				}
			}
		}

		stage('Set current kubectl context') {
			steps {
				withAWS(region:'us-west-2', credentials:'aws-static') {
					sh '''
						kubectl config use-context arn:aws:eks:us-west-2:142977788479:cluster/CapstoneCluster
					'''
				}
			}
		}

		stage('Deploy blue container') {
			steps {
				withAWS(region:'us-west-2', credentials:'aws-static') {
					sh '''
						kubectl apply -f ./Blue/blue-controller.json
					'''
				}
			}
		}

		stage('Create the service in the cluster, redirect to blue') {
			steps {
				withAWS(region:'us-west-2', credentials:'aws-static') {
					sh '''
						kubectl apply -f ./Blue/blue-service.json
					'''
				}
			}
		}

		stage('Wait user approve') {
            steps {
                input "Is that Blue server is working then approve for Green?"
            }
        }

		stage('Lint Green server HTML') {
			steps {
				sh 'tidy -q -e ./Green/*.html'
			}
		}
		
		stage('Build Green Docker Image') {
			steps {
				withCredentials([[$class: 'UsernamePasswordMultiBinding', credentialsId: 'dockerhub', usernameVariable: 'DOCKER_USERNAME', passwordVariable: 'DOCKER_PASSWORD']]){
					sh "./Green/run_docker.sh"
				}
			}
		}

		stage('Push Green Image To Dockerhub') {
			steps {
				withCredentials([[$class: 'UsernamePasswordMultiBinding', credentialsId: 'dockerhub', usernameVariable: 'DOCKER_USERNAME', passwordVariable: 'DOCKER_PASSWORD']]){
					sh './Green/upload_docker.sh'
				}
			}
		}

		stage('Deploy Green container') {
			steps {
				withAWS(region:'us-west-2', credentials:'aws-static') {
					sh '''
						kubectl apply -f ./Green/green-controller.json
					'''
				}
			}
		}

		stage('Create the service in the cluster, redirect to Green') {
			steps {
				withAWS(region:'us-west-2', credentials:'aws-static') {
					sh '''
						kubectl apply -f ./Green/green-service.json
					'''
				}
			}
		}

	}
}
