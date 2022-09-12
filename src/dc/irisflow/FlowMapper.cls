Class dc.irisflow.FlowMapper Extends %RegisteredObject
{

Property flow As %DynamicObject;

Property mapped As %DynamicObject;

Property errors As %DynamicArray;

Property errorHelper As dc.irisflow.Error;

Method %OnNew() As %Status
{
    Set ..flow = {}
    Set ..mapped = ..CreateMappedTemplate()
    Set ..errors = []
    Set ..errorHelper = ##class(dc.irisflow.Error).%New()
	Quit $$$OK
}

Method CreateMappedTemplate()
{
    Return {
        "production": {},
        "bs": [],
        "bp": [],
        "bo": []
    }
}

Method Map(flow As %DynamicObject) As %DynamicObject
{
    Set ..flow = flow
    Do ..GetProduction()
    Do ..ProcessFlowNodes()
    Return ..mapped
}

Method GetProduction()
{
    If (..flow.name '= "") {
        Set ..mapped.production = {
            "name": (..flow.name)
        }
    } Else {
        Do ..errors.%Push(..errorHelper.CreateNoProductionDefinedError())
    }
}

Method ProcessFlowNodes()
{
    If (..flow.nodes) {
        Set it = ..flow.nodes.%GetIterator()
        While (it.%GetNext(.idx, .node)) {
            If (..IsBusinessService(node)) {
                Do ..mapped.bs.%Push(..CreateBusinessService(node, idx))
            }
            If (..IsBusinessOperation(node)) {
                Do ..mapped.bo.%Push(..CreateBusinessOperation(node, idx))
            }
            #; Do ..ProcessBPL(node)
        }
    }
}

Method IsBusinessService(node As %DynamicObject) As %Boolean
{
    If (node.type = "action") {
        Set actionClass = node.config.className
        If ($CLASSMETHOD(actionClass, "%IsA", "Ens.BusinessService")) {
            Return 1
        }
    }
    Return 0
}

Method IsBusinessOperation(node As %DynamicObject) As %Boolean
{
    If (node.type = "action") {
        Set actionClass = node.config.className
        If ($CLASSMETHOD(actionClass, "%IsA", "Ens.BusinessOperation")) {
            Return 1
        }
    }
    Return 0
}

Method CreateBusinessHost(node As %DynamicObject, nodeIdx As %Integer) As %DynamicObject
{
    Set item = {}
    Set errors = 0
    
    If (node.name = "") {
        Do ..errors.%Push(..errorHelper.CreateNoNamedActionError(nodeIdx))
        Set errors = 1
    }
    If (node.config = "") || ('node.config.className = "") {
        Do ..errors.%Push(..errorHelper.CreateNoConfigActionError(nodeIdx))
        Set errors = 1
    }

    If ('errors) {
        Set item = {
            "name": (node.name),
                "className": (node.config.className),
            "config": [],
            "targets": []
        }

        Set configIt = node.config.%GetIterator()
        While (configIt.%GetNext(.configKey, .config)) {
            If (configKey '= "className") {
                Do item.config.%Push({
                    "name": (configKey), 
                    "value": (config)
                })
            }
        }

        If ($IsObject(node.targets)) {
            Set targetsIt = node.targets.%GetIterator()
            While (targetsIt.%GetNext(.targetIdx, .target)) {
                Do item.targets.%Push({
                    "name": (target.name)
                })
            }
        }
    }

    Return item
}

Method CreateBusinessService(node As %DynamicObject, nodeIdx As %Integer) As %DynamicObject
{
    Set bs = ..CreateBusinessHost(node, nodeIdx)
    Return bs
}

Method CreateBusinessOperation(node As %DynamicObject, nodeIdx As %Integer) As %DynamicObject
{
    Set bo = ..CreateBusinessHost(node, nodeIdx)
    Return bo
}

/* BPL will be redesigned */

/*
Method ProcessBPL(node As %DynamicObject)
{
    #; If (..mapped.bp.%Size() = 0){
    #;     Do ..mapped.bp.%Push(..CreateDefaultFlowBP())
    #; }

    If (node.targets '= "") {
        Do ..ProcessNodeTargets(node)
    }
}

Method CreateDefaultFlowBP() As %DynamicObject
{
    Return {
        "name": "DefaultFlowBP",
        "config": {
            "sequence": []
        }
    }
}

Method ProcessNodeTargets(node As %DynamicObject)
{
    Set errors = 0
    If (node.targets.%Size() = 0) {
        // todo: add error (no targets defined)
        Set errors = 1
    }
    If (node.targets.%Size() > 1) {
        // todo: add error (current implementation for just one target)
        Set errors = 1
    }
    If (errors = 0) {
        Set target = node.targets.%Get(0)
        // for now, a node with a target is mapped as a call in BPL
        Set call = ..CreateBPCallForTarget(target)
        Set bp = ..mapped.bp.%Get(0)
        Do bp.config.sequence.%Push(call)
    }
}

Method CreateBPCallForTarget(targetName As %String)
{
    Set call = {
        "type": "call",
        "target": (targetName)
    }
    Return call
}
*/
}
