Class dc.irisflow.demo.CarbonFootprintTelegramBotUtils Extends %RegisteredObject
{

Parameter ValidInputs = {$LFS("clothes,flight,water treatment,plastic")};

ClassMethod ProcessValidInput(input)
{
    Do ##class(Ens.Util.Trace).WriteTrace("user", $classname(), "", "input: "_input)
    Set response = ""
    If ($LF(..#ValidInputs, input) = 0) {
        Quit ##class(dc.irisflow.components.misc.ObjectScriptOperation).#CancelSendRequest
    }
    Return response
}

ClassMethod ProcessValidContext(input, context)
{
    Do ##class(Ens.Util.Trace).WriteTrace("user", $classname(), "", "input: "_input)
    Do ##class(Ens.Util.Trace).WriteTrace("user", $classname(), "", "context: "_context.%ToJSON())
    Set input = $ZCONVERT(input, "L")
    If (input = "clothes") {
        #; Set estimateMsg = ##class(dc.irisflow.interoplib.climatiq.msg.beta3.EstimateMsg).%New()
        #; Set estimateMsg.EmissionFactor = {
        #;         "activity_id": "consumer_goods-type_clothing"
        #;     }.%ToJSON()
        #; Set estimateMsg.Parameters = {
        #;         "money": 120,
        #;         "money_unit": "usd"
        #;     }.%ToJSON()
        Set estimateMsg = ##class(dc.irisflow.interoplib.climatiq.msg.beta3.EstimateClothesMsg).%New()
        Set estimateMsg.Money = 120
        Set estimateMsg.MoneyUnit = "usd"
        Set st = estimateMsg.%JSONExportToString(.json)
        Throw:(st '= 1) ##class(%Exception.StatusException).CreateFromStatus(st)
        Set context.estimateMsg = json
        Set context.climatiqMsgType = estimateMsg.%ClassName(1)

    } ElseIf (input = "flight") {
        Set json = {
            "legs": [
                {
                    "from": "BER",
                    "to": "HAM",
                    "passengers": 2,
                    "class": "first"
                },
                {
                    "from": "HAM",
                    "to": "JFK",
                    "passengers": 2,
                    "class": "economy"
                }
            ]
        }
        Set estimateMsg = ##class(dc.irisflow.interoplib.climatiq.msg.beta3.EstimateFlightLegsMsg).%New()
        $$$TOE(st, estimateMsg.%JSONImport(json))
        Set context.estimateMsg = json
        Set context.climatiqMsgType = estimateMsg.%ClassName(1)

    } ElseIf (input = "water treatment") {
        Set json = {
            "volume": 15,
            "volume_unit": "l"
        }
        Set estimateMsg = ##class(dc.irisflow.interoplib.climatiq.msg.beta3.EstimateWaterTreatmentMsg).%New()
        $$$TOE(st, estimateMsg.%JSONImport(json))
        Set context.estimateMsg = json
        Set context.climatiqMsgType = estimateMsg.%ClassName(1)

    } ElseIf (input = "plastic") {
        Set json = {
			"weight": 80,
			"weight_unit": "t"
        }
        Set estimateMsg = ##class(dc.irisflow.interoplib.climatiq.msg.beta3.EstimatePlasticWasteMsg).%New()
        $$$TOE(st, estimateMsg.%JSONImport(json))
        Set context.estimateMsg = json
        Set context.climatiqMsgType = estimateMsg.%ClassName(1)
    }
    Return context
}

ClassMethod ProcessClimatiqResponse(input)
{
    Set response = ""
    Try {
        Set input = {}.%FromJSON(input)
        Set response = "CO2 Total emissions: "_input.co2e_input."co2e_unit"
    } Catch(e) {
        Set response = input
    }
    Quit response
}

ClassMethod ProcessClimatiqResponseContext(input, context)
{
    Quit context
}

ClassMethod ProcessInvalidInput(input)
{
    Do ##class(Ens.Util.Trace).WriteTrace("user", $classname(), "", "input: "_input)
    Set response = ""
    If ($LF(..#ValidInputs, input) = 0) {
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

}
