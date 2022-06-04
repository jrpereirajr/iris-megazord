Class dc.irisflow.rest.Dispatch Extends %CSP.REST
{

XData UrlMap [ XMLNamespace = "http://www.intersystems.com/urlmap" ]
{
<Routes>

<Route Url="/" Method="GET" Call="Test" Cors="true"/>
<Route Url="/components" Method="GET" Call="dc.irisflow.rest.Editor:ListAllComponents" Cors="true"/>
<Route Url="/generate" Method="POST" Call="dc.irisflow.rest.Editor:GenerateProduction" Cors="true"/>
<Route Url="/message/:id" Method="GET" Call="dc.irismessageviewer.REST.Messages:getUnlimitedMessages" Cors="true"/>
<Route Url="/message/resend/" Method="POST" Call="dc.irismessageviewer.REST.Messages:ResendMessage" Cors="true"/>
<Route Url="/diagram" Method="POST" Call="dc.irismessageviewer.REST.Diagram:GetDiagram" Cors="true"/>
<Route Url="/diagram/message" Method="POST" Call="dc.irismessageviewer.REST.Diagram:GetMessageInfo" Cors="true"/>
<Route Url="/diagram/prev" Method="POST" Call="dc.irismessageviewer.REST.Diagram:GetPrevSession" Cors="true"/>
<Route Url="/diagram/next" Method="POST" Call="dc.irismessageviewer.REST.Diagram:GetNextSession" Cors="true"/>
<Route Url="/package" Method="GET" Call="dc.zpm.Utils:GetPackages" Cors="true"/>
<Route Url="/package" Method="POST" Call="dc.zpm.Utils:InstallPackage" Cors="true"/>
<Route Url="/package/delete" Method="POST" Call="UninstallSelectedPackages" Cors="true"/>
<Route Url="/installed" Method="GET" Call="dc.zpm.Utils:GetInstalledPackageAllNamespaces" Cors="true"/>
<Route Url="/namespace" Method="GET" Call="dc.zpm.Utils:getNamespaceList" Cors="true"/>
<Route Url="/export" Method="POST" Call="ExportDependencies" Cors="true"/>
<Route Url="/wordcloud" Method="GET" Call="dc.zpm.Charts:BuildWordCloudDatasource" Cors="true"/>
<Route Url="/sankey" Method="GET" Call="dc.zpm.Charts:BuildSankeyDataSource" Cors="true"/>

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

/// Description
ClassMethod ExportDependencies() As %Status
{
	Set sc = $$$OK
	Set obj = ##class(%DynamicAbstractObject).%FromJSON(%request.Content.Read())
	Set sc = ##class(dc.zpm.Utils).ExportDependecies(obj.dependencies)
	Return sc
}

/// Delete the packages selected in Installed Packages page
ClassMethod UninstallSelectedPackages() As %Status
{
	Set sc = $$$OK
	Set obj = ##class(%DynamicAbstractObject).%FromJSON(%request.Content.Read())
	Set sc = ##class(dc.zpm.Utils).UninstallPackage(obj.packages)
	Return sc
}

}
