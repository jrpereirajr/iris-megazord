Class dc.irisflow.interoplib.climatiq.msg.beta3.EstimatePlasticWasteMsg Extends (Ens.Request, %JSON.Adaptor)
{

Property Weight As %Float(%JSONFIELDNAME = "weight");

Property WeightUnit As %String(%JSONFIELDNAME = "weight_unit");

Storage Default
{
<Data name="EstimatePlasticWasteMsgDefaultData">
<Subscript>"EstimatePlasticWasteMsg"</Subscript>
<Value name="1">
<Value>Weight</Value>
</Value>
<Value name="2">
<Value>WeightUnit</Value>
</Value>
</Data>
<DefaultData>EstimatePlasticWasteMsgDefaultData</DefaultData>
<Type>%Storage.Persistent</Type>
}

}
