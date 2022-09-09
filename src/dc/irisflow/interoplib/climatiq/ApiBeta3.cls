Class dc.irisflow.interoplib.climatiq.ApiBeta3 Extends dc.irisflow.interoplib.climatiq.Api
{

Parameter Server = "beta3.api.climatiq.io";

Method GetServer() As %String
{
    Return ..#Server
}

Method CreateRequest() As %Net.HttpRequest
{
    #Dim request = ##class(%Net.HttpRequest).%New()
    Do request.SetHeader("Authorization", "Bearer "_..ApiKey)
    Do request.SetHeader("Accept-Encoding", "gzip")
    Return request
}

Method Estimate(pPayload As dc.irisflow.interoplib.climatiq.EstimateMsg) As %Net.HttpResponse
{
    #Dim request = ..CreateRequest()
    
    Set json = {
            "emission_factor": ({}.%FromJSON(pPayload.EmissionFactor)),
            "parameters": ({}.%FromJSON(pPayload.Parameters))
        }.%ToJSON()
    Set data(1) = json

    Set url = "https://"_..GetServer()_"/estimate"
    
    $$$TOE(st, ..Adapter.SendFormDataArray(.response, "POST", request, "", .data, url))
    Return response
}

}
