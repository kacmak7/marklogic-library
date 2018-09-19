(:xquery version "1.0-ml";

module namespace val = "http://marklogic.com/rest-api/resource/validation";

declare namespace a = "http://www.demo.com/author";
declare namespace p = "http://www.demo.com/person";
declare namespace rapi = "http://marklogic.com/rest-api";

declare
%rapi:transaction-mode("update")
function val:put(
  $context as map:map,
  $params  as map:map,
  $input   as document-node()*
  ) as document-node()? {
    document{
      let $x := <a:author id="{$input//@id}">
                  <p:firstname>{data($input//firstname)}</p:firstname>
                  <p:lastname>{data($input//lastname)}</p:lastname>
                  <a:date-of-birth>{data($input//date-of-birth)}</a:date-of-birth>
		              <a:date-of-death>{data($input//date-of-death)}</a:date-of-death>
                </a:author>
      return xdmp:node-insert-child(
        doc("C:\library\author.xml")/a:authors,
        $x)
    }
};