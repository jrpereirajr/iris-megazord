Class dc.irisflow.components.telegram.TelegramOperation Extends dc.irisflow.components.IrisFlowBusinessOperation
{

Parameter ADAPTER = "dc.irisflow.components.telegram.TelegramOutboundAdapter";

Parameter INVOCATION = "Queue";

Property Adapter As dc.irisflow.components.telegram.TelegramOutboundAdapter;

/// Id for Telegram user who message will sent for, when no one ChatId field is found in the input message
Property ChatId As %String;

Parameter SETTINGS = "ChatId::credentialsSelector";

Method OnConsumeMessage(ByRef pRequest As dc.irisflow.components.GenericMessage, Output pResponse As Ens.Response)
{
    Set inputMessage = pRequest.Stream.Read()
    
    // todo: create a GetContext() method to do this
    Set context = pRequest.Context
    Try {
        If (context '= "") {
            Set context = {}.%FromJSON(context)
        }
    } Catch(e) {
        $$$TRACE(e.DisplayString())
    }
    If ('$IsObject(context)) {
        Set context = {}
    }

	Set pRequest.Context = context.%ToJSON()
    
    Set message = ##class(appmsw.telestat.Msg.TextRequest).%New()
    Set message.Text = inputMessage
    
    If ($IsObject(context)) && (context.ChatId '= "") {
        $$$TRACE("Using ChatId from message")
        Set message.ChatId = context.ChatId
    } Else {
        $$$TRACE("Using ChatId from configurations")
        $$$TOE(st, ##class(Ens.Config.Credentials).GetCredentialsObj(.credObj, "", "Ens.Config.Credentials", ..ChatId))
        Set message.ChatId = credObj.Password
    }

    Do ..SendMessage(message, .pResponse)
}

Method SendMessage(pInput As appmsw.telestat.Msg.TextRequest, Output pOutput As Ens.Response) As %Status
{
	Quit ..Adapter.SendMessage(pInput.ChatId,pInput.Text,1)
}

Method SendButton(pInput As appmsw.telestat.Msg.ButtonRequest, Output pOutput As Ens.Response) As %Status
{
	Quit ..Adapter.SendButton(pInput.ChatId,pInput.Text,pInput.Button,1)
}

}
