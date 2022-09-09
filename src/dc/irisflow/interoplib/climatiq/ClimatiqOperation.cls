Class dc.irisflow.interoplib.climatiq.ClimatiqOperation Extends Ens.BusinessOperation
{

Parameter ADAPTER = "dc.irisflow.interoplib.climatiq.ClimatiqOutboundAdapter";

Parameter INVOCATION = "Queue";

Property Adapter As dc.irisflow.interoplib.climatiq.ClimatiqOutboundAdapter;

Method EstimateGeneric(ByRef pRequest As dc.irisflow.interoplib.climatiq.msg.beta3.EstimateMsg, Output pResponse As Ens.Response) As %Status
{
    Set st = $$$OK
    Try {
        $$$TOE(st, ..Adapter.EstimateGeneric(.pRequest, .pResponse))
    }
    Catch(e) {
        Set st = e.AsStatus()
    }
    Return st
}

Method EstimateClothes(ByRef pRequest As dc.irisflow.interoplib.climatiq.msg.beta3.EstimateClothesMsg, Output pResponse As Ens.Response) As %Status
{
    Set st = $$$OK
    Try {
        // converts the message to a generic estimate paylod
        Set estimateMsg = ##class(dc.irisflow.interoplib.climatiq.msg.beta3.EstimateMsg).%New()
        Set estimateMsg.EmissionFactor = {
                "activity_id": "consumer_goods-type_clothing"
            }.%ToJSON()
        Set estimateMsg.Parameters = {
                "money": (pRequest.Money),
                "money_unit": ((pRequest.MoneyUnit))
            }.%ToJSON()

        $$$TOE(st, ..Adapter.EstimateGeneric(.estimateMsg, .pResponse))
    }
    Catch(e) {
        Set st = e.AsStatus()
    }
    Return st
}

Method EstimateFlight(ByRef pRequest As dc.irisflow.interoplib.climatiq.msg.beta3.EstimateFlightLegsMsg, Output pResponse As Ens.Response) As %Status
{
    Set st = $$$OK
    Try {
        $$$TOE(st, ..Adapter.EstimateFlight(.pRequest, .pResponse))
    }
    Catch(e) {
        Set st = e.AsStatus()
    }
    Return st
}

XData MessageMap
{
<MapItems>
    <MapItem MessageType="dc.irisflow.interoplib.climatiq.msg.beta3.EstimateMsg">
        <Method>EstimateGeneric</Method>
    </MapItem>
    <MapItem MessageType="dc.irisflow.interoplib.climatiq.msg.beta3.EstimateClothesMsg">
        <Method>EstimateClothes</Method>
    </MapItem>
    <MapItem MessageType="dc.irisflow.interoplib.climatiq.msg.beta3.EstimateFlightLegsMsg">
        <Method>EstimateFlight</Method>
    </MapItem>
</MapItems>
}

}
