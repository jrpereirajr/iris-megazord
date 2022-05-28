Class dc.irisflow.data.Component Extends %Persistent
{

Index IdxName On Name [ Unique ];

Property Name As %String [ Required ];

Property Description As %String;

Property Icon As %String [ Required ];

Property Input As %Integer [ InitialExpression = 0 ];

Property Output As %Integer [ InitialExpression = 0 ];

Property Fields As %Stream.GlobalCharacter;

Storage Default
{
<Data name="ComponentDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>Name</Value>
</Value>
<Value name="3">
<Value>Input</Value>
</Value>
<Value name="4">
<Value>Output</Value>
</Value>
<Value name="5">
<Value>Type</Value>
</Value>
<Value name="6">
<Value>Fields</Value>
</Value>
<Value name="7">
<Value>Icon</Value>
</Value>
<Value name="8">
<Value>Description</Value>
</Value>
</Data>
<DataLocation>^dc.irisflow.data.ComponentD</DataLocation>
<DefaultData>ComponentDefaultData</DefaultData>
<IdLocation>^dc.irisflow.data.ComponentD</IdLocation>
<IndexLocation>^dc.irisflow.data.ComponentI</IndexLocation>
<StreamLocation>^dc.irisflow.data.ComponentS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
