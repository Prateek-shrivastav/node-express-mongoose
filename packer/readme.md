

## build image:

1.docker login 
```sh
docker login 
```
2. run following command 

```sh
cd packer 
packer build -var 'tag_no=dev'  -var 'docker_image_id=jbapna/node-express-mongoose'  nodejsapp.json

```



##run docker image local: 

```sh
docker network create myNetwork

# run mongo db container 
docker run -d -p 27017:27017 --network myNetwork --name mongo mongo
# export env parameter (if pass nil you are not able to use social login)

export TWITTER_CLIENTID="nil"
export TWITTER_SECRET="nil"
export GITHUB_CLIENTID="nil"
export GITHUB_SECRET="nil"
export LINKEDIN_CLIENTID="nil"
export LINKEDIN_SECRET="nil"
export GOOGLE_CLIENTID="nil"
export GOOGLE_SECRET="nil"
export MONGODB_URL=mongodb://mongo:27017/noobjs_dev

```


## dev start : 

```sh

 docker run -i --network myNetwork --name nodejs8 --env TWITTER_CLIENTID=${TWITTER_CLIENTID} --env TWITTER_SECRET=${TWITTER_SECRET} --env GITHUB_CLIENTID=${GITHUB_CLIENTID} --env GITHUB_SECRET=${GITHUB_SECRET} --env LINKEDIN_CLIENTID=${LINKEDIN_CLIENTID} --env LINKEDIN_SECRET=${LINKEDIN_SECRET} --env GOOGLE_CLIENTID=${GOOGLE_CLIENTID} --env GOOGLE_SECRET=${GOOGLE_SECRET} --env MONGODB_URL=${MONGODB_URL}  -p 3000:3000  jbapna/node-express-mongoose:dev-1.0.0 


```

## prod start: 

```sh

 docker run -i --network myNetwork --name nodejs7 --env TWITTER_CLIENTID=${TWITTER_CLIENTID} --env TWITTER_SECRET=${TWITTER_SECRET} --env GITHUB_CLIENTID=${GITHUB_CLIENTID} --env GITHUB_SECRET=${GITHUB_SECRET} --env LINKEDIN_CLIENTID=${LINKEDIN_CLIENTID} --env LINKEDIN_SECRET=${LINKEDIN_SECRET} --env GOOGLE_CLIENTID=${GOOGLE_CLIENTID} --env GOOGLE_SECRET=${GOOGLE_SECRET} --env MONGODB_URL=${MONGODB_URL}  -p 3000:3000  jbapna/node-express-mongoose:dev-1.0.0 npm run prod

```