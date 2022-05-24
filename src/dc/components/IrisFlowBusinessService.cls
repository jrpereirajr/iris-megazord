Class dc.components.IrisFlowBusinessService Extends (Ens.BusinessService, dc.components.TargetedHost)
{

Method OnProcessInput(pInput As %RegisteredObject, pOutput As %RegisteredObject) As %Status
{
    Set message = ..OnCreateMessage(pInput)
	Do:($IsObject(message)) ..SendRequestToTargets(message)
    Do ..OnAfterSendMessage(pInput)
    
    Return $$$OK
}

Method OnCreateMessage(pInput As %RegisteredObject) As dc.components.GenericMessage
{
}

Method OnAfterSendMessage(pInput As %RegisteredObject)
{
}

}
