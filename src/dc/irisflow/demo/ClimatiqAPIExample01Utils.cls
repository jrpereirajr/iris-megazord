Class dc.irisflow.demo.ClimatiqAPIExample01Utils Extends %RegisteredObject
{

Parameter ValidInputsPrefix = "give me a CO2 emission estimate example for ";

Parameter ValidInputs = {$LFS("clothes,flight,water treatment,plastic")};

ClassMethod GetActivityFromInput(input) As %String
{
    Set lst = ..#ValidInputs
    Set p = 0
    While $LISTNEXT(lst, p, item) {
        If ($FIND(input, item) > 0) {
            Return item
        }
    }
    Return ""
}

ClassMethod IsValidInput(input) As %Boolean
{
    Set input = $ZCONVERT(input, "L")
    Return (..GetActivityFromInput(input) '= "")
}

ClassMethod ProcessValidInput(input As %String, context As %DynamicObject) As %String
{
    Do ##class(Ens.Util.Trace).WriteTrace("user", $classname(), "", "input: "_input)
    Set response = ""
    If ('..IsValidInput(input)) {
        Return ##class(dc.irisflow.components.misc.ObjectScriptOperation).#CancelSendRequest
    }
    Return response
}

ClassMethod ProcessValidContext(input As %String, context As %DynamicObject) As %DynamicObject
{
    Do ##class(Ens.Util.Trace).WriteTrace("user", $classname(), "", "input: "_input)
    Do ##class(Ens.Util.Trace).WriteTrace("user", $classname(), "", "context: "_context.%ToJSON())
    Set activity = ..GetActivityFromInput(input)
    If (activity = "clothes") {
        Set json = {
			"money": 120,
			"money_unit": "usd"
        }
        Set estimateMsg = ##class(dc.jrpereirajr.interop.adapter.climatiq.msg.beta3.EstimateClothesMsg).%New()
        $$$TOE(st, estimateMsg.%JSONImport(json))
        Set context.estimateMsg = json
        Set context.climatiqMsgType = estimateMsg.%ClassName(1)

    } ElseIf (activity = "flight") {
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
        Set estimateMsg = ##class(dc.jrpereirajr.interop.adapter.climatiq.msg.beta3.EstimateFlightLegsMsg).%New()
        $$$TOE(st, estimateMsg.%JSONImport(json))
        Set context.estimateMsg = json
        Set context.climatiqMsgType = estimateMsg.%ClassName(1)

    } ElseIf (activity = "water treatment") {
        Set json = {
            "volume": 15,
            "volume_unit": "l"
        }
        Set estimateMsg = ##class(dc.jrpereirajr.interop.adapter.climatiq.msg.beta3.EstimateWaterTreatmentMsg).%New()
        $$$TOE(st, estimateMsg.%JSONImport(json))
        Set context.estimateMsg = json
        Set context.climatiqMsgType = estimateMsg.%ClassName(1)

    } ElseIf (activity = "plastic") {
        Set json = {
			"weight": 80,
			"weight_unit": "t"
        }
        Set estimateMsg = ##class(dc.jrpereirajr.interop.adapter.climatiq.msg.beta3.EstimatePlasticWasteMsg).%New()
        $$$TOE(st, estimateMsg.%JSONImport(json))
        Set context.estimateMsg = json
        Set context.climatiqMsgType = estimateMsg.%ClassName(1)
    }
    Return context
}

ClassMethod ProcessClimatiqResponse(input As %String, context As %DynamicObject) As %String
{
    Do ##class(Ens.Util.Trace).WriteTrace("user", $classname(), "", "input: "_input)
    Do ##class(Ens.Util.Trace).WriteTrace("user", $classname(), "", "context: "_context.%ToJSON())
    Set response = ""
    Try {
        Set input = {}.%FromJSON(input)
        #; Set response = "CO2 Total emissions: "_input.co2e_input."co2e_unit"
        Set pClimatiqMsgType = context.climatiqMsgType
        If (pClimatiqMsgType = ##class(dc.jrpereirajr.interop.adapter.climatiq.msg.beta3.EstimateMsg).%ClassName((1))) {
            Set response = "Estimating of CO2 emissions: "_input.co2e_input."co2e_unit"

        } ElseIf (pClimatiqMsgType = ##class(dc.jrpereirajr.interop.adapter.climatiq.msg.beta3.EstimateClothesMsg).%ClassName((1))) {
            Set response = $$$FormatText("Estimating of CO2 emissions produced by purchase %1 %2 of clothing: %3 %4", $ZCONVERT(context.estimateMsg."money_unit", "U"), context.estimateMsg.money, input.co2e, $ZCONVERT(input."co2e_unit", "U"))

        } ElseIf (pClimatiqMsgType = ##class(dc.jrpereirajr.interop.adapter.climatiq.msg.beta3.EstimateFlightLegsMsg).%ClassName((1))) {
            Set response = $$$FormatText("Estimating of CO2 emissions produced by a flight from Berlin to New York: %1 %2", input.co2e, $ZCONVERT(input."co2e_unit", "U"))

        } ElseIf (pClimatiqMsgType = ##class(dc.jrpereirajr.interop.adapter.climatiq.msg.beta3.EstimateWaterTreatmentMsg).%ClassName((1))) {
            Set response = $$$FormatText("Estimating of CO2 emissions produced by %1 %2 of water treatment: %3 %4", context.estimateMsg.volume, $ZCONVERT(context.estimateMsg."volume_unit", "U"), input.co2e, $ZCONVERT(input."co2e_unit", "U"))

        } ElseIf (pClimatiqMsgType = ##class(dc.jrpereirajr.interop.adapter.climatiq.msg.beta3.EstimatePlasticWasteMsg).%ClassName((1))) {
            Set response = $$$FormatText("Estimating of CO2 emissions produced by %1 %2 of plastic waste: %3 %4", context.estimateMsg.weight, $ZCONVERT(context.estimateMsg."weight_unit", "U"), input.co2e, $ZCONVERT(input."co2e_unit", "U"))

        } Else {
            Set response = "Response not expected"
        }
    } Catch(e) {
        Set response = e.DisplayString()
    }
    Return response
}

ClassMethod ProcessClimatiqResponseContext(input As %String, context As %DynamicObject) As %DynamicObject
{
    Return context
}

ClassMethod ProcessInvalidInput(input As %String, context As %DynamicObject) As %String
{
    Do ##class(Ens.Util.Trace).WriteTrace("user", $classname(), "", "input: "_input)
    Set response = ""
    If ('..IsValidInput(input)) {
        Set response = "Sorry, can't process you request: "_input
    } Else {
        Return ##class(dc.irisflow.components.misc.ObjectScriptOperation).#CancelSendRequest
    }
    Return response
}

ClassMethod ProcessInvalidContext(input As %String, context As %DynamicObject) As %DynamicObject
{
    Return context
}

}
