Class dc.irisflow.interoplib.climatiq.EstimateMsg Extends (Ens.Request, %JSON.Adaptor)
{

Property EmissionFactor As %String(%JSONFIELDNAME = "emission_factor", MAXLEN = "");

Property Parameters As %String(%JSONFIELDNAME = "parameters", MAXLEN = "");

Storage Default
{
<Data name="EstimateMsgDefaultData">
<Subscript>"EstimateMsg"</Subscript>
<Value name="1">
<Value>EmissionFactor</Value>
</Value>
<Value name="2">
<Value>Parameters</Value>
</Value>
</Data>
<DefaultData>EstimateMsgDefaultData</DefaultData>
<Type>%Storage.Persistent</Type>
}

}
