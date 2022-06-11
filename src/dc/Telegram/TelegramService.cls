/*
Author: Nikolay Soloviev
Repo: https://github.com/intersystems-community/TelegramAlerts
*/

Class dc.Telegram.TelegramService Extends Ens.BusinessService
{

Parameter ADAPTER = "dc.Telegram.TelegramInboundAdapter";

Property TableName As %String;

Parameter SETTINGS = "TableName";

Method OnProcessInput(pInput As %RegisteredObject, Output pOutput As %RegisteredObject) As %Status
{
	set msg = ##class(dc.Telegram.Msg.TextRequest).%New()
	if (pInput.message="") {
		return $$$OK // skipping, if update type not equal to "message" 
	}

	$$$TRACE(pInput.message.chat.id)
	
	if (pInput.message.text="/start") {
		set msg.ChatId = pInput.message.chat.id
		set msg.Text = "Hey there! This bot is created to demonstrate how to send notifications from Ensemble. Bot commands: "_$$$NL_
			"/subscribe - subscribe to Alerts"_$$$NL_ 
			"/alert - throw out a test alert (it will be send to ALL subscribers)"
		
	} elseif(pInput.message.text="/subscribe") {
		set msg = ##class(dc.Telegram.Msg.ButtonRequest).%New()
		set msg.ChatId = pInput.message.chat.id
		set msg.Text = "Click on the button below this message to subscribe to alerts"
		set msg.Button = "Subscribe"
	} elseif(pInput.message.text="/alert") {
		set alert = ##class(Ens.AlertRequest).%New()
		set alert.SourceConfigName = ..%ConfigName
		set alert.AlertText = "Test Alert created by: "_pInput.message.from."first_name"_" "_pInput.message.from."last_name"
		do ..SendAlert(alert)
	} elseif (pInput.message.contact."phone_number" '= "") {
		// update with phonenumber - someone clicked the button. Update Lookup table
		set phone = pInput.message.contact."phone_number"
		set phone = $tr(phone,"+")
		set msg.ChatId = pInput.message.chat.id
		if (##class(Ens.Util.LookupTable).%UpdateValue(..TableName,phone, pInput.message.chat.id, 0)) {
			set msg.Text = "You have successfully subscribed to Alerts"
		} else {
			set msg.Text = "Error saving data"
		}
	}
	if (msg.Text'="") {
		return ..SendRequestAsync("dc.Telegram.TelegramOperation",msg)
	}
	return $$$OK
}

}
