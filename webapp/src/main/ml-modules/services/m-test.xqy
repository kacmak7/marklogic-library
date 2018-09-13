xquery version "1.0-ml";

module namespace test = "http://marklogic.com/rest-api/resource/m-test";

declare function test:get($context as map:map,
                            $params as map:map
                            ) as document-node()? {
    document{
    xdmp:set-response-content-type("text/html"),
    <html>
        <body>
            <h3>test</h3>
            <br></br>
            {
                for $x in doc("test.xml")//test
                return <p>{data($x)}</p>
            }
        </body>
    </html>
    }
};