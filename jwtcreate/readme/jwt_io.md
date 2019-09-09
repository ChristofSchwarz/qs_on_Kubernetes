## Using JWT.IO
This is an alternative way to create a JWT token, but you have to copy/paste quite some information for each token.
 - Go to https://jwt.io
 - Paste this into the "HEADER" field:
```
{
  "alg": "RS256",
  "typ": "JWT",
  "kid": "my-identifier"
}
```
 - Paste this into the "PAYLOAD DATA" field:
```
{
  "iss": "https://qlik.api.internal",
  "aud": "qlik.api",
  "sub": "user@company.com",
  "groups": [
    "Everyone",
    "OtherGroup"
  ],
  "name": "FirstName LastName",
  "exp": 2000000000
} 
```
 - Paste the content of your pub.key into the first field of "VERIFY SIGNATURE"
 - Paste the content of your priv.key into the second field of "VERIFY SIGNATURE"
 
 <img src="https://raw.githubusercontent.com/ChristofSchwarz/qs_on_Kubernetes/master/jwtcreate/readme/jwtio.png"/>
 
Now you can use the token to impersonate. <a href="https://github.com/ChristofSchwarz/qs_on_Kubernetes/blob/master/jwtcreate/readme/using_token.md">Check out</a> how to use it.
