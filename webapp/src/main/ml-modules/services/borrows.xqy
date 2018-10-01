xquery version "1.0-ml";

module namespace borrows = "http://marklogic.com/rest-api/resource/borrows";

declare namespace bb = "http://www.demo.com/borrow";

declare function borrows:get($context as map:map,
                            $params as map:map
                            ) as document-node()?{
    document{
    xdmp:set-response-content-type("text/html"),
    <html>
      <head>
        <title>Borrows</title>
      </head>
      <body>
        <h3>Borrows: </h3>
        <table border="3">
          <tr>
            <th>ID</th>
            <th>Book ID</th>
            <th>Reader ID</th>
          </tr>
          {
            for $borrow in doc("/borrow.xml")//bb:borrow
            return
              <tr>
                <td>{data($borrow/@id)}</td>
                <td>{data($borrow/bb:bookId)}</td>
                <td>{data($borrow/bb:readerId)}</td>
              </tr>
          }
          </table>
      </body>
    </html>
    }
};