Class UnitTest.dc.irisflow.ProductionBuilderHelloworld2 Extends %UnitTest.TestCase
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

Method TestBuildHelloworld2()
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
                "name": "ToFile,ToFile1"
            }]
        }],
        "bp": [],
        "bo": [{
            "name": "ToFile",
            "className": "dc.irisflow.components.file.FilePassthroughOperation",
            "config": [{
                "name": "FilePath",
                "value": "/tmp/test/out"
            }],
            "targets": []
        },{
            "name": "ToFile1",
            "className": "dc.irisflow.components.file.FilePassthroughOperation",
            "config": [{
                "name": "FilePath",
                "value": "/tmp/test/out"
            }],
            "targets": []
        }]
    }
    Set bs = config.bs
    Set bo = config.bo
    
    Do ..builder.Build(config)

    Set production = ##class(Ens.Config.Production).%OpenId(config.production.name)
    Do $$$AssertTrue($IsObject(production))
    Do $$$AssertEquals(production.Name, config.production.name)

    Set sql = "select * from Ens_Config.Item where Production = ? and Name = ? and ClassName = ?"
    Set rs = ##class(%SQL.Statement).%ExecDirect(, sql, ..#ProductionName, bs.%Get(0).name, bs.%Get(0).className)
    Set expected = $lb($lb($lb("FilePath","Adapter","/tmp/test/in")),$lb($lb("TargetConfigNames","Host","ToFile,ToFile1")))
    Do $$$AssertTrue(rs.%Next())
    Do $$$AssertEquals(rs.Settings, expected)

    Set sql = "select * from Ens_Config.Item where Production = ? and Name = ? and ClassName = ?"
    Set rs = ##class(%SQL.Statement).%ExecDirect(, sql, ..#ProductionName, bo.%Get(0).name, bo.%Get(0).className)
    Set expected = $lb($lb($lb("FilePath","Adapter","/tmp/test/out")))
    Do $$$AssertTrue(rs.%Next())
    Do $$$AssertEquals(rs.Settings, expected)

    Set sql = "select * from Ens_Config.Item where Production = ? and Name = ? and ClassName = ?"
    Set rs = ##class(%SQL.Statement).%ExecDirect(, sql, ..#ProductionName, bo.%Get(1).name, bo.%Get(1).className)
    Set expected = $lb($lb($lb("FilePath","Adapter","/tmp/test/out")))
    Do $$$AssertTrue(rs.%Next())
    Do $$$AssertEquals(rs.Settings, expected)
}

}
