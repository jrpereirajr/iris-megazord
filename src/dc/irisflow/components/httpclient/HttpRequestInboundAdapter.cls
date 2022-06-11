Class dc.irisflow.components.httpclient.HttpRequestInboundAdapter Extends Ens.InboundAdapter
{

Property gbl As %String [ InitialExpression = {"^g"_$REPLACE($System.Util.CreateGUID(), "-", "")} ];

Property SSLConfig As %String;

Property Https As %Boolean;

Property Server As %String;

Property Path As %String;

Property ApiKey As %String;

Parameter SETTINGS = "SSLConfig:Connection:sslConfigSelector,Https,Server,Path,ApiKey::credentialsSelector";

Method OnInit() As %Status
{
    Set st = $$$OK
    $$$TRACE(..%ClassName(1)_":OnInit")
    Quit st
}

Method OnTearDown() As %Status
{
    Kill @..gbl
    $$$TRACE(..%ClassName(1)_":OnTearDown")
	Quit $$$OK
}

Method OnTask() As %Status
{
    Set st = $$$OK
	Set response = {}

    Set jobId = $Job
    If ($Get(@..gbl@(jobId)) = "") {
        Set httpResponse = ..HttpGet(..Path)
        Set response = {}.%FromJSON(httpResponse.Data)
        $$$TOE(st, ..BusinessHost.ProcessInput(response))
        Set @..gbl@(jobId) = 1
    }

    Return st
}

Method GetApiKey() As %String
{
    Set apiKeyCred = ..ApiKey
    $$$TOE(st, ##class(Ens.Config.Credentials).GetCredentialsObj(.apiKeyCredObj, "", "Ens.Config.Credentials", apiKeyCred))
    Return apiKeyCredObj.Password
}

Method CreateRequest() As %Net.HttpRequest
{
    Set request = ##class(%Net.HttpRequest).%New()
    Do request.SSLConfigurationSet(..SSLConfig)
    Set request.Https = ..Https
    Set request.Server = ..Server
    Set headers = {
        "x-api-key" : (..GetApiKey())
    }
    Set headersIt = headers.%GetIterator()
    While (headersIt.%GetNext(.headerName, .headerValue)) {
        Do request.SetHeader(headerName, headerValue)
    }
    Return request
}

Method ValidateHttpResponse(response As %Net.HttpResponse)
{
    If (response.StatusCode '= 200) {
        $$$ThrowStatus($$$ERROR(5001, "HTTP StatusCode = "_response.StatusCode))
    }
}

Method HttpGet(path As %String) As %Net.HttpResponse
{
    #Dim request As %Net.HttpRequest = ..CreateRequest()
    $$$TOE(st, request.Get(path))
    Set response = request.HttpResponse
    Do ..ValidateHttpResponse(response)
    Return response
}

}
