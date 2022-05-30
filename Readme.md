# Before the hands-on lab
## Download Starter files
```bash
cd ~
git clone \
   --depth 1 \
   --branch main \
   https://github.com/microsoft/MCW-Cloud-native-applications.git \
   MCW-Cloud-native-applications
cd MCW-Cloud-native-applications
```
## Import Secret
Template:
[github-connection.json](./github-connection.json)
## Init

```bash
export MCW_SUFFIX=633799
export MCW_GITHUB_USERNAME=johannespetereit
export MCW_GITHUB_TOKEN=xxx
export MCW_GITHUB_URL=https://github.com/$MCW_GITHUB_USERNAME/Fabmedical 
export MCW_GITHUB_EMAIL=johannes.petereit@xxx.xx

cd ~/MCW-Cloud-native-applications/Hands-on\ lab/lab-files/developer/scripts
code bhol.sh
```
Then paste content of [bhol.sh](./bhol.sh)
```bash
bash bhol.sh
```

## Setup VM

```bash
ssh adminfabmedical@fabmedical$MCW_SUFFIX.centralus.cloudapp.azure.com
```
Password: `Password.1!!`

```bash
git clone https://github.com/$MCW_GITHUB_USERNAME/Fabmedical
```

```bash
cd ~/Fabmedical/scripts
bash create_build_environment.sh

cd ~/Fabmedical/scripts
bash create_and_seed_database.sh

cd ~/Fabmedical/content-api
docker image build -t petereitadesso/content-api:latest .

cd ~/Fabmedical/content-web
docker image build -t petereitadesso/content-web:latest .

docker login -u petereitadesso

docker image push petereitadesso/content-api:latest
docker image push petereitadesso/content-web:latest
```

## on consecutive labs
```bash
acrPW=`az acr credential show -n fabmedical$MCW_SUFFIX --query "passwords[0].value" -otsv`

docker image pull petereitadesso/content-api:latest
docker image pull petereitadesso/content-web:latest

docker tag petereitadesso/content-api:latest fabmedical$MCW_SUFFIX.azurecr.io/content-api:latest
docker tag petereitadesso/content-web:latest fabmedical$MCW_SUFFIX.azurecr.io/content-web:latest

# replace ACR pw
docker login fabmedical$MCW_SUFFIX.azurecr.io -u fabmedical$MCW_SUFFIX -p $acrPW
docker image push fabmedical$MCW_SUFFIX.azurecr.io/content-api:latest
docker image push fabmedical$MCW_SUFFIX.azurecr.io/content-web:latest
```

# DB Migration
## get private IP
```bash
 az network nic list -otable --query "[?@.name=='fabmedical-$MCW_SUFFIX'].ipConfigurations[0].privateIpAddress" -otsv
```

# Kubernetes
## clone helm charts
```bash
cd ~
git clone https://github.com/johannespetereit/Fabmedical-helm.git
az aks get-credentials -n fabmedical-$MCW_SUFFIX -g fabmedical-$MCW_SUFFIX -a


cd ~/Fabmedical-helm
dbName=`az cosmosdb list --query [].name -otsv`
rg=`az cosmosdb list --query [].resourceGroup -otsv`
key=`az cosmosdb keys list -n $dbName -g $rg --query primaryMasterKey -otsv`
conn="mongodb://$dbName:$key@$dbName.mongo.cosmos.azure.com:10255/contentdb?ssl=true&retrywrites=false&maxIdleTimeMS=120000&appName=@$dbName@"
acr=`az acr list -otable --query [].name -otsv`
helm upgrade --install fabmedical-helm ./fabmedical --namespace ingress-demo --create-namespace -f values2.yaml --set connectionString=$conn --set acr=$acr

kubectl config set-context --current --namespace ingress-demo
helm list
kubectl get pods

```