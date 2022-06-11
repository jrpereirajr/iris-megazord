Class dc.irisflow.data.Diagram Extends %Persistent
{

Index IdxName On Name [ Unique ];

Property Name As %String [ Required ];

Property Dashboard As %Stream.GlobalCharacter;

ClassMethod UpdateOrCreateByName(name As %String, dashboard As %DynamicObject) As %Status
{
  Set tSC = $$$OK
	Try {
    Set diagram = ##class(dc.irisflow.data.Diagram).IdxNameOpen(name)
    If ('$IsObject(diagram)) {
      Set diagram = ..%New()
      Set diagram.Name = name
    }
    Do diagram.Dashboard.Clear()
    Do diagram.Dashboard.Write(dashboard.%ToJSON())
    $$$TOE(tSC, diagram.%Save())
	} Catch tException {
		Set:$$$ISOK(tSC) tSC = tException.AsStatus()
	}
	Quit tSC
}

Storage Default
{
<Data name="DiagramDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>Name</Value>
</Value>
<Value name="3">
<Value>Dashboard</Value>
</Value>
</Data>
<DataLocation>^dc.irisflow.data.DiagramD</DataLocation>
<DefaultData>DiagramDefaultData</DefaultData>
<IdLocation>^dc.irisflow.data.DiagramD</IdLocation>
<IndexLocation>^dc.irisflow.data.DiagramI</IndexLocation>
<StreamLocation>^dc.irisflow.data.DiagramS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
