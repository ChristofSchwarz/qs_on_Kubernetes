## run locally
Prerequesites:
 - You have access with helm to Qlik Sense Enterprise on Kubernetes in your Cluster and you already edited the "identity-provider" section in the qliksense.yaml (readme.md)
 - You have NodeJS (and its package manager NPM) installed locally
 - You have downloaded this git and created your own SSH keys (recommended), the private key is in the same folder and called "priv.key"
 
Open CMD or SH and navigate to this folder, where app.js is located. Run the following commands:
```
npm install
node app.js
```
A local web service will start. You can use curl or a web browser and navigate to http://localhost:31974/token?... 

Finally, learn how to <a href="https://github.com/ChristofSchwarz/qs_on_Kubernetes/blob/master/jwtcreate/readme/webservice.md">use this webservice</a>
