Class dc.irisflow.interoplib.climatiq.msg.beta3.EstimateWaterTreatmentMsg Extends (Ens.Request, %JSON.Adaptor)
{

Property Volume As %Float(%JSONFIELDNAME = "volume");

Property VolumeUnit As %String(%JSONFIELDNAME = "volume_unit");

Storage Default
{
<Data name="EstimateWaterTreatmentMsgDefaultData">
<Subscript>"EstimateWaterTreatmentMsg"</Subscript>
<Value name="1">
<Value>Volume</Value>
</Value>
<Value name="2">
<Value>VolumeUnit</Value>
</Value>
</Data>
<DefaultData>EstimateWaterTreatmentMsgDefaultData</DefaultData>
<Type>%Storage.Persistent</Type>
}

}
