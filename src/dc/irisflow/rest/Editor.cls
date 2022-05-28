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
	// Call parser method
	Quit tSC
}

}
