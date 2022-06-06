Class dc.irisflow.components.fhiraas.FHIRaaSInboundAdapter Extends dc.irisflow.components.httpclient.HttpRequestInboundAdapter
{

Property FHIRaaSDeploymentId As %String(MAXLEN = "");

Property FHIRResource As %String(MAXLEN = "");

Property FHIRResourceId As %String(MAXLEN = "");

Property FHIRQueryString As %String(MAXLEN = "");

Parameter SETTINGS = "SSLConfig:Connection:sslConfigSelector,Https,ApiKey::credentialsSelector,FHIRaaSDeploymentId,FHIRResource,FHIRResourceId,FHIRQueryString";

Method OnInit() As %Status
{
    Set ..Server = $$$FormatText("fhir.%1.static-test-account.isccloud.io", ..FHIRaaSDeploymentId)
    Set ..Path = ..FHIRResource
    If (..FHIRResourceId '= "") {
        Set ..Path = ..Path_"/"_..FHIRResourceId
    }
    If (..FHIRQueryString '= "") {
        Set ..Path = ..Path_"?"_..FHIRQueryString
    }

    #; Set st = ##super()
    Set jobId = $Job
    If ($Get(@..gbl@(jobId)) = "") {
        Set httpResponse = ..HttpGet(..Path)
        Set response = {}.%FromJSON(httpResponse.Data)
        Do ..ProcessFHIRResponse(response)
        Set @..gbl@(jobId) = 1
    }
    
    Quit $$$OK
}

Method ProcessFHIRResponse(response As %DynamicAbstractObject)
{
    // todo: FHIR schema validation

    If (response.resourceType = "Bundle") {
        Set iterator = response.entry.%GetIterator()
        While iterator.%GetNext(.idx, .entry) {
            $$$TOE(st, ..BusinessHost.ProcessInput(entry.resource))
        }
    } Else {
        $$$TOE(st, ..BusinessHost.ProcessInput(response))
    }
}

}
