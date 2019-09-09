## run locally
Prerequesites:
 - You have NodeJS (and its package manager NPM) installed locally
 - You have access with helm to Qlik Sense Enterprise on Kubernetes in your Cluster, since you have to edit the "identityprovider" section

Open CMD or SH and navigate to this folder, where app.js is located. Run the following commands:
```
npm install
node app.js
```
A local web service will start. You can use curl or a web browser and navigate to http://localhost:31974/token 
Read on under "Using the webservice" to understand the parameters of it.
