/*
Author: Nikolay Soloviev
Repo: https://github.com/intersystems-community/TelegramAlerts
*/

Class Telegram.TelegramOutboundAdapter Extends Ens.OutboundAdapter
{

Property SSLConfiguration As %String;

Property API As Telegram.API [ Private ];

Parameter SETTINGS = "Credentials:Basic:credentialsSelector,SSLConfiguration";

Method OnInit() As %Status
{
	set ..API = ##class(Telegram.API).%New(..%CredentialsObj.Password, ..SSLConfiguration)
	if '$isobject(..API) {
		return 0
	}
	return $$$OK
}

Method SendMessage(chatId As %String, text As %String, removeKeyboard As %Boolean = 0) As %Integer
{
	if (removeKeyboard) {
		set obj = {"remove_keyboard":true}
		set res = ..API.SendMessage(chatId,text,,,,,obj)
	} else {
		set res = ..API.SendMessage(chatId,text)
	}
	
	if (res.ok) {
		return res.result."message_id"
	}
	return $$$ERROR($$$GeneralError, "Error while sending a message")
}

Method SendButton(chatId As %String, text As %String, buttonText As %String = "", getPhone As %Boolean = 0) As %Status
{
	set button = {}
	if (getPhone=1) {
		do button.%Set("request_contact",1,"boolean") 
	} 
	set button.text = buttonText
	
	set buttons = []
	do buttons.%Push(button)
	
	set obj = {"one_time_keyboard":true,"resize_keyboard":true}
	set obj.keyboard = []
	do obj.keyboard.%Push(buttons)
	set res = ..API.SendMessage(chatId,text,,,,,obj)
	
	if (res.ok) {
		return res.result."message_id"
	}
	return $$$ERROR($$$GeneralError, "Error while sending a button")
}

}
