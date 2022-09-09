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

Method EstimateGeneric(pPayload As dc.irisflow.interoplib.climatiq.msg.beta3.EstimateMsg) As %Net.HttpResponse
{
    #Dim request = ..CreateRequest()
    Set url = "https://"_..GetServer()_"/estimate"
    Set json = {
            "emission_factor": ({}.%FromJSON(pPayload.EmissionFactor)),
            "parameters": ({}.%FromJSON(pPayload.Parameters))
        }.%ToJSON()
    Set data(1) = json
    $$$TOE(st, ..Adapter.SendFormDataArray(.response, "POST", request, "", .data, url))
    Return response
}

Method EstimateFlight(pPayload As dc.irisflow.interoplib.climatiq.msg.beta3.EstimateFlightLegsMsg) As %Net.HttpResponse
{
    #Dim request = ..CreateRequest()
    Set url = "https://"_..GetServer()_"/travel/flights"
    $$$TOE(st, pPayload.%JSONExportToString(.json))
    Set data(1) = json
    $$$TOE(st, ..Adapter.SendFormDataArray(.response, "POST", request, "", .data, url))
    Return response
}

}
