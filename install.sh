# git clone https://github.com/johannespetereit/Fabmedical-helm.git fabmedical-helm
cd ~/fabmedical-helm
dbName=`az cosmosdb list --query [].name -otsv`
rg=`az cosmosdb list --query [].resourceGroup -otsv`
key=`az cosmosdb keys list -n $dbName -g $rg --query primaryMasterKey -otsv`
conn="mongodb://$dbName:$key@$dbName.mongo.cosmos.azure.com:10255/contentdb?ssl=true&retrywrites=false&maxIdleTimeMS=120000&appName=@$dbName@"
acr=`az acr list -otable --query [].name -otsv`
helm upgrade --install fabmedical-helm ./fabmedical --namespace ingress-demo --create-namespace -f values2.yaml --set connectionString=$conn --set acr=$acr

kubectl config set-context --current --namespace ingress-demo
helm list
kubectl get pods

