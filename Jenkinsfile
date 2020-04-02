pipeline{
	environment {
    IMAGE_ID="$JOB_NAME:$BUILD_NUMBER"
	IMAGE="snaidu/$IMAGE_ID"
  }
    agent any
    parameters {        
		string(name: 'email', defaultValue: 'tamellaravi789@gmail.com', description: 'Email build notification')        
    }
        stages{
        stage('git clone'){
            steps{
                git 'https://github.com/satishnaidu143/rideeasy.git'
            }
        }
        stage('package'){
            steps{
                sh 'mvn clean package'
            }
        }
        stage('archive artifacts'){
            steps{
                archiveArtifacts '**/*.war'
            }
        }
        stage('junit reports'){
            steps{
                junit 'server/target/surefire-reports/*.xml'
            }
        }
		stage('Pushing image to DockerHub') {
            steps {
             sh label: '', script: '''pwd
			 whoami
			 sudo scp /var/lib/jenkins/workspace/rideeasy/webapp/target/webapp.war /var/lib/jenkins/workspace/rideeasy
			  docker image build -t $IMAGE_ID .
              docker tag $IMAGE_ID $IMAGE
			  docker push $IMAGE
			  docker rmi $IMAGE_ID $IMAGE '''
       }
	}
	stage('updating latest image'){
            steps{
                sh("sed -i.bak 's#snaidu/rideeasy:1#${IMAGE}#' ./deployment.yml")
            }
        }
	  stage('k8s Deployment') {
            steps {
             sh label: '', script: '''
			  kubectl apply -f namespaces.yml
			  kubectl apply -f deployment.yml 
			  kubectl apply -f service.yml '''
      }
   }
}
    post {		
		success {
			echo "Sending successful email"
			emailext (
				subject: "SUCCESSFUL: Job '${env.JOB_NAME} [${env.BUILD_NUMBER}]'",
				body: """build success ra pulka poye chusukooo""",
				to: "${params.email}",
				mimeType: 'text/html'
			)
			echo "Sent email"
		}
		failure {
			echo "Emailing failed build"
			emailext (
				subject: "FAILURE: Job '${env.JOB_NAME} [${env.BUILD_NUMBER}]'",
				body: """build fail ra pulka poye chusuko""",
				to: "${params.email}",
				mimeType: 'text/html'
			)
			echo "Sent email!"
		}
		unstable {
			echo "Emailing unstable build"
			emailext (
				subject: "UNSTABLE: Job '${env.JOB_NAME} [${env.BUILD_NUMBER}]'",
				body: """build theda iyendhi ra pulka poye chusukooo""",
				to: "${params.email}",
				mimeType: 'text/html'
			)
			echo "Sent email!"
		}		
	}      
}
