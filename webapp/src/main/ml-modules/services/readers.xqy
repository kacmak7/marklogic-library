xquery version "1.0-ml";

module namespace readers = "http://marklogic.com/rest-api/resource/readers";

declare namespace r = "http://www.demo.com/reader";
declare namespace p = "http://www.demo.com/person";

declare function readers:get($context as map:map,
                            $params as map:map
                            ) as document-node()?{
    document{
    xdmp:set-response-content-type("text/html"),
    <html>
      <head>
        <title>Readers</title>
      </head>
      <body>
        <h3>Readers: </h3>
        <table border="3">
          <tr>
            <th>ID</th>
            <th>First Name</th>
            <th>Last Name</th>
            <th>Age</th>
            <th>Book ID</th>
          </tr>
          {
            for $reader in doc("/reader.xml")//r:reader
            return
              <tr>
                <td>{data($reader/@id)}</td>
                <td>{data($reader/p:firstname)}</td>
                <td>{data($reader/p:lastname)}</td>
                <td>{data($reader/p:age)}</td>
                <td>{data($reader/r:bookId)}</td>
              </tr>
          }
          </table>
      </body>
    </html>
    }
};