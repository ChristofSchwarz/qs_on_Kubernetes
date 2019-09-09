// Load in our dependencies
var express = require('express');
var jwt = require('jsonwebtoken');
var fs = require('fs');
// for testing you can place the priv.key file in the same folder as the app
// in Kubernetes you would mount a volume with a secret into /etc/secrets with priv.key in it
var privateKeyFile = fs.existsSync('/etc/secrets/priv.key')?'/etc/secrets/priv.key':'./priv.key';
console.log('Using key file ' + privateKeyFile);
var privkey = fs.readFileSync(privateKeyFile);
var app = express();

app.get('/token', function(appReq, appRes){
  if (!appReq.query.kid || !appReq.query.sub) {
    appRes.send(JSON.stringify({
      error: "must provide at least kid and sub querystring parameters",
      hint: "Query-strings supported are",
      args: [
        {kid : "identifier also used in the identity-provider config"},
        {sub : "user id - can be the email"},
        {user : "friendly name of user (if omitted it will be the same as sub)"},
        {groups : "an array of groups that the user is memmber of, syntax [\"Finance\",\"Everyone\"]"},
        {expires : "seconds that the token will be valid for e.g. 7200"}
      ],
      help: "https://github.com/ChristofSchwarz/qs_on_Kubernetes/tree/master/jwttokens"
    }));
  } else {
    var expSeconds = appReq.query.expires || 3600;
    //console.log(JSON.parse(req.query.groups));
    //jwt_payload.name = (req.query.hasOwnProperty('name')?req.query.name:'Unknown User');
    var jwt_payload = {
        iss: "https://qlik.api.internal",
        aud: "qlik.api",
        sub: appReq.query.sub,
        groups : (appReq.query.hasOwnProperty('groups')?JSON.parse(appReq.query.groups):['Everyone']),
        name: appReq.query.name||appReq.query.sub,
        exp: Math.round((new Date().getTime() + expSeconds * 1000)/1000)  
    };
    
    console.log(jwt_payload);
    var token = jwt.sign(jwt_payload, privkey, {algorithm: 'RS256', noTimestamp : true, header: {"kid": appReq.query.kid}});
    var response = {
        access_token: token,
        expires_in: expSeconds,
        payload: jwt_payload
    };
    appRes.header("Content-Type", "application/json");
    appRes.send(JSON.stringify(response));
    }
})

// Launch our app on port 3000
console.log('navigate to http://localhost:31974/token');
app.listen('31974');