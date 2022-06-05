Class dc.irisflow.components.email.POP3Service Extends dc.irisflow.components.IrisFlowBusinessService
{

Parameter ADAPTER = "EnsLib.EMail.InboundAdapter";

Method OnCreateMessage(pInput As %Net.MailMessage) As dc.irisflow.components.GenericMessage
{
	Set message = ##class(dc.irisflow.components.GenericMessage).%New()
	Set message.Stream = ##class(%Stream.GlobalCharacter).%New()
    Set emailMessage = ""
    If (pInput.IsMultiPart) {
        Set partsCount = pInput.Parts.Count()
        For i = 1:1:partsCount {
            Set part = pInput.Parts.GetAt(i)
            Set emailMessage = emailMessage_part.TextData.Read()
        }
        #; Set part = input.Parts.GetAt(1)
        #; Set emailMessage = part.TextData.Read()
    } ElseIf (pInput.IsBinary) {
        Throw ##class(%Exception.General).%New("Not implemented")
    } ElseIf (pInput.IsHTML) {
        Throw ##class(%Exception.General).%New("Not implemented")
    } Else {
        Set emailMessage = pInput.TextData.Read()
        #; Set partsCount = input.Parts.Count()
        #; For i = 1:1:partsCount {
        #;     Set part = input.Parts.GetAt(i)
        #;     Set emailMessage = emailMessage_part.TextData.Read()
        #; }
    }
	$$$TOE(st, message.Stream.Write(emailMessage))

	Set message.Context = {
        "From": (pInput.From)
    }.%ToJSON()

	Return message
}

}
