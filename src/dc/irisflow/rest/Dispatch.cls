Class dc.irisflow.rest.Dispatch Extends %CSP.REST
{

XData UrlMap [ XMLNamespace = "http://www.intersystems.com/urlmap" ]
{
<Routes>

<Route Url="/" Method="GET" Call="Test" Cors="true"/>
<Route Url="/components" Method="GET" Call="dc.irisflow.rest.Editor:ListAllComponents" Cors="true"/>
<Route Url="/production/:productionName" Method="GET" Call="dc.irisflow.rest.Editor:GetProduction" Cors="true"/>
<Route Url="/generate" Method="POST" Call="dc.irisflow.rest.Editor:GenerateProduction" Cors="true"/>

</Routes>
}

ClassMethod Test() As %Status
{
	Set %response.ContentType = "application/json"
	Set retObj = { }
	Set retMessage = "Hello World!"
	Set retObj.Message = retMessage
	Write retObj.%ToJSON()
	Quit $$$OK
}

}
