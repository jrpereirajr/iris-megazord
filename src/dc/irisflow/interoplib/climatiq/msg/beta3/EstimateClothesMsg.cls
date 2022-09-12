Class dc.irisflow.interoplib.climatiq.msg.beta3.EstimateClothesMsg Extends (Ens.Request, %JSON.Adaptor)
{

Property Money As %Float(%JSONFIELDNAME = "money");

Property MoneyUnit As %String(%JSONFIELDNAME = "money_unit", MAXLEN = "");

Storage Default
{
<Data name="EstimateClothesMsgDefaultData">
<Subscript>"EstimateClothesMsg"</Subscript>
<Value name="1">
<Value>Money</Value>
</Value>
<Value name="2">
<Value>MoneyUnit</Value>
</Value>
</Data>
<DefaultData>EstimateClothesMsgDefaultData</DefaultData>
<Type>%Storage.Persistent</Type>
}

}
