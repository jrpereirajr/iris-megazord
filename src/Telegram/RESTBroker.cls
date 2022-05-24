/*
Author: Nikolay Soloviev
Repo: https://github.com/intersystems-community/TelegramAlerts
*/

Class Telegram.RESTBroker Extends %CSP.REST
{

XData UrlMap
{
<Routes>
	<Route Url="/update" Method="POST" Call="ProcessUpdate" />
</Routes>
}

ClassMethod ProcessUpdate() As %Status
{
	set obj = ##class(%DynamicAbstractObject).%FromJSON(%request.Content)
	
	//set ^t($h) = obj.%ToJSON() // log all updates 
	
	Set tSC=$$$OK
	do {
		Set tSC=##class(Ens.Director).CreateBusinessService("Telegram.TelegramService",.tService)
		If ($$$ISERR(tSC)) Quit
		Set tSC=tService.ProcessInput(obj,.output)
		If ($$$ISERR(tSC)) Quit
	} while (0)
	If ($$$ISERR(tSC)) {
		// Error: assume system is not running
	}	
	return $$$OK
}

}
