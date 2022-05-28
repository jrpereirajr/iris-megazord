Class dc.irisflow.components.email.POP3Service Extends dc.irisflow.components.IrisFlowBusinessService
{

Parameter ADAPTER = "EnsLib.EMail.InboundAdapter";

Method OnCreateMessage(pInput As %RegisteredObject) As dc.irisflow.components.GenericMessage
{
    #Dim input As %Net.MailMessage = pInput

	Set message = ##class(dc.irisflow.components.GenericMessage).%New()
	Set message.Stream = ##class(%Stream.GlobalCharacter).%New()
    Set emailMessage = ""
    If (input.IsMultiPart) {
        Set partsCount = input.Parts.Count()
        For i = 1:1:partsCount {
            Set part = input.Parts.GetAt(i)
            Set emailMessage = emailMessage_part.TextData.Read()
        }
        #; Set part = input.Parts.GetAt(1)
        #; Set emailMessage = part.TextData.Read()
    } ElseIf (input.IsBinary) {
        Throw ##class(%Exception.General).%New("Not implemented")
    } ElseIf (input.IsHTML) {
        Throw ##class(%Exception.General).%New("Not implemented")
    } Else {
        Set emailMessage = input.TextData.Read()
        #; Set partsCount = input.Parts.Count()
        #; For i = 1:1:partsCount {
        #;     Set part = input.Parts.GetAt(i)
        #;     Set emailMessage = emailMessage_part.TextData.Read()
        #; }
    }
	$$$TOE(st, message.Stream.Write(emailMessage))

	Set message.Context = {
        "dc.irisflow.components.email.POP3Service": {
            "From": (input.From)
        }
    }.%ToJSON()

	Return message
}

}
