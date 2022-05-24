Class dc.irisflow.components.telegram.TelegramOperation Extends dc.irisflow.components.IrisFlowBusinessOperation
{

Parameter ADAPTER = "Telegram.TelegramOutboundAdapter";

Parameter INVOCATION = "Queue";

Property Adapter As Telegram.TelegramOutboundAdapter;

/// todo: use a credential to get this value instead of directly from host configuration
/// Id for Telegram user who message will sent for, when no one ChatId field is found in the input message
Property ChatId As %String;

Parameter SETTINGS = "ChatId";

Method OnConsumeMessage(ByRef pRequest As dc.irisflow.components.GenericMessage, Output pResponse As Ens.Response)
{
    Set inputMessage = pRequest.Stream.Read()
    Set context = pRequest.Context

    Try {
        If (context '= "") {
            Set context = {}.%FromJSON(pRequest.Context)
        }
    } Catch(e) {
        $$$TRACE(e.DisplayString())
    }
    
    Set message = ##class(Telegram.Msg.TextRequest).%New()
    Set message.Text = inputMessage
    
    If ($IsObject(context)) && (context.ChatId '= "") {
        $$$TRACE("Using ChatId from message")
        Set message.ChatId = context.ChatId
    } Else {
        $$$TRACE("Using ChatId from configurations")
        Set message.ChatId = ..ChatId
    }

    Do ..SendMessage(message, .pResponse)
}

Method SendMessage(pInput As Telegram.Msg.TextRequest, Output pOutput As Ens.Response) As %Status
{
    $$$TRACE(pInput.ChatId)
    $$$TRACE(pInput.Text)
	Quit ..Adapter.SendMessage(pInput.ChatId,pInput.Text,1)
}

Method SendButton(pInput As Telegram.Msg.ButtonRequest, Output pOutput As Ens.Response) As %Status
{
	Quit ..Adapter.SendButton(pInput.ChatId,pInput.Text,pInput.Button,1)
}

}
