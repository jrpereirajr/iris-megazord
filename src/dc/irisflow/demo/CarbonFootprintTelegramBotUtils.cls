Class dc.irisflow.demo.CarbonFootprintTelegramBotUtils Extends %RegisteredObject
{

ClassMethod ProcessValidInput(input)
{
    Do ##class(Ens.Util.Trace).WriteTrace("user", $classname(), "", "input: "_input)
    Set response = ""
    If (input '= "clothes") {
        Quit ##class(dc.irisflow.components.misc.ObjectScriptOperation).#CancelSendRequest
    }
    Return response
}

ClassMethod ProcessValidContext(input, context)
{
    Do ##class(Ens.Util.Trace).WriteTrace("user", $classname(), "", "input: "_input)
    Do ##class(Ens.Util.Trace).WriteTrace("user", $classname(), "", "context: "_context.%ToJSON())
    If (input = "clothes") {
        Set estimateMsg = ##class(dc.irisflow.interoplib.climatiq.EstimateMsg).%New()
        Set estimateMsg.EmissionFactor = {
                "activity_id": "consumer_goods-type_clothing"
            }.%ToJSON()
        Set estimateMsg.Parameters = {
                "money": 120,
                "money_unit": "usd"
            }.%ToJSON()
        Set st = estimateMsg.%JSONExportToString(.json)
        Throw:(st '= 1) ##class(%Exception.StatusException).CreateFromStatus(st)
        Set context.estimateMsg = json
    }
    Return context
}

ClassMethod ProcessInvalidInput(input)
{
    Do ##class(Ens.Util.Trace).WriteTrace("user", $classname(), "", "input: "_input)
    Set response = ""
    If (input '= "clothes") {
        Set response = "Sorry, can't process you request: "_input
    } Else {
        Quit ##class(dc.irisflow.components.misc.ObjectScriptOperation).#CancelSendRequest
    }
    Return response
}

ClassMethod ProcessInvalidContext(input, context)
{
    Return context
}

ClassMethod ProcessClimatiqResponse(input)
{
    Set response = ""
    Try {
        Set input = {}.%FromJSON(input)
        Set response = "Total emissions of CO2: "_input.co2e_input."co2e_unit"
    } Catch(e) {
        Set response = input
    }
    Quit response
}

ClassMethod ProcessClimatiqResponseContext(input, context)
{
    Quit context
}

}
