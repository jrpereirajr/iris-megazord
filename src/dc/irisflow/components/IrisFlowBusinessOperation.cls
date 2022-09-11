Class dc.irisflow.components.IrisFlowBusinessOperation Extends (Ens.BusinessOperation, dc.irisflow.components.TargetedHost)
{

/// In cases which you'd like the super OnMessage() for the BO is executed, overhide this property with a value of true
Property InvokeSuperOnMessage As %Boolean [ InitialExpression = 0 ];

Property CancelSendRequest As %Boolean [ InitialExpression = 0 ];

Method OnMessage(pRequest As dc.irisflow.components.GenericMessage, Output pResponse As Ens.Response) As %Status
{
    Set st = $$$OK

    If (..InvokeSuperOnMessage) {
        $$$TOE(st, ##super(pRequest, pResponse))
    } Else {
        Do ..OnConsumeMessage(.pRequest, pResponse)
    }
    Do:('..CancelSendRequest) ..SendRequestToTargets(pRequest)
    Do ..OnAfterConsumeMessage(pRequest, pResponse)

    Set ..CancelSendRequest = 0
	
    Return st
}

Method OnConsumeMessage(ByRef pRequest As dc.irisflow.components.GenericMessage, Output pResponse As Ens.Response)
{
}

Method OnAfterConsumeMessage(pRequest As dc.irisflow.components.GenericMessage, Output pResponse As Ens.Response)
{
}

Method GetContextAsDynamicObject(pRequest As dc.irisflow.components.GenericMessage) As %DynamicObject
{
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
    Return context
}

XData MessageMap
{
<MapItems>
    <MapItem MessageType="dc.irisflow.components.GenericMessage">
        <Method>OnMessage</Method>
    </MapItem>
</MapItems>
}

}
