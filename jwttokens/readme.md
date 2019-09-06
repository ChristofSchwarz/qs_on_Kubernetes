# Impersonating into QSEoK using JWT 

### Warning
This is tested on Qlik Sense Enterprise on Kubernetes Versions June 2019 and Sept 2019, there is no guarantee that this continues to work like that. It is an undocumented feature. 

### Installing
Download this folder (node.js, package.json, priv_, pub_key.txt, pub_key.txt). You need npm and node (NodeJs). To install the dependencies, run from the same folder ... 
```
npm install
node app.js
```

### Using it
This node app starts a minimalistic webservice on port 31974 ... it produces a JWT token and signs it with the key file "priv_key.txt" in a format, that QSEoK will accept as a Bearer Token. You will have to provide a few parameters as querystrings like

http://localhost:31974/token?kid=my-key-identifier&sub=csw@qlik.com&name=Christof%20Schwarz&groups=["Finance","Everyone"]&expires=7200

The following query string arguments are supported/needed:

 - kid (mandadory) : identifier also used in the identity-provider config
 - sub (mandadory) : user id - can be the email
 - user : friendly name of user (default: the same as sub)
 - groups : an array of groups that the user is memmber of, syntax ["Finance","Everyone"] (default: ["Everyone"])
 - expires : seconds that the token will be valid for e.g. 7200 (default: 3600)
    
The generated JWT will look something like <a href="https://jwt.io#debugger-io?token=eyJhbGciOiJSUzI1NiIsInR5cCI6IkpXVCIsImtpZCI6Im15LWtleS1pZGVudGlmaWVyIn0.eyJpc3MiOiJodHRwczovL3FsaWsuYXBpLmludGVybmFsIiwiYXVkIjoicWxpay5hcGkiLCJzdWIiOiJjc3dAcWxpay5jb20iLCJncm91cHMiOlsiRmluYW5jZSIsIkV2ZXJ5b25lIl0sIm5hbWUiOiJDaHJpc3RvZiBTY2h3YXJ6IiwiZXhwIjoxNTY3Nzg4NjA0fQ.aHg-Tqy0hKEtJ31dp-yI6gDcyKwk_EwKfy9-82Mn-0GnZrapxkvyPpeBHSWfM58uPF6eqSvMW-L0li5jP2vSdVmgmvUSWHZ7ZmqzvDnrYwdCMGKVnwOo7aKqneJ19QcFf8YTwPQl-NeDnWQr-R2JyKb-oROpj4hI_nOT8Cl-dPnTxNNePa-LTwXbiQquAbPQUPIV6rSdaldumsiLoXno5XuywQVQGudX0D9D_WLNn0kKCQmSXMCkbDi7q2O9aPWS6EQYkP1I2PFX1BMYDgEQxqonhmavI2n73HzuzJFt02WEIhdm9eBAdvxK3O37yMY8K0vDjvm1pPbNsj2-NUVU-aPFFp0Uxa9K7PFg7O9cTeIsJJ_pcXbqKEztMiOBZ4MQj6-88yspPCK2Ycdp2NYORv-Iz9E54UDRXOIqJOCYKWnPMI8IoULFhFqH8vtQsou4jBKW4LYJ9E6g16OA1MnVZCihKURKADYQHZQXc1rs8vomJOJ35FLwhY2RbpXREmGuISxbzUwIilp7xt_6simWyDtfDcVM3YwbJNjXD_1YlKfWZb2zzzI2DYImtBcZy6_LKdJ9sktAxVjs4lLpHcPALiFXzfn-AwQN0UThP0kHcgHzpMnzktlMYiyXINJ_MF8tFMSj-JJHCMVd9-uGgvOtaKdm9suTeD_iWegjWAyC9Wo" target="_blank">this</a>.

Add the below yaml-settings to your qliksense .yaml and apply with helm upgrade (make sure you dont break the structure since you likely already have configured another identity-provider.)
 - The "hostname" entry can be the same as the you already had a configuration for (pointing to your idp such as auth0. 
 - The "realm" will become the static part of the user in QSEoK, whereas the "id" of the token will be the dynamic part. The exapmle below (realm: "custom") with the jwt claim "id" above will lead to a user in QSEoK to be like **custom\csw@qlik.com** 
 - the public key below is the matching key for the private key which is used to sign the jwt. If you don't want to create your own (which I encourage) you can use the pub_key.txt and priv_key.txt from this git.

```
identity-providers:
  secrets:
    idpConfigs:
      - hostname: "51.141.29.221"
        realm: "custom"
        primary: false
        issuerConfig:
          issuer: "https://qlik.api.internal"
        staticKeys:
        - kid: "my-key-identifier"
          pem: |-
            -----BEGIN PUBLIC KEY-----
            MIICIjANBgkqhkiG9w0BAQEFAAOCAg8AMIICCgKCAgEApcxutPf8kK6TK4cX4abY
            EArPDVngZBqww7H9tOWhU+micMkRMQhyMnxYFhPIF/BHrdDQ5ph8W6zzggVyk8k+
            WiY/BHec3nGIgoXbe/5K45ChJhhrMj9CCJqHd1Q3stxfEMkwWupiJ8DDsUgqMfVz
            t8ufBiKtnLw5v51T6+8Or9TgZ5L+vnAc+uW5RbDT5iAPT2Zqapk4aYU4B9bVY0t0
            D5T2s56HmdzTYG8OvUsjdkMRUGvZmD358upX0jG0sRdQZC68Ej92yMZNJFZh+w+E
            9Q525ZNah4piioP/4714FAfjh8rU0T1ndrXbhgyWHbTXRlLJ8B4oyFgi+XyjFZLP
            hwOp25QMV08t2Lwn4g8aMW7lz0jYSTSETJF6rWIspwc7iSQ6KNtogJyyphxIRi2E
            XXgPJScSf8YeGDqFYXaGd4ysoRWgOKnEY69dYRT805YzGpr6NLcXZJ3SMYoJS6NI
            1OAlOSUdRCLWs67WtlHb3g1zCD20/0AV8TAo7Yvah2WKzBtKnDzQNKa/RK5ahQ+a
            +O692il39bR/3E+EEvBseCLwqhJpyJ5IgXjFiIAj56mdbSMj8xRof/mrYN2ofr2A
            4zl7HanxuF79w+G70RE9Y7my4zA9jlAFyVABD8Iuee+sSh8OQXMqLCa+8wmgrejC
            SJxIUvPgQpuWgVRrDQMHobMCAwEAAQ==
            -----END PUBLIC KEY-----
```






