
## Using the NodeJS Webservice

At this point you should know a way to access the webservice, which is either a local running NodeJS app or a Pod in your 
Kubernetes cluster where you can either use "kubectl exec" or you installed a service (NodePort or LoadBalancer). No matter which way, 
the query string parameters you have to provide are key and are explained below.

This node app produces a JWT token and signs it with the key file "priv.key" which you made available with a secret (Kubernetes run mode) 
or which is in the same folder as app.js (in local run mode).

You will have to provide a few parameters as querystrings. The example syntax is:
```
http://localhost:31974/token?kid=my-key-identifier&sub=csw@qlik.com&name=Christof%20Schwarz&groups=["Finance","Everyone"]&expires=7200
```
The following query string arguments are supported/needed:
| param | type | explanation |
| ----- | ---- | ----------- |
| kid | mandadory | identifier also used in the identity-provider config |

 - sub (mandadory) : user id - can be the email
 - user : friendly name of user (default: the same as sub)
 - groups : an array of groups that the user is memmber of, syntax ["Finance","Everyone"] (default: ["Everyone"])
 - expires : seconds that the token will be valid for e.g. 7200 (default: 3600)
    
The generated JWT will look something like <a href="https://jwt.io#debugger-io?token=eyJhbGciOiJSUzI1NiIsInR5cCI6IkpXVCIsImtpZCI6Im15LWtleS1pZGVudGlmaWVyIn0.eyJpc3MiOiJodHRwczovL3FsaWsuYXBpLmludGVybmFsIiwiYXVkIjoicWxpay5hcGkiLCJzdWIiOiJjc3dAcWxpay5jb20iLCJncm91cHMiOlsiRmluYW5jZSIsIkV2ZXJ5b25lIl0sIm5hbWUiOiJDaHJpc3RvZiBTY2h3YXJ6IiwiZXhwIjoxNTY3Nzg4NjA0fQ.aHg-Tqy0hKEtJ31dp-yI6gDcyKwk_EwKfy9-82Mn-0GnZrapxkvyPpeBHSWfM58uPF6eqSvMW-L0li5jP2vSdVmgmvUSWHZ7ZmqzvDnrYwdCMGKVnwOo7aKqneJ19QcFf8YTwPQl-NeDnWQr-R2JyKb-oROpj4hI_nOT8Cl-dPnTxNNePa-LTwXbiQquAbPQUPIV6rSdaldumsiLoXno5XuywQVQGudX0D9D_WLNn0kKCQmSXMCkbDi7q2O9aPWS6EQYkP1I2PFX1BMYDgEQxqonhmavI2n73HzuzJFt02WEIhdm9eBAdvxK3O37yMY8K0vDjvm1pPbNsj2-NUVU-aPFFp0Uxa9K7PFg7O9cTeIsJJ_pcXbqKEztMiOBZ4MQj6-88yspPCK2Ycdp2NYORv-Iz9E54UDRXOIqJOCYKWnPMI8IoULFhFqH8vtQsou4jBKW4LYJ9E6g16OA1MnVZCihKURKADYQHZQXc1rs8vomJOJ35FLwhY2RbpXREmGuISxbzUwIilp7xt_6simWyDtfDcVM3YwbJNjXD_1YlKfWZb2zzzI2DYImtBcZy6_LKdJ9sktAxVjs4lLpHcPALiFXzfn-AwQN0UThP0kHcgHzpMnzktlMYiyXINJ_MF8tFMSj-JJHCMVd9-uGgvOtaKdm9suTeD_iWegjWAyC9Wo" target="_blank">this</a>.

Add the below yaml-settings to your qliksense .yaml and apply with helm upgrade (make sure you dont break the structure since you likely already have configured another identity-provider.)
 - The "hostname" entry can be the same as the you already had a configuration for (pointing to your idp such as auth0. 
 - The "realm" will become the static part of the user in QSEoK, whereas the "id" of the token will be the dynamic part. The exapmle below (realm: "custom") with the jwt claim "id" above will lead to a user in QSEoK to be like **custom\csw@qlik.com** 
 - the public key below is the matching key for the private key which is used to sign the jwt. If you don't want to create your own (which I encourage) you can use the pub_key.txt and priv_key.txt from this git.
