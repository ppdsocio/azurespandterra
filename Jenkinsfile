pipeline {
  agent any
  stages {
    stage('GitHub') {
      steps {
        checkout([$class: 'GitSCM', branches: [[name: '*/main']], extensions: [], userRemoteConfigs: [[url: 'https://github.com/ppdsocio/azurespandterra.git']]])
      }
    }

    stage('connect to azure') {
      steps {
        script {
          withCredentials([azureServicePrincipal('azure_sp_terraform')]) {
            "az login --service-principal -u \${AZURE_CLIENT_ID} -p \${AZURE_CLIENT_SECRET} --tenant \${AZURE_TENANT_ID}"
          }
        }
      }
    }
    stage('Terraform Plan') {
        steps{
                sh "az account set --subscription=\"31e83b1c-e3a8-4b4e-8328-4afee07d7099\""
                sh 'terraform init'
                sh "terraform plan -out terraform.tfplan;echo \$? > status"
                stash name: "terraform-plan", includes: "terraform.tfplan"
            }
        }
    stage('Terraform Apply'){
        steps {
            script{
                def apply = false
                try {
                    input message: 'Please confirm to proceed with terraform apply:', ok: 'click here to approve the action'
                    apply = true
                } catch (err) {
                    apply = false
                        currentBuild.result = 'UNSTABLE'
                }
                if(apply){
                        unstash "terraform-plan"
                        sh 'terraform apply terraform.tfplan'
                    }

                }
            }
        post {
            always {
                sh "echo \$(whoami)"
                }
            }

        }
    }
  }