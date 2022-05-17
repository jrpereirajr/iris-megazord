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
        Do:(config.bp '= "") ..foreach(config.bp, "CreateBusinessProcess")
        Do:(config.bo '= "") ..foreach(config.bo, "CreateBusinessOperation")
    } Else {
        Do ..errors.%Push(..errorHelper.CreateNoProductionDefinedError())
    }
}

Method CreateProduction(config As %DynamicObject) As Builder
{
    If (config.name '= "") {
        Set class = ##class(%Dictionary.ClassDefinition).%New(config.name)
        Set class.ProcedureBlock = 1
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

    Return $this
}

Method CreateBusinessService(bs As %DynamicObject) As Builder
{
    If (..ValidateBSConfig()) {
        Set production = ##class(Ens.Config.Production).%OpenId(..productionName)
        Set item = ##class(Ens.Config.Item).%New()
        Set item.Name = bs.name
        Set item.ClassName = bs.config.className
        Do production.Items.Insert(item)
        // todo: define (in JSON) and set BS configurations
        $$$TOE(st, production.%Save())
    }

    Return $this
}

Method ValidateBSConfig(bs As %DynamicObject) As %Boolean
{
    // todo:
    Return $$$OK
}

Method CreateBusinessProcess(config As %DynamicObject) As Builder
{
    #; Write "[CreateBusinessProcess] "
    #; ZW config

    Return $this
}

Method CreateBusinessOperation(bo As %DynamicObject)
{
    If (..ValidateBOConfig()) {
        Set production = ##class(Ens.Config.Production).%OpenId(..productionName)
        Set item = ##class(Ens.Config.Item).%New()
        Set item.Name = bo.name
        Set item.ClassName = bo.config.className
        Do production.Items.Insert(item)
        // todo: define (in JSON) and set BO configurations
        $$$TOE(st, production.%Save())
    }

    Return $this
}

Method ValidateBOConfig(bs As %DynamicObject) As %Boolean
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

}
