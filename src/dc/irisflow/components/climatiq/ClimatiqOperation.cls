Class dc.irisflow.components.climatiq.ClimatiqOperation Extends (dc.irisflow.components.IrisFlowBusinessOperation, dc.jrpereirajr.interop.adapter.climatiq.ClimatiqOperation)
{

Property Adapter As dc.irisflow.components.climatiq.ClimatiqOutboundAdapter;

Parameter ADAPTER = "dc.irisflow.components.climatiq.ClimatiqOutboundAdapter";

Method OnConsumeMessage(ByRef pRequest As dc.irisflow.components.GenericMessage, Output pResponse As Ens.Response)
{
    Set response = ..ProcessRequest(pRequest)

	Set message = ##class(dc.irisflow.components.GenericMessage).%New()
	Set message.Stream = ##class(%Stream.GlobalCharacter).%New()
	$$$TOE(st, message.Stream.Write(response.Data.Read()))
	Set message.Context = pRequest.Context.%ToJSON()

    Kill pRequest
    Set pRequest = message
}

Method ProcessRequest(pRequest As dc.irisflow.components.GenericMessage) As %RegisteredObject
{
    Set response = ""
    Set inputMessage = pRequest.Stream.Read()
    $$$TRACE("inputMessage: "_inputMessage)
    
    Set context = ..GetContextAsDynamicObject(pRequest)

    If (context.estimateMsg '= "") {
        Set pRequest.Context = context
        Set response = ..CallClimatiqOperationByMsgType(context.climatiqMsgType, pRequest.Context.estimateMsg)
    } Else {
        Set message = ##class(%Stream.GlobalCharacter).%New()
        $$$TOE(st, message.Write("Sorry, can't process: "_inputMessage))
        Set response = {
            "Data": (message)
        }
    }
        
    Set pRequest.Context = context
    Return response
}

Method CallClimatiqOperationByMsgType(pClimatiqMsgType As %String, pOrinalMsg As %String) As Ens.Response
{
    /// TODO: change this method by an Ensemble one based on XData MessageMap
    Set response = ""

    If (pClimatiqMsgType = ##class(dc.jrpereirajr.interop.adapter.climatiq.msg.beta3.EstimateMsg).%ClassName((1))) {
        Set estimateMsg = ##class(dc.jrpereirajr.interop.adapter.climatiq.msg.beta3.EstimateMsg).%New()
        Set json = pOrinalMsg
        $$$TOE(st, estimateMsg.%JSONImport(json))
        $$$TOE(st, ..EstimateGeneric(.estimateMsg, .response))

    } ElseIf (pClimatiqMsgType = ##class(dc.jrpereirajr.interop.adapter.climatiq.msg.beta3.EstimateClothesMsg).%ClassName((1))) {
        Set estimateClothesMsg = ##class(dc.jrpereirajr.interop.adapter.climatiq.msg.beta3.EstimateClothesMsg).%New()
        Set json = pOrinalMsg
        $$$TOE(st, estimateClothesMsg.%JSONImport(json))
        $$$TOE(st, ..EstimateClothes(.estimateClothesMsg, .response))

    } ElseIf (pClimatiqMsgType = ##class(dc.jrpereirajr.interop.adapter.climatiq.msg.beta3.EstimateFlightLegsMsg).%ClassName((1))) {
        Set estimateFlightLegsMsg = ##class(dc.jrpereirajr.interop.adapter.climatiq.msg.beta3.EstimateFlightLegsMsg).%New()
        Set json = pOrinalMsg
        $$$TOE(st, estimateFlightLegsMsg.%JSONImport(json))
        $$$TOE(st, ..EstimateFlight(.estimateFlightLegsMsg, .response))

    } ElseIf (pClimatiqMsgType = ##class(dc.jrpereirajr.interop.adapter.climatiq.msg.beta3.EstimateWaterTreatmentMsg).%ClassName((1))) {
        Set estimateWaterTreatmentMsg = ##class(dc.jrpereirajr.interop.adapter.climatiq.msg.beta3.EstimateWaterTreatmentMsg).%New()
        Set json = pOrinalMsg
        $$$TOE(st, estimateWaterTreatmentMsg.%JSONImport(json))
        $$$TOE(st, ..EstimateWaterTreatment(.estimateWaterTreatmentMsg, .response))

    } ElseIf (pClimatiqMsgType = ##class(dc.jrpereirajr.interop.adapter.climatiq.msg.beta3.EstimatePlasticWasteMsg).%ClassName((1))) {
        Set estimatePlasticWasteMsg = ##class(dc.jrpereirajr.interop.adapter.climatiq.msg.beta3.EstimatePlasticWasteMsg).%New()
        Set json = pOrinalMsg
        $$$TOE(st, estimatePlasticWasteMsg.%JSONImport(json))
        $$$TOE(st, ..EstimatePlasticWaste(.estimatePlasticWasteMsg, .response))

    } Else {
        Throw ##class(%Exception.General).%New("Message type not mapped: "_pClimatiqMsgType)
    }

    Return response
}

}
