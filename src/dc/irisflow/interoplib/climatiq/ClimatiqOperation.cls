Class dc.irisflow.interoplib.climatiq.ClimatiqOperation Extends Ens.BusinessOperation
{

Parameter ADAPTER = "dc.irisflow.interoplib.climatiq.ClimatiqOutboundAdapter";

Parameter INVOCATION = "Queue";

Property Adapter As dc.irisflow.interoplib.climatiq.ClimatiqOutboundAdapter;

Method Estimate(ByRef pRequest As dc.irisflow.interoplib.climatiq.EstimateMsg, Output pResponse As Ens.Response) As %Status
{
    Set st = $$$OK
    Try {
        $$$TOE(st, ..Adapter.Estimate(.pRequest, .pResponse))
    }
    Catch(e) {
        Set st = e.AsStatus()
    }
    Return st
}

XData MessageMap
{
<MapItems>
    <MapItem MessageType="dc.irisflow.interoplib.climatiq.EstimateMsg">
        <Method>Estimate</Method>
    </MapItem>
</MapItems>
}

}
