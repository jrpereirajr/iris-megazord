Class dc.irismessageviewer.Service.SendMessage Extends Ens.BusinessService [ ProcedureBlock ]
{

Method OnProcessInput(input As %Library.AbstractStream, ByRef output As %Stream.Object) As %Status
{
    Set tSC = $$$OK

    // Create the request message
    Set request = ##class(dc.irismessageviewer.Message.SimpleMessage).%New()

    // Place a value in the request message property
    Set request.ClassMessage = input

    // Make a synchronous call to the business process and use the response message as our response 
    Set tSC = ..SendRequestSync("dc.irismessageviewer.Operation.ConsumeMessageClass",request,.output)

    Quit tSC
}

}
