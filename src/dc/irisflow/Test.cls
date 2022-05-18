Class dc.irisflow.Test Extends %RegisteredObject
{

Parameter BusinessHostTypeBS = "BusinessService";

Parameter BusinessHostTypeBP = "BusinessProcess";

Parameter BusinessHostTypeBO = "BusinessOperation";

/// Description
ClassMethod Run() As %Status
{
    Set sc = $$$OK

    Set flow = {
        "name": "Helloworld",
        "nodes": [{
            "name": "FromFile",
            "type": "action",
            "config": {
                "class": "EnsLib.File.PassthroughService"
            },
        "targets": [{
            "name": "ToFile"
        }]
        },{
            "name": "ToFile",
            "type": "action",
            "config": {
                "class": "EnsLib.File.PassthroughOperation"
            },
        "targets": []
        }]
    }

    Set mappedProduction = {
        "production": {
            "name": "Helloworld"
        },
        "bs": [{
            "name": "FromFile",
            "config": {
                "class": "EnsLib.File.PassthroughService"
            }
        }],
        "bp": [{
            "name": "DefaultFlowBP",
            "config": [{
                "type": "call",
                "target": "ToFile"
            }]
        }],
        "bo": [{
            "name": "ToFile",
            "config": {
                "class": "EnsLib.File.PassthroughOperation"
            }
        }]
    }
    
    Set builder = ..%New()

    Do builder.CreateProduction(mappedProduction.production)
    Do builder.foreach(mappedProduction.bs, "CreateBusinessService")
    Do builder.foreach(mappedProduction.bp, "CreateBusinessProcess")
    Do builder.foreach(mappedProduction.bo, "CreateBusinessOperation")
    
    #; Do builder.Production({
    #;     "name": "dc.irisflow.test.Helloworld"
    #; }).Item({
    #;     "name": "dc.irisflow.test.FromFile",
    #;     "type": (..#BusinessHostTypeBS)
    #; }).Item({
    #;     "name": "dc.irisflow.test.DefaultFlowBP",
    #;     "type": (..#BusinessHostTypeBP)
    #; }).Item({
    #;     "name": "dc.irisflow.test.ToFile",
    #;     "type": (..#BusinessHostTypeBO)
    #; })

    Return sc
}

Method foreach(array As %DynamicArray, callback)
{
    Set it = array.%GetIterator()
    While it.%GetNext(.idx, .val) {
        Do $METHOD($this, callback, val)
    }
}

Method CreateProduction(config As %DynamicObject)
{
    Write "[CreateProduction] "
    ZW config
}

Method CreateBusinessService(config As %DynamicObject)
{
    Write "[CreateBusinessService] "
    ZW config
}

Method CreateBusinessProcess(config As %DynamicObject)
{
    Write "[CreateBusinessProcess] "
    ZW config
}

Method CreateBusinessOperation(config As %DynamicObject)
{
    Write "[CreateBusinessOperation] "
    ZW config
}

/*
Method Production(config As %DynamicObject) As Test
{
    Write "[Creating production] "
    ZW config

    Return $this
}

Method Item(config As %DynamicObject) As Test
{
    Write "[Creating production item] "
    ZW config

    Return $this
}
*/
ClassMethod ListProductions()
{
    #; Set rs = ##class(%ResultSet).%New()
    #; Set rs.ClassName = "EnsPortal.Productions"
    #; Set rs.QueryName = "Enumerate"
    #; $$$TOE(st, rs.Execute())
    #; While (rs.Next()) {
    #;     Write rs.Production,!
    #; }

    Set stmt = ##class(%SQL.Statement).%New()
    #; $$$TOE(st, stmt.%PrepareClassQuery("EnsPortal.Productions", "Enumerate"))
    $$$TOE(st, stmt.%PrepareClassQuery("Ens.Config.Production", "ProductionStatus"))
    Set rs = stmt.%Execute()
    While (rs.%Next()) {
        Write rs.Production,!
    }
}

ClassMethod TestGetItemInfo()
{
    w ##class(EnsPortal.Utils).ItemSettings("dc.irisflow.test.template1.NewProduction||FromFileMsg", .pData, .pMetaData)
    #; w ##class(EnsPortal.Utils).ItemSettings("User.Helloworld||FromFile", .pData, .pMetaData)
    zw pMetaData
    s k = $O(pData(""))
    while (k '= "") {
        zw $list(pData(k), 1, 3)
        s k = $O(pData(k))
    }

    s o = ##class(Ens.Config.Item).%OpenId(4)
    for i = 1:1:o.Settings.Count() {
        zw o.Settings.GetAt(i)
    }
}

}
