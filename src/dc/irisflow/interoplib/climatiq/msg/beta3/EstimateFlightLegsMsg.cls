Class dc.irisflow.interoplib.climatiq.msg.beta3.EstimateFlightLegsMsg Extends (Ens.Request, %JSON.Adaptor)
{

Property legs As list Of dc.irisflow.interoplib.climatiq.msg.beta3.EstimateFlightLegMsg(%JSONFIELDNAME = "legs");

Storage Default
{
<Data name="EstimateFlightLegsMsgDefaultData">
<Subscript>"EstimateFlightLegsMsg"</Subscript>
<Value name="1">
<Value>legs</Value>
</Value>
</Data>
<DefaultData>EstimateFlightLegsMsgDefaultData</DefaultData>
<Type>%Storage.Persistent</Type>
}

}
