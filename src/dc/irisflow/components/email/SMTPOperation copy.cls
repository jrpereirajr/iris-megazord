Class dc.irisflow.components.email.SMTPOperation copy
{

/// 2 modes: Queue, InProc
Parameter INVOCATION = "Queue";

/// Name of the adapter class
Parameter ADAPTER = "EnsLib.EMail.OutboundAdapter";

XData MessageMap
{
<MapItem MessageType="dc.irisflow.components.GenericMessage">
<Method>EMailSendReply</Method>
</MapItem>
}

Method EMailSendReply(pRequest As dc.irisflow.components.GenericMessage, Output pResponse As Ens.Response) As %Status
{
    Set pRequest.Context = {
        "Destination": "ze_sjrp@yahoo.com.br",
        "Sender": "ze_sjrp@yahoo.com.br",
        "Text": "teste"
    }
	If pRequest.Context.Destination = "" $$$TRACE("no email address.") Quit $$$OK
	$$$TRACE("send email to "_pRequest.Context.Destination)
	$$$TRACE("Destination "_pRequest.Context.Destination)
	$$$TRACE("Sender "_pRequest.Context.Sender)
	$$$TRACE("Text "_pRequest.Context.Text)
	Set tMailMessage = ##class(%Net.MailMessage).%New()
	Do tMailMessage.To.Insert(pRequest.Context.Destination)
	Set tMailMessage.From = pRequest.Context.Sender
	Set tMailMessage.Subject = "RE: "_pRequest.Context.Text
	set tMailMessage.Charset = "UTF-8"
	Set tSC = tMailMessage.TextData.Write("Sent by IMAP Inbound Adapter Example.") 
    Quit:$$$ISERR(tSC) tSC
	Set tSC = ..Adapter.SendMail(tMailMessage)
	Quit tSC
}

/*
Method OnConsumeMessage(ByRef pRequest As dc.irisflow.components.GenericMessage, Output pResponse As Ens.Response)
{
    Set pRequest.Context = {
        "Destination": "ze_sjrp@yahoo.com.br",
        "Sender": "ze_sjrp@yahoo.com.br",
        "Text": "teste"
    }

	If (pRequest.Context.Destination = "") {
        $$$TRACE("no email address.")
        Quit
    }
	$$$TRACE("send email to "_pRequest.Context.Destination)
	Set tMailMessage = ##class(%Net.MailMessage).%New()
	Do tMailMessage.To.Insert(pRequest.Context.Destination)
	Set tMailMessage.From = pRequest.Context.Sender
	Set tMailMessage.Subject = "RE: "_pRequest.Context.Text
	set tMailMessage.Charset = "UTF-8"
	$$$TOE(st, tMailMessage.TextData.Write("Sent by IMAP Inbound Adapter Example."))
	$$$TOE(st, ..Adapter.SendMail(tMailMessage))
}
*/
}
