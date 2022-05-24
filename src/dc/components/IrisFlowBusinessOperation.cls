Class dc.components.IrisFlowBusinessOperation Extends (Ens.BusinessOperation, dc.components.TargetedHost)
{

/// In cases which you'd like the super OnMessage() for the BO is executed, overhide this property with a value of true
Property InvokeSuperOnMessage As %Boolean [ InitialExpression = 0 ];

Method OnMessage(pRequest As dc.components.GenericMessage, Output pResponse As Ens.Response) As %Status
{
    Set st = $$$OK

    If (..InvokeSuperOnMessage) {
        $$$TOE(st, ##super(pRequest, pResponse))
    } Else {
        Do ..OnConsumeMessage(.pRequest, pResponse)
    }
    Do ..SendRequestToTargets(pRequest)
    Do ..OnAfterConsumeMessage(pRequest, pResponse)
	
    Return st
}

Method OnConsumeMessage(ByRef pRequest As dc.components.GenericMessage, Output pResponse As Ens.Response)
{
}

Method OnAfterConsumeMessage(pRequest As dc.components.GenericMessage, Output pResponse As Ens.Response)
{
}

XData MessageMap
{
<MapItems>
    <MapItem MessageType="dc.components.GenericMessage">
        <Method>OnMessage</Method>
    </MapItem>
</MapItems>
}

}
