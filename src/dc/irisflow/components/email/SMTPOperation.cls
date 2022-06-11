Class dc.irisflow.components.email.SMTPOperation Extends dc.irisflow.components.IrisFlowBusinessOperation
{

/// 2 modes: Queue, InProc
Parameter INVOCATION = "Queue";

/// Name of the adapter class
Parameter ADAPTER = "EnsLib.EMail.OutboundAdapter";

Method OnConsumeMessage(ByRef pRequest As dc.irisflow.components.GenericMessage, Output pResponse As Ens.Response)
{
    Set inputMessage = pRequest.Stream.Read()
    
    // todo: create a GetContext() method to do this
    Set context = pRequest.Context
    Try {
        If (context '= "") {
            Set context = {}.%FromJSON(context)
        }
    } Catch(e) {
        $$$TRACE(e.DisplayString())
    }
    If ('$IsObject(context)) {
        Set context = {}
    }

    Set context.Sender = ..Adapter.%CredentialsObj.Username
    If (context.Destination = "") {
        Set context.Destination = context.Sender
    }
    If (context.Subject = "") {
        Set context.Subject = "(no subject)"
    }

	Set pRequest.Context = context
    Set context.Text = inputMessage

	If (pRequest.Context.Destination = "") {
        $$$TRACE("no email address.")
        Quit
    }
	Set tMailMessage = ##class(%Net.MailMessage).%New()
	Do tMailMessage.To.Insert(pRequest.Context.Destination)
	Set tMailMessage.From = pRequest.Context.Sender
	Set tMailMessage.Subject = pRequest.Context.Subject
	set tMailMessage.Charset = "UTF-8"
	$$$TOE(st, tMailMessage.TextData.Write(context.Text))
	$$$TOE(st, ..Adapter.SendMail(tMailMessage))
}

}
