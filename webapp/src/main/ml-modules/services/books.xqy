xquery version "1.0-ml";

module namespace books = "http://marklogic.com/rest-api/resource/books";

declare namespace b = "http://www.demo.com";
declare namespace p = "http://www.demo.com/person";

declare function books:get($context as map:map,
                            $params as map:map
                            ) as document-node()?{
    document{
    xdmp:set-response-content-type("text/html"),
    <html>
      <head>
        <title>Books</title>
      </head>
      <body>
        <h3>Books: </h3>
        <table border="3">
          <tr>
            <th>ID</th>
            <th>Title</th>
            <th>Date</th>
            <th>Author ID</th>
            <th>Availability</th>
          </tr>
          {
            for $book in doc("C:\library\book.xml")//b:book
            return
              <tr>
                <td>{data($book/@id)}</td>
                <td>{data($book/b:name)}</td>
                <td>{data($book/b:date)}</td>
                <td>{data($book/b:authorId)}</td>
                <td>{data($book/b:availability)}</td>
              </tr>
          }
          </table>
      </body>
    </html>
    }
};