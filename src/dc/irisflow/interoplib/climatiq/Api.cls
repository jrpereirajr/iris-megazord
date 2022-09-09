Class dc.irisflow.interoplib.climatiq.Api Extends %RegisteredObject
{

Property ApiKey As %String;

Property Adapter As dc.irisflow.interoplib.climatiq.ClimatiqOutboundAdapter;

ClassMethod GetApi(pApiVersion As %String) As dc.irisflow.interoplib.climatiq.Api
{
    If (pApiVersion = "beta3") {
        Return ##class(dc.irisflow.interoplib.climatiq.ApiBeta3).%New()
    } Else {
        Throw ##class(%Exception.General).%New("API version not supported: "_pApiVersion)
    }
}

Method GetServer() As %String [ Abstract ]
{
}

Method CreateRequest() As %Net.HttpRequest [ Abstract ]
{
}

}
