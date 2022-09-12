Class dc.irisflow.interoplib.climatiq.msg.beta3.EstimateFlightLegMsg Extends (Ens.Request, %JSON.Adaptor)
{

Property From As %String(%JSONFIELDNAME = "from");

Property To As %String(%JSONFIELDNAME = "to");

Property Passengers As %Integer(%JSONFIELDNAME = "passengers");

Property Class As %String(%JSONFIELDNAME = "class");

Storage Default
{
<Data name="EstimateFlightMsgDefaultData">
<Subscript>"EstimateFlightMsg"</Subscript>
<Value name="1">
<Value>From</Value>
</Value>
<Value name="2">
<Value>To</Value>
</Value>
<Value name="3">
<Value>Class</Value>
</Value>
<Value name="4">
<Value>Passengers</Value>
</Value>
</Data>
<DefaultData>EstimateFlightMsgDefaultData</DefaultData>
<Type>%Storage.Persistent</Type>
}

}
