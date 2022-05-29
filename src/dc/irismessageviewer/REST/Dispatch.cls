Class dc.irismessageviewer.REST.Dispatch Extends %CSP.REST
{

XData UrlMap [ XMLNamespace = "http://www.intersystems.com/urlmap" ]
{
<Routes>

<Route Url="/" Method="GET" Call="Test" Cors="true"/>
<Route Url="/message/:id" Method="GET" Call="dc.irismessageviewer.REST.Messages:getUnlimitedMessages" Cors="true"/>
<Route Url="/message/resend/" Method="POST" Call="dc.irismessageviewer.REST.Messages:ResendMessage" Cors="true"/>
<Route Url="/diagram" Method="POST" Call="dc.irismessageviewer.REST.Diagram:GetDiagram" Cors="true"/>
<Route Url="/diagram/message" Method="POST" Call="dc.irismessageviewer.REST.Diagram:GetMessageInfo" Cors="true"/>
<Route Url="/diagram/prev" Method="POST" Call="dc.irismessageviewer.REST.Diagram:GetPrevSession" Cors="true"/>
<Route Url="/diagram/next" Method="POST" Call="dc.irismessageviewer.REST.Diagram:GetNextSession" Cors="true"/>

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
