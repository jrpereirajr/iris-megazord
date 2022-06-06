Class dc.irisflow.components.httpclient.HttpRequestService Extends dc.irisflow.components.IrisFlowBusinessService
{

Property Adapter As dc.irisflow.components.httpclient.HttpRequestInboundAdapter;

Parameter ADAPTER = "dc.irisflow.components.httpclient.HttpRequestInboundAdapter";

Method OnCreateMessage(pInput As %DynamicAbstractObject) As dc.irisflow.components.GenericMessage
{
    $$$TRACE("HttpRequestService:OnCreateMessage")
	Set message = ##class(dc.irisflow.components.GenericMessage).%New()
	Set message.Stream = ##class(%Stream.GlobalCharacter).%New()
    $$$TOE(st, message.Stream.Write(pInput.%ToJSON()))
	Return message
}

}
