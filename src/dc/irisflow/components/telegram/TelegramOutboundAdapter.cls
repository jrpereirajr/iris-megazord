Class dc.irisflow.components.telegram.TelegramOutboundAdapter Extends appmsw.telestat.TelegramOutboundAdapter
{

Parameter SETTINGS = "Credentials:Basic:credentialsSelector,SSLConfiguration";

Method OnInit() As %Status
{
	set ..API = ##class(appmsw.telestat.API).%New(..%CredentialsObj.Password, ..SSLConfiguration)
	if '$isobject(..API) {
		return 0
	}
	return $$$OK
}

}
