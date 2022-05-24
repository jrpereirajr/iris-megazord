Class UnitTest.dc.irisflow.ProductionBuilder Extends %UnitTest.TestCase
{

Property builder As dc.irisflow.ProductionBuilder;

Parameter ProductionName = "User.Helloworld";

Method OnBeforeOneTest(testname As %String) As %Status
{
    Set ..builder = ##class(dc.irisflow.ProductionBuilder).%New()

    Return $$$OK
}

Method OnAfterOneTest(testname As %String) As %Status
{
    Set builder = ..builder
    Kill builder

    Try {
        Do:(##class(%ClassDefinition).%ExistsId(..#ProductionName)) $system.OBJ.Delete(
            ..#ProductionName_"*", "/display=none"
        )
    }Catch(e) {}

    Return $$$OK
}

Method TestBuildFail()
{
    Set config = {}
    Set expected = [(..builder.errorHelper.CreateNoProductionDefinedError())]
    Do ..builder.Build(config)
    Set errors = ..builder.errors
    Do $$$AssertEquals(errors.%ToJSON(), expected.%ToJSON())
    Do $$$AssertEquals(errors.%Size(), 1)
}

Method TestCreateProduction()
{
    Set config = {
        "production": {
            "name": (..#ProductionName)
        }
    }
    
    Do ..builder.Build(config)

    Set production = ##class(Ens.Config.Production).%OpenId(config.production.name)
    Do $$$AssertTrue($IsObject(production))
    Do $$$AssertEquals(production.Name, config.production.name)
}

Method TestCreateProductionFail()
{
    Set config = {}
    Set expected = [(..builder.errorHelper.CreateNoProductionDefinedError())]
    Do ..builder.CreateProduction(config)
    Set errors = ..builder.errors
    Do $$$AssertEquals(errors.%ToJSON(), expected.%ToJSON())
    Do $$$AssertEquals(errors.%Size(), 1)
}

Method TestCreateBusinessService()
{
    Set config = {
        "production": {
            "name": (..#ProductionName)
        },
        "bs": [{
            "name": "FromFile",
            "className": "dc.irisflow.components.file.FilePassthroughService",
            "config": [],
            "targets": [{
                "name": "ToFile"
            }]
        }]
    }
    Set bs = config.bs.%Get(0)
    
    Do ..builder.Build(config)

    Set production = ##class(Ens.Config.Production).%OpenId(config.production.name)
    Do $$$AssertTrue($IsObject(production))
    Do $$$AssertEquals(production.Name, config.production.name)

    Set sql = "select * from Ens_Config.Item where Production = ? and Name = ? and ClassName = ?"
    Set rs = ##class(%SQL.Statement).%ExecDirect(, sql, ..#ProductionName, bs.name, bs.className)
    Do $$$AssertTrue(rs.%Next())
}

Method TestCreateBusinessServiceFail()
{
    // todo:
    #; Set config = {}
    #; Set expected = [(..builder.errorHelper.CreateNoProductionDefinedError())]
    #; Do ..builder.CreateProduction(config)
    #; Set errors = ..builder.errors
    #; Do $$$AssertEquals(errors.%ToJSON(), expected.%ToJSON())
    #; Do $$$AssertEquals(errors.%Size(), 1)
}

Method TestCreateBusinessOperation()
{
    Set config = {
        "production": {
            "name": (..#ProductionName)
        },
        "bo": [{
            "name": "ToFile",
            "className": "dc.irisflow.components.file.FilePassthroughOperation",
            "config": []
        }]
    }
    Set bo = config.bo.%Get(0)
    
    Do ..builder.Build(config)

    Set production = ##class(Ens.Config.Production).%OpenId(config.production.name)
    Do $$$AssertTrue($IsObject(production))
    Do $$$AssertEquals(production.Name, config.production.name)

    Set sql = "select * from Ens_Config.Item where Production = ? and Name = ? and ClassName = ?"
    Set rs = ##class(%SQL.Statement).%ExecDirect(, sql, ..#ProductionName, bo.name, bo.className)
    Do $$$AssertTrue(rs.%Next())
}

Method TestCreateBusinessOperationFail()
{
    // todo:
    #; Set config = {}
    #; Set expected = [(..builder.errorHelper.CreateNoProductionDefinedError())]
    #; Do ..builder.CreateProduction(config)
    #; Set errors = ..builder.errors
    #; Do $$$AssertEquals(errors.%ToJSON(), expected.%ToJSON())
    #; Do $$$AssertEquals(errors.%Size(), 1)
}

Method TestSaveConfig()
{
    // todo:
}

Method TestCreateSettings()
{
    // todo:
}

Method TestGetSettingTarget()
{
    // todo:
}

Method TestCreateBusinessProcessFail()
{
    // todo:
    #; Set config = {}
    #; Set expected = [(..builder.errorHelper.CreateNoProductionDefinedError())]
    #; Do ..builder.CreateProduction(config)
    #; Set errors = ..builder.errors
    #; Do $$$AssertEquals(errors.%ToJSON(), expected.%ToJSON())
    #; Do $$$AssertEquals(errors.%Size(), 1)
}

}
