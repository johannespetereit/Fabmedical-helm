export MCW_SUFFIX=575205
export ACR_PW=xxxx

# docker tag fabmedical$MCW_SUFFIX.azurecr.io/content-api:latest petereitadesso/content-api:latest
# docker tag fabmedical$MCW_SUFFIX.azurecr.io/content-web:latest petereitadesso/content-web:latest
# docker login
# docker image push petereitadesso/content-api:latest
# docker image push petereitadesso/content-web:latest


docker image pull petereitadesso/content-api:latest
docker image pull petereitadesso/content-web:latest

docker tag petereitadesso/content-api:latest fabmedical$MCW_SUFFIX.azurecr.io/content-api:latest
docker tag petereitadesso/content-web:latest fabmedical$MCW_SUFFIX.azurecr.io/content-web:latest

# replace ACR pw
docker login fabmedical$MCW_SUFFIX.azurecr.io -u fabmedical575205 -p $ACR_PW
docker image push fabmedical$MCW_SUFFIX.azurecr.io/content-api:latest
docker image push fabmedical$MCW_SUFFIX.azurecr.io/content-web:latest
