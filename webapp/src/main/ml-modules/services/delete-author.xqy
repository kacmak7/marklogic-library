xquery version "1.0-ml";

module namespace delete-author = "http://marklogic.com/rest-api/resource/delete-author";

declare namespace a = "http://www.demo.com/author";
declare namespace p = "http://www.demo.com/person";
declare namespace rapi = "http://marklogic.com/rest-api";

import module namespace security = "http://marklogic.com/rest-api/resource/author-get-privilege" 
at "/author-get-privilege.xqy";

declare function delete-author:get(
    $context as map:map,
    $params as map:map
    ) as document-node()? {
    security:security-check(xdmp:get-current-user(), $security:get-privilege),
    document{
    xdmp:set-response-content-type("text/html"),
    <html>
      <head>
        <title>Delete Author</title>
        </head>
          <body>
            <form action = "http://localhost:8090/LATEST/resources/delete-author" method = "POST">
            ID: <input type="text" name="rs:id"></input>
            <input name="rs:submit" type="submit"></input>
          </form>
        </body>
      </html>
    }
};

declare
%rapi:transaction-mode("update")
function delete-author:post(
 $context as map:map,
 $params  as map:map,
 $input   as document-node()*
 ) as document-node()? {
   security:security-check(xdmp:get-current-user(), $security:post-privilege),
   xdmp:set-response-content-type("text/html"),
    document{
     <html>
        <body>
            <h3>Deleted record:</h3>
            {
                let $author := doc("/author.xml")//a:author[@id=xs:int(data(map:get($params, "id")))]
                return (
                    <p>ID: {data($author/@id)[1]}</p>,
                    <p>First Name: {data($author/p:firstname)[1]}</p>,
                    <p>Last Name: {data($author/p:lastname)[1]}</p>,
                    <p>Date of Birth: {data($author/a:date-of-birth)[1]}</p>,
                    <p>Date of Death: {data($author/a:date-of-death)[1]}</p>
                )
            }
        </body>
     </html>
 }, 
 xdmp:node-delete(doc("/author.xml")//a:author[@id=xs:int(data(map:get($params, "id")))])
};