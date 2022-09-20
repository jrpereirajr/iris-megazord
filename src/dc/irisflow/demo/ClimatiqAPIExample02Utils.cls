Class dc.irisflow.demo.ClimatiqAPIExample02Utils Extends %RegisteredObject
{

ClassMethod ChatbotDecisionTree(input As %String, context As %DynamicObject) As %String
{
    Set chatId = context.ChatId
    Set o = ##class(dc.irisflow.demo.ChatbotDecisionTree).%New(chatId, input)
    Return o.input()
}

ClassMethod ChatbotDecisionTreeContext(input As %String, context As %DynamicObject) As %DynamicObject
{
    Return context
}

ClassMethod HandleClimatiqApiCalls(input As %String, context As %DynamicObject) As %String
{
    Set response = ""
    If ('..IsClimatiqApiCall(input)) {
        Return ##class(dc.irisflow.components.misc.ObjectScriptOperation).#CancelSendRequest
    }
    Return response
}

ClassMethod HandleClimatiqApiCallsContext(input As %String, context As %DynamicObject) As %DynamicObject
{
    If ('..IsClimatiqApiCall(input)) {
        Return context
    }

    Set chatId = context.ChatId
    Set route = $get(^zChatIdFinalized(chatId))

    If (route = "flight") {
        If ($Get(^zChatIdFinalized(chatId,"flight",1)) = 1) {
            Set from = "GRU"
            Set to = "JFK"
        }ElseIf ($Get(^zChatIdFinalized(chatId,"flight",1)) = 2) {
            Set from = "GRU"
            Set to = "DXB"
        }Else {
            Set from = "GRU"
            Set to = "MIA"
        }
        Set json = {
            "legs": [
                {
                    "from": (from),
                    "to": (to),
                    "passengers": (+$get(^zChatIdFinalized(chatId,"flight",2))),
                    "class": ($get(^zChatIdFinalized(chatId,"flight",3)))
                }
            ]
        }
        Set estimateMsg = ##class(dc.jrpereirajr.interop.adapter.climatiq.msg.beta3.EstimateFlightLegsMsg).%New()
        $$$TOE(st, estimateMsg.%JSONImport(json))
        Set context.estimateMsg = json
        Set context.climatiqMsgType = estimateMsg.%ClassName(1)

    } ElseIf (route = "water treatment") {
        Set json = {
            "volume": (+$get(^zChatIdFinalized(chatId,"water",1))),
            "volume_unit": "l"
        }
        Set estimateMsg = ##class(dc.jrpereirajr.interop.adapter.climatiq.msg.beta3.EstimateWaterTreatmentMsg).%New()
        $$$TOE(st, estimateMsg.%JSONImport(json))
        Set context.estimateMsg = json
        Set context.climatiqMsgType = estimateMsg.%ClassName(1)

    } ElseIf (route = "plastic") {
        Set json = {
			"weight": (+$get(^zChatIdFinalized(chatId,"plastic",1))),
			"weight_unit": ($get(^zChatIdFinalized(chatId,"plastic",2)))
        }
        Set estimateMsg = ##class(dc.jrpereirajr.interop.adapter.climatiq.msg.beta3.EstimatePlasticWasteMsg).%New()
        $$$TOE(st, estimateMsg.%JSONImport(json))
        Set context.estimateMsg = json
        Set context.climatiqMsgType = estimateMsg.%ClassName(1)

    } ElseIf (route = "clothes") {
        Set json = {
			"money": (+$get(^zChatIdFinalized(chatId,"clothes",1))),
			"money_unit": ($get(^zChatIdFinalized(chatId,"clothes",2)))
        }
        Set estimateMsg = ##class(dc.jrpereirajr.interop.adapter.climatiq.msg.beta3.EstimateClothesMsg).%New()
        $$$TOE(st, estimateMsg.%JSONImport(json))
        Set context.estimateMsg = json
        Set context.climatiqMsgType = estimateMsg.%ClassName(1)
    }
    If (context.%IsDefined("estimateMsg")) {
        Kill ^zChatIdFinalized(chatId)
    }
    Return context
}

ClassMethod IsClimatiqApiCall(pInput As %String) As %Boolean
{
    Return $FIND(pInput, ##class(dc.irisflow.demo.ChatbotDecisionTree).#CallClimatiqAPI) > 0
}

ClassMethod HandleUserInteration(input As %String, context As %DynamicObject) As %String
{
    Set response = input
    If (..IsClimatiqApiCall(input)) {
        Return ##class(dc.irisflow.components.misc.ObjectScriptOperation).#CancelSendRequest
    }
    Return response
}

ClassMethod HandleUserInterationContext(input As %String, context As %DynamicObject) As %DynamicObject
{
    Return context
}

ClassMethod FormatResponse(input As %String, context As %DynamicObject) As %String
{
    Set response = ""
    Try {
        Set input = {}.%FromJSON(input)
        Set pClimatiqMsgType = context.climatiqMsgType
        If (pClimatiqMsgType = ##class(dc.jrpereirajr.interop.adapter.climatiq.msg.beta3.EstimateMsg).%ClassName((1))) {
            Set response = "Estimating of CO2 emissions: "_input.co2e_input."co2e_unit"

        } ElseIf (pClimatiqMsgType = ##class(dc.jrpereirajr.interop.adapter.climatiq.msg.beta3.EstimateClothesMsg).%ClassName((1))) {
            Set response = $$$FormatText("Estimating of CO2 emissions produced by purchase %1 %2 of clothing: %3 %4", $ZCONVERT(context.estimateMsg."money_unit", "U"), context.estimateMsg.money, input.co2e, $ZCONVERT(input."co2e_unit", "U"))

        } ElseIf (pClimatiqMsgType = ##class(dc.jrpereirajr.interop.adapter.climatiq.msg.beta3.EstimateFlightLegsMsg).%ClassName((1))) {
            Set response = $$$FormatText("Estimating of CO2 emissions produced by a flight from %3 to %4: %1 %2", input.co2e, $ZCONVERT(input."co2e_unit", "U"), context.estimateMsg.legs.%Get(0).from, context.estimateMsg.legs.%Get(0).to)

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

ClassMethod FormatResponseContext(input As %String, context As %DynamicObject) As %DynamicObject
{
    Return context
}

}
