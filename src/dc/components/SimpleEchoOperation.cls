Class dc.components.SimpleEchoOperation Extends dc.components.IrisFlowBusinessOperation
{

Method OnConsumeMessage(ByRef pRequest As dc.components.GenericMessage, Output pResponse As Ens.Response)
{
    $$$TRACE("OnConsumeMessage")
    Set inputMessage = pRequest.Stream.Read()
    Set context = pRequest.Context

	Set message = ##class(dc.components.GenericMessage).%New()
	Set message.Stream = ##class(%Stream.GlobalCharacter).%New()
	$$$TOE(st, message.Stream.Write("echo: "_inputMessage))
	Set message.Context = context

    Kill pRequest
    Set pRequest = message
}

}
