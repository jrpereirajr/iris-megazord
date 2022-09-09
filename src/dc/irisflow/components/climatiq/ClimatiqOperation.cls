Class dc.irisflow.components.climatiq.ClimatiqOperation Extends (dc.irisflow.components.IrisFlowBusinessOperation, dc.irisflow.interoplib.climatiq.ClimatiqOperation)
{

Property Adapter As dc.irisflow.components.climatiq.ClimatiqOutboundAdapter;

Parameter ADAPTER = "dc.irisflow.components.climatiq.ClimatiqOutboundAdapter";

Method OnConsumeMessage(ByRef pRequest As dc.irisflow.components.GenericMessage, Output pResponse As Ens.Response)
{
    Set response = ..ProcessRequest(pRequest)

	Set message = ##class(dc.irisflow.components.GenericMessage).%New()
	Set message.Stream = ##class(%Stream.GlobalCharacter).%New()
	$$$TOE(st, message.Stream.Write(response.Data.Read()))
	Set message.Context = pRequest.Context.%ToJSON()

    Kill pRequest
    Set pRequest = message
}

Method ProcessRequest(pRequest As dc.irisflow.components.GenericMessage) As %RegisteredObject
{
    Set response = ""
    Set inputMessage = pRequest.Stream.Read()
    $$$TRACE("inputMessage: "_inputMessage)
    
    Set context = ..GetContextAsDynamicObject(pRequest)

    If (context.estimateMsg '= "") {
        Set pRequest.Context = context
        $$$TOE(st, ..Estimate(.pRequest, .response))
    } Else {
        Set message = ##class(%Stream.GlobalCharacter).%New()
        $$$TOE(st, message.Write("Sorry, can't process: "_inputMessage))
        Set response = {
            "Data": (message)
        }
    }
        
    Set pRequest.Context = context
    Return response
}

}
