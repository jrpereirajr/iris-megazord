/*
Author: Nikolay Soloviev
Repo: https://github.com/intersystems-community/TelegramAlerts
*/

/// ^dc.Telegram.ProcessedUpdateId
Class dc.Telegram.TelegramInboundAdapter Extends Ens.InboundAdapter
{

Property SSLConfiguration As %String;

Property API As dc.Telegram.API [ Private ];

Property Updates As %DynamicArray [ Private ];

Parameter SETTINGS = "Credentials:Basic:credentialsSelector,SSLConfiguration";

Method OnInit() As %Status
{
	set ..API = ##class(dc.Telegram.API).%New(..%CredentialsObj.Password, ..SSLConfiguration)
	if '$isobject(..API) {
		return $$$ERROR($$$GeneralError,"API object doesn't created, check Bot token and SSL configuration")
	}
	set ..Updates = []
	return $$$OK
}

Method ProcessUpdates(pOutput)
{
	set updateObj = ..Updates.%Get(0) 
	return:(updateObj="") $$$OK
	
	$$$TRACE("TelegramInboundAdapter:ProcessUpdates")
	set st = ..BusinessHost.ProcessInput(updateObj,.pOutput)
	if ($$$ISOK(st)) {
		set ^dc.Telegram.ProcessedUpdateId = updateObj."update_id"
		do ..Updates.%Remove(0)
	}
	return st
}

Method OnTask() As %Status
{
	try {
		set updateObj = ..Updates.%Get(0) 
		if (updateObj="") {
			set res = ..API.GetUpdates(1+$Get(^dc.Telegram.ProcessedUpdateId))
			if (res.ok) {
				set ..Updates = res.result
			} else {
				return $$$ERROR($$$GeneralError,"No data received from API, check Bot token")
			}
		}
		
		set st = ..ProcessUpdates(.pOutput)
	} catch e {
		return e.AsStatus()
	}
		
	return st
}

}
