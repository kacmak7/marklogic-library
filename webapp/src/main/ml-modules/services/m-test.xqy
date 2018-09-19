xquery version "1.0-ml";

module namespace test = "http://marklogic.com/rest-api/resource/m-test";

declare function test:get(
    $context as map:map,
    $params as map:map
    ) as document-node()? {
    document{
    xdmp:set-response-content-type("text/html"),
    <html>
        <body>
            <h3>test</h3>
            {
                for $x in doc("test.xml")//test
                return <p>{data($x)}</p>
            }
            <form action="http://localhost:8090/LATEST/resources/m-test" method="post"> 
                <input name="rs:id" type="text"></input>
                <input name="rs:submit" type="submit"></input>
            </form>
            <form action="http://localhost:8090/LATEST/resources/m-test" method="post"> 
                <input name="msg" type="text"></input>
                <input name="submit" type="submit"></input>
            </form>
        </body>
    </html>
    }
};

declare function test:post(
    $context as map:map,
    $params  as map:map,
    $input   as document-node()*
    ) as document-node()? {
    document{
        xdmp:set-response-content-type("text/html"),
        <html>
            <body>
                <p>post</p>
                {
                    xdmp:log($input),
                    xdmp:log("dupa1")
                }
            </body>
        </html>
    }
};
declare function test:put(
    $context as map:map,
    $params  as map:map,
    $input   as document-node()*
    ) as document-node()? {
        document{
            "put"
        }
    };        