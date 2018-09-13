xquery version "1.0-ml";

module namespace test1 = "http://marklogic.com/rest-api/resource/m-test1";

declare function test1:get($context as map:map,
                            $params as map:map
                            ) as document-node()? {
    document{
    xdmp:set-response-content-type("text/html"),
    <html>
        <body>
            <h3>test1</h3>
            <p>{xdmp:get-original-url()}</p>
        </body>
    </html>
    }
};