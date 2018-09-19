xquery version "1.0-ml";

module namespace put-author = "http://marklogic.com/rest-api/resource/put-author";

declare namespace a = "http://www.demo.com/author";
declare namespace p = "http://www.demo.com/person";
declare namespace rapi = "http://marklogic.com/rest-api";

declare function create-author:get($context as map:map,
                            $params as map:map
                            ) as document-node()?{
    document{
    xdmp:set-response-content-type("text/html"),
    <html>
      <head>
        <title>Create new Author</title>
        </head>
          <body>
            <form action = "http://localhost:8090/LATEST/resources/create-author" method = "POST">
            ID: <input type="text" name="rs:id"></input>
            First Name: <input type="text" name="rs:fn"></input>
            Last Name: <input type="text" name="rs:ln"></input>
            Date of Birth: <input type="text" name="rs:dob"></input>
            Date of Death: <input type="text" name="rs:dod"></input>
            <input name="rs:submit" type="submit"></input>
          </form>
        </body>
      </html>
    }
};

declare
%rapi:transaction-mode("update")
function create-author:post(
    $context as map:map,
    $params  as map:map,
    $input   as document-node()*
    ) as document-node()? {
    document{
            xdmp:node-insert-child(
            doc("C:\library\author.xml")/a:authors,
            <a:author id="{map:get($params, "id")}">
                <p:firstname>{map:get($params, "fn")}</p:firstname>
                <p:lastname>{map:get($params, "ln")}</p:lastname>
                <a:date-of-birth>{map:get($params, "dob")}</a:date-of-birth>
                <a:date-of-death>{map:get($params, "dod")}</a:date-of-death>
            </a:author>
            )
    }
};

(:function create-author:put(
  $context as map:map,
  $params  as map:map,
  $input   as document-node()*
  ) as document-node()? {
    document{
      "put"
    }
};:)