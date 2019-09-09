## Using The Bearer Token to Impersonate

**Note: This way to access can change or disappear in future versions of QSEoK. This is experimental**

If you got that far, you have created a JWT token one way or the other (using my NodeJS app locally, in K8s, or manually 
created the JWT-Token on jwt.io). 

Now you have to put the token as Bearer Authentication into the HTTP-Header with each API request. Two examples are given below, 
curl (replace <your cluster url> and <ey...> accordingly) and Postman

In either case I am calling the "who am i" endpoint /api/v1/users/me with GET
```
curl --request GET --url https://<your cluster url>/api/v1/users/me --header 'Authorization: Bearer <ey...>'
```
### Postman

<img src="https://raw.githubusercontent.com/ChristofSchwarz/qs_on_Kubernetes/master/jwtcreate/readme/postman.png"/>
