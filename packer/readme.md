

build image:

packer build -var 'tag_no=1' nodejsapp.json

run docker image localy: 


sudo docker network create myNetwork

sudo docker run -d -p 27017:27017 --network myNetwork --name mongo mongo


export TWITTER_CLIENTID="nil"
export TWITTER_SECRET="nil"
export GITHUB_CLIENTID="nil"
export GITHUB_SECRET="nil"
export LINKEDIN_CLIENTID="nil"
export LINKEDIN_SECRET="nil"
export GOOGLE_CLIENTID="nil"
export GOOGLE_SECRET="nil"
export MONGODB_URL=mongodb://mongo:27017/noobjs_dev


dev start : 

sudo docker run -i --network myNetwork --name nodejs8 --env TWITTER_CLIENTID=${TWITTER_CLIENTID} --env TWITTER_SECRET=${TWITTER_SECRET} --env GITHUB_CLIENTID=${GITHUB_CLIENTID} --env GITHUB_SECRET=${GITHUB_SECRET} --env LINKEDIN_CLIENTID=${LINKEDIN_CLIENTID} --env LINKEDIN_SECRET=${LINKEDIN_SECRET} --env GOOGLE_CLIENTID=${GOOGLE_CLIENTID} --env GOOGLE_SECRET=${GOOGLE_SECRET} --env MONGODB_URL=${MONGODB_URL}  -p 3000:3000  sample/nodejsapp:1  npm start

prod start: 

sudo docker run -i --network myNetwork --name nodejs7 --env TWITTER_CLIENTID=${TWITTER_CLIENTID} --env TWITTER_SECRET=${TWITTER_SECRET} --env GITHUB_CLIENTID=${GITHUB_CLIENTID} --env GITHUB_SECRET=${GITHUB_SECRET} --env LINKEDIN_CLIENTID=${LINKEDIN_CLIENTID} --env LINKEDIN_SECRET=${LINKEDIN_SECRET} --env GOOGLE_CLIENTID=${GOOGLE_CLIENTID} --env GOOGLE_SECRET=${GOOGLE_SECRET} --env MONGODB_URL=${MONGODB_URL}  -p 3000:3000  sample/nodejsapp:1 
