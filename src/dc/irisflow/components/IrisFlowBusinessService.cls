Class dc.irisflow.components.IrisFlowBusinessService Extends (Ens.BusinessService, dc.irisflow.components.TargetedHost)
{

Method OnProcessInput(pInput As %RegisteredObject, pOutput As %RegisteredObject) As %Status
{
    Set message = ..OnCreateMessage(pInput)
	Do:($IsObject(message)) ..SendRequestToTargets(message)
    Do ..OnAfterSendMessage(pInput)
    
    Return $$$OK
}

Method OnCreateMessage(pInput As %RegisteredObject) As dc.irisflow.components.GenericMessage
{
}

Method OnAfterSendMessage(pInput As %RegisteredObject)
{
}

}