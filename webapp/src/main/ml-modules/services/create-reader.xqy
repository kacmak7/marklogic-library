xquery version "1.0-ml";

module namespace create-reader = "http://marklogic.com/rest-api/resource/create-reader";

import schema namespace sch = "http://www.demo.com/reader" 
at "/reader.xsd";

declare namespace r = "http://www.demo.com/reader";
declare namespace p = "http://www.demo.com/person";
declare namespace rapi = "http://marklogic.com/rest-api";

declare function create-reader:get($context as map:map,
                            $params as map:map
                            ) as document-node()?{
    document{
    xdmp:set-response-content-type("text/html"),
    <html>
      <head>
        <title>Create new Reader</title>
      </head>
          <body>
            <form action = "http://localhost:8090/LATEST/resources/create-reader" method = "POST">
            ID: <input type="text" name="rs:id"></input>
            First Name: <input type="text" name="rs:fn"></input>
            Last Name: <input type="text" name="rs:ln"></input>
            Age: <input type="text" name="rs:age"></input>
            BookId: <input type="text" name="rs:bId"></input>
            BookId: <input type="text" name="rs:bId1"></input>
            BookId: <input type="text" name="rs:bId2"></input>
            BookId: <input type="text" name="rs:bId3"></input>
            BookId: <input type="text" name="rs:bId4"></input>
            BookId: <input type="text" name="rs:bId5"></input>
            BookId: <input type="text" name="rs:bId6"></input>
            BookId: <input type="text" name="rs:bId7"></input>
            <input name="rs:submit" type="submit"></input>
            </form>
          </body>
      </html>
    }
};

declare
%rapi:transaction-mode("update")
function create-reader:post(
 $context as map:map,
 $params  as map:map,
 $input   as document-node()*
 ) as document-node()? {
 document{
   let $x := <r:reader id="{map:get($params, "id")}">
               <p:firstname>{map:get($params, "fn")}</p:firstname>
               <p:lastname>{map:get($params, "ln")}</p:lastname>
               <p:age>{map:get($params, "age")}</p:age>
               {
                   if(map:get($params, "bId") != "")
                   then(
                       <r:bookId>{map:get($params, "bId")}</r:bookId>
                   )
                   else(
                       xdmp:log("bId")
                   ),
                   if(map:get($params, "bId1") != "")
                   then(
                       <r:bookId>{map:get($params, "bId1")}</r:bookId>
                   )
                   else(
                       xdmp:log("bId1")
                   ),
                   if(map:get($params, "bId2") != "")
                   then(
                       <r:bookId>{map:get($params, "bId2")}</r:bookId>
                   )
                   else(
                       xdmp:log("bId2")
                   ),
                   if(map:get($params, "bId3") != "")
                   then(
                       <r:bookId>{map:get($params, "bId3")}</r:bookId>
                   )
                   else(
                       xdmp:log("bId3")
                   ),
                   if(map:get($params, "bId4") != "")
                   then(
                       <r:bookId>{map:get($params, "bId4")}</r:bookId>
                   )
                   else(
                       xdmp:log("bId4")
                   ),
                   if(map:get($params, "bId5") != "")
                   then(
                       <r:bookId>{map:get($params, "bId5")}</r:bookId>
                   )
                   else(
                       xdmp:log("bId5")
                   ),
                   if(map:get($params, "bId6") != "")
                   then(
                       <r:bookId>{map:get($params, "bId6")}</r:bookId>
                   )
                   else(
                       xdmp:log("bId6")
                   ),
                   if(map:get($params, "bId7") != "")
                   then(
                       <r:bookId>{map:get($params, "bId7")}</r:bookId>
                   )
                   else(
                       xdmp:log("bId7")
                   )
               }
             </r:reader>
   return(
     if(count(xdmp:validate($x, "type", xs:QName("sch:ReaderType"))//error:error) = 0)
     then(
       if(xdmp:exists(doc("C:\library\reader.xml")))
         then(
           xdmp:node-insert-child(
           doc("C:\library\reader.xml")/r:readers,
           $x),
           <result>"INSERTED"</result>
         )
       else(
         xdmp:document-insert("C:\library\reader.xml", 
         <sos>test</sos>),
         xdmp:node-insert-child(doc("C:\library\reader.xml")/r:readers,
         $x),
         <result>"CREATED AND INSERTED"</result>
       )
     )
     else(
         <result>validation error</result>)
   )
 }
};

(:declare
%rapi:transaction-mode("update")
function create-reader:put(
  $context as map:map,
  $params  as map:map,
  $input   as document-node()*
  ) as document-node()? {
    document{
      let $x := $input/*
      return(
        <response>
          <q>"The record you want to insert: "</q>
          <doc>{$x}</doc>
        </response>,
        if(count(xdmp:validate($x, "type", xs:QName("sch:ReaderType"))//error:error) = 0)
        then(
          if(xdmp:exists(doc("C:\library\reader.xml")))
          then(
            xdmp:node-insert-child(
            doc("C:\library\reader.xml")/r:readers,
            $x),
            <result>"INSERTED"</result>
          )
          else(xdmp:document-insert("C:\library\reader.xml", 
          <sos>test</sos>),
          xdmp:node-insert-child(doc("C:\library\reader.xml")/r:readers,
          $x),
          <result>"CREATED AND INSERTED"</result>
          )
        )
        else(<result>"validation error"</result>)
      )
    }
};:)