xquery version "1.0-ml";

module namespace author = "http://marklogic.com/rest-api/resource/author";

declare namespace a = "http://www.demo.com/author";
declare namespace p = "http://www.demo.com/person";

declare function author:get($context as map:map,
                            $params as map:map
                            ) as document-node()?{
    let $id := map:get($params, "id")
    return document{
    xdmp:set-response-content-type("text/html"),
    <html>
      <head>
        <title>Authors</title>
      </head>
      <body>
        <h3>Authors: </h3>
        <table border="3">
          <tr>
            <th>ID</th>
            <th>First Name</th>
            <th>Last Name</th>
            <th>Date of Birth</th>
            <th>Date of Death</th>
          </tr>
          {
            for $author in doc("C:\library\author.xml")//a:author[@id=$id]
            return
              <tr>
                <td>{data($author/@id)}</td>
                <td>{data($author/p:firstname)}</td>
                <td>{data($author/p:lastname)}</td>
                <td>{data($author/a:date-of-birth)}</td>
                <td>{data($author/a:date-of-death)}</td>
              </tr>
          }
          </table>
      </body>
    </html>
    }
};