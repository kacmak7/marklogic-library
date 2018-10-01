xquery version "1.0-ml";

module namespace create-book = "http://marklogic.com/rest-api/resource/create-book";

import schema namespace sch = "http://www.demo.com"
at "/book.xsd";

declare namespace b = "http://www.demo.com";
declare namespace rapi = "http://marklogic.com/rest-api";

declare function create-book:get($context as map:map,
                            $params as map:map
                            ) as document-node()?{
    document{
    xdmp:set-response-content-type("text/html"),
    <html>
      <head>
        <title>Create new Book</title>
        </head>
          <body>
            <form action = "http://localhost:8090/LATEST/resources/create-book" method = "POST">
            ID: <input type="text" name="rs:id"></input>
            Title: <input type="text" name="rs:name"></input>
            Date: <input type="text" name="rs:date"></input>
            AuthorId: <input type="text" name="rs:aId"></input>
            Availability: <input type="text" name="rs:ava"></input>
            <input name="rs:submit" type="submit"></input>
          </form>
        </body>
      </html>
    }
};

declare
%rapi:transaction-mode("update")
function create-book:post(
 $context as map:map,
 $params  as map:map,
 $input   as document-node()*
 ) as document-node()? {
 document{
   let $x := <b:book id="{map:get($params, "id")}">
               <b:name>{map:get($params, "name")}</b:name>
               <b:date>{map:get($params, "date")}</b:date>
               <b:authorId>{map:get($params, "aId")}</b:authorId>
               <b:availability>{map:get($params, "ava")}</b:availability>
             </b:book>
   return(
     if(count(xdmp:validate($x, "type", xs:QName("sch:BookType"))//error:error) = 0)
     then(
       if(xdmp:exists(doc("/book.xml")))
         then(
           xdmp:node-insert-child(
           doc("/book.xml")/b:books,
           $x),
           <result>"INSERTED"</result>
         )
        else(
         xdmp:document-insert("/book.xml", 
         <boook>test</boook>),
         xdmp:node-insert-child(doc("/book.xml")/b:books,
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
function create-book:put(
  $context as map:map,
  $params  as map:map,
  $input   as document-node()*
  ) as document-node()? {
    document{
         let $x :=  <b:book id="{data($input//@id)}">
                        <b:name>{data($input//name)}</b:name>
                        <b:date>{data($input//date)}</b:date>
                        <b:authorId>{data($input//authorId)}</b:authorId>
		                <b:availability>{data($input//availability)}</b:availability>
                    </b:book>
        return(
            <response>
                <q>"The record you want to insert: "</q>
                <doc>{$x}</doc>
            </response>,
        if(count(xdmp:validate($x, "type", xs:QName("sch:BookType"))//error:error) = 0)
        then(
            if(xdmp:exists(doc("/book.xml")))
            then(
                xdmp:node-insert-child(
                doc("/book.xml")/b:books,
                $x),
                <result>"INSERTED"</result>
            )
            else(
                xdmp:document-insert("/book.xml", 
                $x),
            <result>"CREATED AND INSERTED"</result>
            )
        )
            else(<result>validation error</result>)
        )
    }
};