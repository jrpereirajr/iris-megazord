Class dc.irisflow.components.file.FilePassthroughOperation Extends (EnsLib.File.PassthroughOperation, dc.irisflow.components.IrisFlowBusinessOperation)
{

Property InvokeSuperOnMessage As %Boolean [ InitialExpression = 1 ];

Method OnMessage(pRequest As dc.irisflow.components.GenericMessage, Output pResponse As Ens.Response) As %Status
{
    Set st = $$$OK

    If (..InvokeSuperOnMessage) {
        $$$TOE(st, ##super(pRequest, pResponse))
    } Else {
        Do ..OnConsumeMessage(pRequest, pResponse)
    }
    Do ..SendRequestToTargets(pRequest)
    Do ..OnAfterConsumeMessage(pRequest, pResponse)
	
    Return st
}

}
