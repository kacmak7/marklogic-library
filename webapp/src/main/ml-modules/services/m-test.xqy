xquery version "1.0-ml";

module namespace test = "http://marklogic.com/rest-api/resource/m-test";

declare function test:get($context as map:map,
                            $params as map:map
                            ) as document-node()? {
    document{
    xdmp:set-response-content-type("text/html"),
    <html>
        <body>
            <p>test</p>
        </body>
    </html>
    }
};