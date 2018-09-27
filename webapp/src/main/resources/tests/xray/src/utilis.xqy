xquery version "1.0-ml";
module namespace utils = "http://release11/utils";
declare namespace res = "xdmp:http";
declare function post-results($url as xs:string, $data as xs:string)
{
    xdmp:http-post($url, <options xmlns="xdmp:http"><authentication method = "digest"><username>admin</username>
                    <password>mann</password></authentication>
                    <headers><content-type>application/xml</content-type></headers>
                    <data>{$data}</data></options>)
                    
};

declare function get-results($url as xs:string)
{
    xdmp:http-get($url, <options xmlns="xdmp:http"><authentication method = "digest"><username>admin</username>
                    <password>mann</password></authentication>
                    <headers><content-type>application/xml</content-type></headers>
                    </options>)
                    
};
declare function get-code($result) as xs:string 
{
    let $status := get-succes-code($result)
    return if($status)
            then $status 
            else get-error-code($result)
};
declare function get-succes-code($result) as xs:string 
{
    fn:string($result/res:code)
};

declare function get-error-code($result) as xs:string
{
     fn:string($result/errorResponse/statusCode)
};



