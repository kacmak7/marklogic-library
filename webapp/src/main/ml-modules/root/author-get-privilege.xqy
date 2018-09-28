xquery version "1.0-ml";
module namespace security = "http://marklogic.com/rest-api/resource/author-get-privilege";
declare variable $get-privilege := "webapp-get-role";
declare variable $post-privilege := "webapp-post-role";
declare variable $put-privilege := "webapp-put-role";
declare variable $delete-privilege := "webapp-delete-role";

declare function security-check($user as xs:string*, $required-role as xs:string) {
 let $user-roles := for $role in xdmp:user-roles($user)
                         return xdmp:role-name($role)
return
    if($user-roles)
        then if($required-role)
                then if($user-roles = $required-role)
                        then ()
                        else fn:error(xs:QName("Permission-denied"), "Insufficient permission")
                else fn:error(xs:QName("Empty-required-role"), "Given required roles are empty")
        else fn:error(xs:QName("Empty-roles"), "Given roles are empty")
};