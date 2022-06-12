Class dc.irisflow.components.telegram.TelegramInboundAdapter Extends appmsw.telestat.TelegramInboundAdapter
{

Parameter SETTINGS = "Credentials:Basic:credentialsSelector,SSLConfiguration";

Method OnInit() As %Status
{
	set ..API = ##class(appmsw.telestat.API).%New(..%CredentialsObj.Password, ..SSLConfiguration)
	if '$isobject(..API) {
		return $$$ERROR($$$GeneralError,"API object doesn't created, check Bot token and SSL configuration")
	}
	set ..Updates = []
	return $$$OK
}

}
