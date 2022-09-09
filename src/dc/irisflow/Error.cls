Class dc.irisflow.Error Extends %RegisteredObject
{

Method CreateError(code As %String, description As %String, info As %DynamicArray = "") As %DynamicObject
{
    Return {
        "code": (code),
        "description": (description),
        "info": (info)
    }
}

Method CreateNoProductionDefinedError()
{
    Return ..CreateError("NoProductionDefined", "No production defined.")
}

Method CreateNoNamedActionError(actionIdx As %String)
{
    Return ..CreateError(
        "NoNamedActionError", 
        $$$FormatText("No name was found for action #%1.", actionIdx),
        {
            "actionIndex": (actionIdx)
        }
    )
}

Method CreateNoConfigActionError(actionIdx As %String)
{
    Return ..CreateError(
        "NoConfigActionError", 
        $$$FormatText("No config was found for action #%1.", actionIdx),
        {
            "actionIndex": (actionIdx)
        }
    )
}

}
