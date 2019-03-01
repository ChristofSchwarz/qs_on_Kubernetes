
# Troubleshooting

go <a href="https://github.com/ChristofSchwarz/qs_on_Kubernetes">back</a>

### Authentication failed

When you go to the new hub on Qlik Sense for Elastic, you may see this error message 
```
{"errors":[{"title":"Authentication failed","code":"LOGIN-1","status":"401"}]}
```
Let's find out what the issue is. Use SSH on the Linux where your Kubernetes is installed

 __1) Find out the id of the "qsefe-edge-auth"__
```
kubectl get pods | grep "qsefe-edge-auth"
```
   This should return one row like this

   qsefe-edge-auth-xxxxxxxxxx-xxxxx                                  2/2     Running   0          12h

   Now you know the exact instance id which we will copy/paste in the next command

 __2) Retrieve the log of the container__
 
   The log will be pretty long, so using "grep" we will filter only such rows where the keyword "ERROR" is found. Since the pod launches two containers (oidc and edge-auth) we also have to add -c and tell the command to return the logs of "edge-auth" container
```
kubectl logs qsefe-edge-auth-xxxxxxxxxx-xxxxx -c edge-auth | grep "ERROR"
```

__3) search for the error__

The syntax is JSON with no line-breaks, which makes it hard to read as a human. 

![alttext](https://github.com/ChristofSchwarz/pics/raw/master/issued_in_future.png "screenshot")   

In this example the error message is "id_token issued in the future". It may help to copy/paste the Json chunk and put it in an online-beautifyer like this: https://jsonformatter.curiousconcept.com/
