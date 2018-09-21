xquery version "1.0-ml";

module namespace create-author = "http://marklogic.com/rest-api/resource/create-author";

import schema namespace sch = "http://www.demo.com/author" 
at "author.xsd";

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
   let $x := <a:author id="{map:get($params, "id")}">
               <p:firstname>{map:get($params, "fn")}</p:firstname>
               <p:lastname>{map:get($params, "ln")}</p:lastname>
               <a:date-of-birth>{map:get($params, "dob")}</a:date-of-birth>
               <a:date-of-death>{map:get($params, "dod")}</a:date-of-death>
             </a:author>
   return(
     if(count(xdmp:validate($x, "type", xs:QName("sch:AuthorType"))//error:error) = 0)
     then(
       if(xdmp:exists(doc("C:\library\author.xml")))
         then(
           xdmp:node-insert-child(
           doc("C:\library\author.xml")/a:authors,
           $x),
           <result>"INSERTED"</result>
         )
       else(
         xdmp:document-insert("C:\library\author.xml", 
         <sos>test</sos>),
         xdmp:node-insert-child(doc("C:\library\author.xml")/a:authors,
         $x),
         <result>"CREATED AND INSERTED"</result>
       )
     )
     else(<result>validation error</result>)
   )
 }
};

declare
%rapi:transaction-mode("update")
function create-author:put(
  $context as map:map,
  $params  as map:map,
  $input   as document-node()*
  ) as document-node()? {
    document{
      let $x := <a:author id="{data($input//@id)}">
                  <p:firstname>{data($input//firstname)}</p:firstname>
                  <p:lastname>{data($input//lastname)}</p:lastname>
                  <a:date-of-birth>{data($input//date-of-birth)}</a:date-of-birth>
		              <a:date-of-death>{data($input//date-of-death)}</a:date-of-death>
                </a:author>
      return(
        <response>
          <q>"The record you want to insert: "</q>
          <doc>{$x}</doc>
        </response>,
        if(count(xdmp:validate($x, "type", xs:QName("sch:AuthorType"))//error:error) = 0)
        then(
          if(xdmp:exists(doc("C:\library\author.xml")))
          then(
            xdmp:node-insert-child(
            doc("C:\library\author.xml")/a:authors,
            $x),
            <result>"INSERTED"</result>
          )
          else(xdmp:document-insert("C:\library\author.xml", 
          <sos>test</sos>),
          xdmp:node-insert-child(doc("C:\library\author.xml")/a:authors,
          $x),
          <result>"CREATED AND INSERTED"</result>
          )
        )
        else(<result>"validation error"</result>)
      )
    }
};