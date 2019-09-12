function (user, context, callback) {
  // Get the user roles from the Authorization context
  const assignedRoles = (context.authorization || {}).roles;
  // Update the user object.
  context.idToken['https://qlik.com/groups'] = assignedRoles;
  context.idToken['https://qlik.com/sub'] = user.email;  
  callback(null, user, context);
}
