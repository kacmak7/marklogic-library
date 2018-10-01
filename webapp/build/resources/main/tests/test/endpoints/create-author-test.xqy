xquery version "1.0-ml";
module namespace test = "http://github.com/robwhitby/xray/test";
declare namespace xray ="http://github.com/robwhitby/xray";
import module namespace  utils = "http://release11/utils" at "/xray/src/utilis.xqy";
import module namespace assert = "http://github.com/robwhitby/xray/assertions" at "/xray/src/assertions.xqy";
declare namespace res = "xdmp:http";

declare %test:case function get-create-author-form()
{
    let $results := utils:get-results("http://localhost:8090/LATEST/resources/create-author")
    return (assert:equal(utils:get-code($results), "200"))
};
