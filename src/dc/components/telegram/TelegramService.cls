Class dc.components.telegram.TelegramService Extends dc.components.IrisFlowBusinessService
{

Parameter ADAPTER = "Telegram.TelegramInboundAdapter";

Method OnCreateMessage(pInput As %RegisteredObject) As dc.components.GenericMessage
{
	$$$TRACE(##class(%ZEN.Auxiliary.altJSONProvider).%ObjectToAET(pInput).%ToJSON())
	if (pInput.message = "") {
		return "" // skipping, if update type not equal to "message" 
	}

	Set message = ##class(dc.components.GenericMessage).%New()
	Set message.Stream = ##class(%Stream.GlobalCharacter).%New()
	$$$TOE(st, message.Stream.Write(pInput.message.text))
	Set message.Context = {
		"ChatId": (pInput.message.chat.id)
	}.%ToJSON()
	Return message
}

}
