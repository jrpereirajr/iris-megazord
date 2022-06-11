Class dc.irisflow.components.IrisFlowBusinessService Extends (Ens.BusinessService, dc.irisflow.components.TargetedHost)
{

Method OnProcessInput(pInput As %RegisteredObject, pOutput As %RegisteredObject) As %Status
{
    Set message = ..OnCreateMessage(pInput)
	Do:($IsObject(message)) ..SendRequestToTargets(message)
    Do ..OnAfterSendMessage(pInput)
    
    Return $$$OK
}

Method OnCreateMessage(pInput As %SystemBase) As dc.irisflow.components.GenericMessage
{
    Return ##class(dc.irisflow.components.GenericMessage).%New()
}

Method OnAfterSendMessage(pInput As %SystemBase)
{
}

}
