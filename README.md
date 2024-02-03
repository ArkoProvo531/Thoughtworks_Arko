<h1>Mediawiki</h1>
Used Helm charts for mediawiki to deploy on Azure Kubernetes services (AKS).

In this assignment, I have added 4 environments ( Dev, Integration, operations & test ) for enhancing the deployment for different environments using Azure DevOps End to End automation.

<h1>Pre-requisites:</h1>
Using Pre-cluster-config-steps.yml file used ( /pipelines/templates/steps ), installing az cli, kubectl & helm on the Azure DevOps Yaml pipeline agent. 
The agent pool is added for each environment under path: Thoughtworks_Arko\pipelines\templates\vars\cd-release-vars.yml.

Each environment values.yaml files present in path: Thoughtworks_Arko\Apps_conf\AKS\environments
Also, for security scanning on the K8s cluster, I have used CheckOV, which is an Open-Source antivirus engine for detecting trojans, viruses, malware & other malicious threats.

<h1>Pipeline End to End Automation steps:</h1>
The repo contains three charts: ( Path: Thoughtworks_Arko\Apps_conf\AKS\Helm )
1.)ClamAV -> To detect  trojans, viruses, malware for docker containers running on cluster
2)  mediawiki -> It runs mediawiki app
3) mariadb -> It runs database for mediawiki app.
Now, Using Aure DevOps Yaml pipeline (End to End Automation), Needs to trigger the cd-release.yml file (Path: Thoughtworks_Arko\pipelines\cd-release.yml). So, whenever there is a change in code or a pull requests trigger the pipeline as well.

**Note:** The secrets (password for DB) are stored in Key-Vault of Azure and it’s been retrieved in the PowerShell script while running the helm install commands.

The application will be served on the external ip provided by load balancer . In my case it was > http://localhost:8080. The databse host will be available at database:3306.
At the end of configuration , LocalSettings.php will be downloaded . The same file need to be placed at /var/www/html inside container . This can be done by removing commented hostmount in deployment.yaml of mediawiki chart and providing a hostmount path.

