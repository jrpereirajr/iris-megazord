Class dc.irisflow.components.climatiq.ClimatiqOutboundAdapter Extends dc.jrpereirajr.interop.adapter.climatiq.ClimatiqOutboundAdapter
{

Property ApiKeyCred As %String;

Parameter SETTINGS = "ApiKeyCred::credentialsSelector";

Method OnInit() As %Status
{
    Set ..ApiKey = ##class(dc.irisflow.util.Credentials).GetCredentials(..ApiKeyCred)
	Return ##super()
}

}
