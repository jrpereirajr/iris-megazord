Class dc.irisflow.rest.Editor
{

Query select() As %SQLQuery
{
  SELECT
    ID, Icon, "Input", Name, Description, "Output"
  FROM dc_irisflow_data.Component
  ORDER BY ID DESC
}

ClassMethod ListAllComponents() As %Status
{
  Set %response.ContentType = "application/json"
	Set tSC = $System.Status.OK()
	Set arrayMessage = []
	Set jsonTop= {}

	Try {
		#Dim result As %SQL.ISelectResult
		Set result = ..selectFunc()

		#Dim metadata As %SQL.StatementMetadata
		Set metadata = result.%GetMetadata()
		Set intcolumnCount = metadata.columnCount
		Set columns = ""
		For i=1:1:intcolumnCount {
			Set columns = columns _ $lb($zcvt(metadata.columns.GetAt(i).colName, "l"))
		}
		Kill metadata

		If (result.%SQLCODE '< 0) {
			While result.%Next() {
				Set json = { }
				For i=1:1:intcolumnCount {
					Do json.%Set($lg(columns, i), result.%GetData(i))
				}
        Set obj = ##class(dc.irisflow.data.Component).%OpenId(result.%GetData(1))
        Set json.Fields = obj.Fields.Read()
				Do arrayMessage.%Push(json)
			}
		}
		Else {
			Throw ##class(%Exception.SQL).CreateFromSQLCODE(result.%SQLCODE, result.%Message)
		}
	}
	Catch (oException) {
		Set tSC = oException.AsStatus()
	}

	do jsonTop.%Set("data",arrayMessage)
	Write jsonTop.%ToJSON()

	Quit tSC
}

ClassMethod GenerateProduction() As %Status
{
	Set tSC = $System.Status.OK()
	Try {
		Set %response.Status = 200
		Set resp = {}

		Set data = %request.Content
		Set payload = data.Read()
		Set flow = {}.%FromJSON(payload)

		Set mapper = ##class(dc.irisflow.FlowMapper).%New()
		Set production = mapper.Map(flow)
		If (mapper.errors.%Size() > 0) {
			Set %response.Status = 500
			Set resp.errors = mapper.errors
			Write resp.%ToJSON()
			Quit
		}
		
		Set builder = ##class(dc.irisflow.ProductionBuilder).%New()
		Do builder.Build(production)
		If (builder.errors.%Size() > 0) {
			Set %response.Status = 500
			Set resp.errors = builder.errors
			Write resp.%ToJSON()
			Quit
		}

		Write resp.%ToJSON()
	} Catch tException {
		Set tSC = tException.AsStatus()
	}
	Quit tSC
}

ClassMethod SaveDiagram() As %Status
{
	Set tSC = $$$OK
	Try {
		Set %response.ContentType = "application/json"
		Set data = %request.Content
		Set payload = data.Read()
		Set payload = {}.%FromJSON(payload)
		Set diagramName = payload.name
		Set diagramDef = payload.def
		$$$TOE(st, ##class(dc.irisflow.data.Diagram).UpdateOrCreateByName(diagramName, diagramDef))
		Set %response.Status = 200
	} Catch tException {
		Set:$$$ISOK(tSC) tSC = tException.AsStatus()
	}
	Quit tSC
}

ClassMethod GetDiagram(diagramName As %String) As %Status
{
	Set tSC = $$$OK
	Try {
		Set %response.ContentType = "application/json"
		Set production = ##class(dc.irisflow.data.Diagram).IdxNameOpen(diagramName)
		Set %response.Status = 200
		If ('$Iso(production)) {
			Throw ##class(%Exception.General).%New("Flow not found.")
		}
		Write production.Dashboard.Read()
	} Catch tException {
		Set:$$$ISOK(tSC) tSC = tException.AsStatus()
	}
	Quit tSC
}

}
