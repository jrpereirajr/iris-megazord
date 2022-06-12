Class dc.irisflow.components.telegram.TelegramService Extends dc.irisflow.components.IrisFlowBusinessService
{

Parameter ADAPTER = "dc.irisflow.components.telegram.TelegramInboundAdapter";

Method OnCreateMessage(pInput As %RegisteredObject) As dc.irisflow.components.GenericMessage
{
	$$$TRACE("TelegramService:OnCreateMessage")
	if (pInput.message = "") {
		return "" // skipping, if update type not equal to "message" 
	}

	Set message = ##class(dc.irisflow.components.GenericMessage).%New()

	Set message.Stream = ##class(%Stream.GlobalCharacter).%New()
	$$$TOE(st, message.Stream.Write(pInput.message.text))

	Set message.Context = {
		"ChatId": (pInput.message.chat.id)
	}.%ToJSON()

	Return message
}

}
