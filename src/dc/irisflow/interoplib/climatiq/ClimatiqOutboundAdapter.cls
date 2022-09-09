Class dc.irisflow.interoplib.climatiq.ClimatiqOutboundAdapter Extends EnsLib.HTTP.OutboundAdapter
{

Property SSLConfig As %String;

Property ApiVersion As %String [ InitialExpression = "beta3" ];

Property ApiKey As %String;

Property Api As dc.irisflow.interoplib.climatiq.Api;

Parameter SETTINGS = "SSLConfig:Connection:sslConfigSelector,ApiKey,ApiVersion";

Method OnInit() As %Status
{
    Set ..HTTPPort = 443
    Set ..Api = ##class(dc.irisflow.interoplib.climatiq.Api).GetApi(..ApiVersion)
    Set ..Api.ApiKey = ..ApiKey
    Set ..Api.Adapter = $this
	Return $$$OK
}

Method Estimate(ByRef pRequest As dc.irisflow.interoplib.climatiq.EstimateMsg, Output pResponse As Ens.Response) As %Status
{
    Set st = $$$OK
    Try {
        Set estimateMsg = ##class(dc.irisflow.interoplib.climatiq.EstimateMsg).%New()
        Set json = pRequest.Context.estimateMsg
        $$$TOE(st, estimateMsg.%JSONImport(json))
        Set pResponse = ..Api.Estimate(estimateMsg)
    }
    Catch(e) {
        Set st = e.AsStatus()
    }
    Return st
}

}
