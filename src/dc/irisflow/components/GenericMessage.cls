Class dc.irisflow.components.GenericMessage Extends Ens.StreamContainer
{

Property Context As %String(MAXLEN = "");

Storage Default
{
<Data name="GenericMessageDefaultData">
<Subscript>"GenericMessage"</Subscript>
<Value name="1">
<Value>Context</Value>
</Value>
</Data>
<DefaultData>GenericMessageDefaultData</DefaultData>
<Type>%Storage.Persistent</Type>
}

}
