Class dc.irisflow.ProductionBuilder Extends %RegisteredObject
{

Property errors As %DynamicArray;

Property errorHelper As dc.irisflow.Error;

Property productionName As %String;

Method %OnNew() As %Status
{
    Set ..errors = []
    Set ..errorHelper = ##class(dc.irisflow.Error).%New()
	Quit $$$OK
}

Method Build(config As %DynamicObject)
{
    If (config.production '= "") {
        Do ..CreateProduction(config.production)
        Do:(config.bs '= "") ..foreach(config.bs, "CreateBusinessService")
        Do:(config.bo '= "") ..foreach(config.bo, "CreateBusinessOperation")
        Do:(config.bp '= "") ..foreach(config.bp, "CreateBusinessProcess")
    } Else {
        Do ..errors.%Push(..errorHelper.CreateNoProductionDefinedError())
    }
}

Method CreateProduction(config As %DynamicObject)
{
    If (config.name '= "") {
        If ##class(%Dictionary.ClassDefinition).%ExistsId(config.name) {
            $$$TOE(st, ##class(%Dictionary.ClassDefinition).%DeleteId(config.name))
        }

        Set class = ##class(%Dictionary.ClassDefinition).%New(config.name)
        Set class.Super = "Ens.Production"

        Set xdata = ##class(%Dictionary.XDataDefinition).%New()
        Set xdata.Name = "ProductionDefinition"
        Do xdata.Data.Write("<Production Name="""_config.name_""" LogGeneralTraceEvents=""true""></Production>")
        Do class.XDatas.Insert(xdata)

        $$$TOE(st, class.%Save())
        $$$TOE(st, $System.OBJ.Compile(config.name, "fck-dv"))

        Set ..productionName = config.name
    } Else {
        Do ..errors.%Push(..errorHelper.CreateNoProductionDefinedError())
    }
}

Method CreateBusinessService(bs As %DynamicObject)
{
    If (..ValidateBSConfig()) {
        Set production = ##class(Ens.Config.Production).%OpenId(..productionName)
        Set item = ##class(Ens.Config.Item).%New()
        Set item.Name = bs.name
        Set item.ClassName = bs.className
        Do production.Items.Insert(item)
        $$$TOE(st, production.%Save())

        Do ..ProcessTargets(bs)
        Do ..SaveConfig(bs, item)
    }

    Return $this
}

Method ValidateBSConfig(bs As %DynamicObject) As %Boolean
{
    // todo:
    Return $$$OK
}

Method CreateBusinessOperation(bo As %DynamicObject)
{
    If (..ValidateBOConfig()) {
        Set production = ##class(Ens.Config.Production).%OpenId(..productionName)
        Set item = ##class(Ens.Config.Item).%New()
        Set item.Name = bo.name
        Set item.ClassName = bo.className
        Do production.Items.Insert(item)
        $$$TOE(st, production.%Save())

        Do ..ProcessTargets(bo)
        Do ..SaveConfig(bo, item)
    }

    Return $this
}

Method ValidateBOConfig(bs As %DynamicObject) As %Boolean
{
    // todo:
    Return $$$OK
}

Method CreateBusinessProcess(bp As %DynamicObject)
{
    // todo: method under construction...
    
    #; Write "[CreateBusinessProcess] "
    #; ZW config
    If (..ValidateBPConfig()) {
        Set class = ##class(%Dictionary.ClassDefinition).%New(bp.className)
        #; Set class.ProcedureBlock = 1
        Set class.Super = "Ens.BusinessProcessBPL"

        Set xdata = ##class(%Dictionary.XDataDefinition).%New()
        Set xdata.Name = "BPL"
        Do xdata.Data.Write(            
            "<process language='objectscript' request='Ens.Request' response='Ens.Response' height='2000' width='2000' > "_
            "<sequence xend='200' yend='450' > "_
            "<call name='ToFile' target='ToFile' async='0' xpos='200' ypos='350' > "_
            "<request type='Ens.Request' > "_
            "<assign property=""callrequest"" value=""request"" action=""set"" /> "_
            "</request> "_
            "<response type='Ens.Response' /> "_
            "</call> "_
            "</sequence> "_
            "</process> "
        )
        Do class.XDatas.Insert(xdata)

        $$$TOE(st, class.%Save())
        $$$TOE(st, $System.OBJ.Compile(bp.className, "fck-dv"))
        
        Set production = ##class(Ens.Config.Production).%OpenId(..productionName)
        Set item = ##class(Ens.Config.Item).%New()
        Set item.Name = bp.name
        Set item.ClassName = class.Name
        Do production.Items.Insert(item)
        $$$TOE(st, production.%Save())
        #; Do ..SaveConfig(bp, item)
    }
}

Method ValidateBPConfig(bs As %DynamicObject) As %Boolean
{
    // todo:
    Return $$$OK
}

Method foreach(array As %DynamicArray, callback)
{
    Set it = array.%GetIterator()
    While it.%GetNext(.idx, .val) {
        Do $METHOD($this, callback, val)
    }
}

Method ProcessTargets(host As Ens.Host)
{
    If (host.targets '= "") {
        Set targetsIt = host.targets.%GetIterator()
        Set targetList = ""
        While targetsIt.%GetNext(.idx, .target) {
            Set $List(targetList, * + 1) = target.name
        }
        If (targetList '= "") {
            Do host.config.%Push({
                "name": "TargetConfigNames",
                "value": ($LTS(targetList))
            })
        }
    }
}

Method SaveConfig(host As %DynamicObject, item As Ens.Config.Item)
{
    Set configIt = host.config.%GetIterator()
    While (configIt.%GetNext(.idx, .config)) {
        Set setting = ..CreateSettings(item.Name, config.name, config.value)
        Do item.Settings.Insert(setting)
        $$$TOE(st, item.%Save())
    }
}

Method CreateSettings(itemName As %String, propName As %String, propValue) As Ens.Config.Setting
{
    Set setting = ##class(Ens.Config.Setting).%New()
    Set setting.Target = ..GetSettingTarget(itemName, propName)
    Set setting.Name = propName
    Set setting.Value = propValue
    Return setting
}

Method GetSettingTarget(itemName As %String, propName As %String) As %String
{
    $$$TOE(st, ##class(EnsPortal.Utils).ItemSettings(..productionName_"||"_itemName, .pData, .pMetaData))
    Set k = $O(pData(""))
    While (k '= "") {
        Quit:($LG(pData(k), 2) = propName)
        Set k = $O(pData(k))
    }
    Return:(k '= "") $LG(pData(k), 1)
    Throw ##class(%Exception.General).%New($$$FormatText("Setting %1 not found for item %2 in production %3.", propName, itemName, ..productionName))
}

}
