Class dc.irisflow.components.email.SMTPOperation Extends dc.irisflow.components.IrisFlowBusinessOperation
{

/// 2 modes: Queue, InProc
Parameter INVOCATION = "Queue";

/// Name of the adapter class
Parameter ADAPTER = "EnsLib.EMail.OutboundAdapter";

Method OnConsumeMessage(ByRef pRequest As dc.irisflow.components.GenericMessage, Output pResponse As Ens.Response)
{
    #; $$$TRACE(##class(%ZEN.Auxiliary.altJSONProvider).%ObjectToAET(pRequest.Context).%ToJSON())

    Set inputMessage = pRequest.Stream.Read()
    
    // todo: create a GetContext() method to do this
    Set context = pRequest.Context
    If ('$IsObject(context)) {
        Set context = {}
    }

    Set context.Destination = ""
    Set context.Sender = ""
    Set context.Text = "teste"

	Set pRequest.Context = context

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

}
