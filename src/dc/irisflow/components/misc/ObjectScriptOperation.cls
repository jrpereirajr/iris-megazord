Class dc.irisflow.components.misc.ObjectScriptOperation Extends dc.irisflow.components.IrisFlowBusinessOperation
{

Property Expression As %String(MAXLEN = "");

Property ContextExpression As %String(MAXLEN = "");

Parameter SETTINGS = "Expression,ContextExpression";

Method OnConsumeMessage(ByRef pRequest As dc.irisflow.components.GenericMessage)
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

	Set message = ##class(dc.irisflow.components.GenericMessage).%New()
    
	Set message.Stream = ##class(%Stream.GlobalCharacter).%New()
    Set cmd = $$$FormatText("(input) %1", ..FormatExpression(..Expression))
    Set result = $Xecute(cmd, inputMessage)
	$$$TOE(st, message.Stream.Write(result))
    
    Set cmd = $$$FormatText("(input, context) %1", ..FormatExpression(..ContextExpression))
    Set context = $Xecute(cmd, inputMessage, context)
	Set message.Context = context.%ToJSON()
    
    Kill pRequest
    Set pRequest = message
}

Method FormatExpression(expression As %String) As %String
{
    Set expression = $Replace(expression, $C(13, 10), " ")
    Set expression = $Replace(expression, $C(10), " ")
    Return expression
}

}
