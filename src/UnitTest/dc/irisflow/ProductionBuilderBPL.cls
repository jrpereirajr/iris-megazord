Class UnitTest.dc.irisflow.ProductionBuilderBPL Extends %UnitTest.TestCase
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

Method TestBuild()
{
    Set config = {
        "production": {
            "name": (..#ProductionName)
        },
        "bs": [{
            "name": "FromFile",
            "className": "dc.irisflow.components.file.FilePassthroughService",
            "config": [{
                "name": "FilePath",
                "value": "/tmp/test/in"
            }],
            "targets": [{
                "name": "DefaultFlowBP"
            }]
        }],
        "bp": [{
            "name": "DefaultFlowBP",
            "className": (..#ProductionName_"DefaultFlowBP"),
            "sequence": [{
                "type": "call",
                "target": {
                    "name":"ToFile"
                }
            }],
            "config": []
        }],
        "bo": [{
            "name": "ToFile",
            "className": "dc.irisflow.components.file.FilePassthroughOperation",
            "config": [{
                "name": "FilePath",
                "value": "/tmp/test/out"
            }]
        }]
    }
    Set bs = config.bs.%Get(0)
    Set bo = config.bo.%Get(0)
    
    Do ..builder.Build(config)

    Set production = ##class(Ens.Config.Production).%OpenId(config.production.name)
    Do $$$AssertTrue($IsObject(production))
    Do $$$AssertEquals(production.Name, config.production.name)

    Set sql = "select * from Ens_Config.Item where Production = ? and Name = ? and ClassName = ?"
    Set rs = ##class(%SQL.Statement).%ExecDirect(, sql, ..#ProductionName, bs.name, bs.className)
    Do $$$AssertTrue(rs.%Next())
    Set expected = $lb($lb($lb("FilePath","Adapter","/tmp/test/in")),$lb($lb("TargetConfigNames","Host","DefaultFlowBP")))
    Do $$$AssertEquals(rs.Settings, expected)

    Set sql = "select * from Ens_Config.Item where Production = ? and Name = ? and ClassName = ?"
    Set rs = ##class(%SQL.Statement).%ExecDirect(, sql, ..#ProductionName, bo.name, bo.className)
    Do $$$AssertTrue(rs.%Next())
    Do $$$AssertEquals(rs.Settings, $lb($lb($lb("FilePath","Adapter","/tmp/test/out"))))

    // todo: check if BPL was created
}

Method TestCreateBusinessProcess()
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
