Class dc.irisflow.components.misc.SimpleEchoOperation Extends dc.irisflow.components.IrisFlowBusinessOperation
{

Method OnConsumeMessage(ByRef pRequest As dc.irisflow.components.GenericMessage, Output pResponse As Ens.Response)
{
    $$$TRACE("OnConsumeMessage")
    Set inputMessage = pRequest.Stream.Read()
    
    // todo: create a GetContext() method to do this
    Set context = pRequest.Context
    If ('$IsObject(context)) {
        Set context = {}
    }
    Set context = pRequest.Context

	Set message = ##class(dc.irisflow.components.GenericMessage).%New()
	Set message.Stream = ##class(%Stream.GlobalCharacter).%New()
	$$$TOE(st, message.Stream.Write("echo: "_inputMessage))
	Set message.Context = context

    Kill pRequest
    Set pRequest = message
}

}
