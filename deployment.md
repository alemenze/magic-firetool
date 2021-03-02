# Deployment notes
Based on [rand3k](https://github.com/randy3k/shiny-cloudrun-demo) repo

```
PROJECTID=$(gcloud config get-value project)
docker build . -t gcr.io/$PROJECTID/magic-firetool
```
```
docker push gcr.io/$PROJECTID/magic-firetool
```
```
gcloud run deploy --image gcr.io/$PROJECTID/magic-firetool --platform managed --max-instances 1
```
Manually adjust CPUs and RAM applied to the container as it may be custom. 