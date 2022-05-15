Class UnitTest.dc.irisflow.Main Extends %UnitTest.TestCase
{

Property mapper As dc.irisflow.FlowMapper;

ClassMethod Setup()
{
    Set ^UnitTestRoot = "/irisrun/repo/src"
}

ClassMethod Run()
{
    Do ##class(%UnitTest.Manager).RunTest("UnitTest/dc/irisflow/", "/nodelete")
}

Method OnBeforeOneTest(testname As %String) As %Status
{
    Set ..mapper = ##class(dc.irisflow.FlowMapper).%New()
    Return $$$OK
}

Method OnAfterOneTest(testname As %String) As %Status
{
    Set mapper = ..mapper
    Kill mapper
    Return $$$OK
}

Method TestMapping1()
{
    Set flow = {
        "name": "Helloworld",
        "nodes": [{
            "name": "FromFile",
            "type": "action",
            "config": {
                "className": "EnsLib.File.PassthroughService"
            },
            "targets": [{
                "name": "ToFile"
            }]
        },{
            "name": "ToFile",
            "type": "action",
            "config": {
                "className": "EnsLib.File.PassthroughOperation"
            },
            "targets": []
        }]
    }

    Set expected = {
        "production": {
            "name": "Helloworld"
        },
        "bs": [{
            "name": "FromFile",
            "config": {
                "className": "EnsLib.File.PassthroughService"
            }
        }],
        "bp": [{
            "name": "DefaultFlowBP",
            "config": {
                "sequence": [{
                    "type": "call",
                    "target": {
                        "name":"ToFile"
                    }
                }]
            }
        }],
        "bo": [{
            "name": "ToFile",
            "config": {
                "className": "EnsLib.File.PassthroughOperation"
            }
        }]
    }

    Set mapped = ..mapper.Map(flow)
    Do $$$AssertEquals(mapped.%ToJSON(), expected.%ToJSON())
}

Method TestGetProduction()
{
    Set flow = {
        "name": "Helloworld"
    }
    Set expected = ..mapper.CreateMappedTemplate()
    Set expected.production.name = flow.name

    Set ..mapper.flow = flow
    Do ..mapper.GetProduction()

    Set mapped = ..mapper.mapped
    Do $$$AssertEquals(mapped.%ToJSON(), expected.%ToJSON())
}

Method TestGetProductionFail()
{
    Set flow = {}
    Set expected = [(..mapper.CreateNoProductionDefinedError())]
    Set ..mapper.flow = flow
    Do ..mapper.GetProduction()
    Set errors = ..mapper.errors
    Do $$$AssertEquals(errors.%ToJSON(), expected.%ToJSON())
    Do $$$AssertEquals(errors.%Size(), 1)
}

Method TestIsBusinessService()
{
    Set flow = {
        "nodes": [{
            "name": "FromFile",
            "type": "action",
            "config": {
                "className": "EnsLib.File.PassthroughService"
            },
            "targets": [{
                "name": "ToFile"
            }]
        },{
            "name": "ToFile",
            "type": "action",
            "config": {
                "className": "EnsLib.File.PassthroughOperation"
            },
            "targets": []
        }]
    }
    Do $$$AssertTrue(..mapper.IsBusinessService(flow.nodes.%Get(0)))
    Do $$$AssertNotTrue(..mapper.IsBusinessService(flow.nodes.%Get(1)))
}

Method TestIsBusinessOperation()
{
    Set flow = {
        "nodes": [{
            "name": "FromFile",
            "type": "action",
            "config": {
                "className": "EnsLib.File.PassthroughService"
            },
            "targets": [{
                "name": "ToFile"
            }]
        },{
            "name": "ToFile",
            "type": "action",
            "config": {
                "className": "EnsLib.File.PassthroughOperation"
            },
            "targets": []
        }]
    }
    Do $$$AssertTrue(..mapper.IsBusinessOperation(flow.nodes.%Get(1)))
    Do $$$AssertNotTrue(..mapper.IsBusinessOperation(flow.nodes.%Get(0)))
}

Method TestCreateBusinessService()
{
    Set node = {
        "name": "FromFile",
        "type": "action",
        "config": {
            "className": "EnsLib.File.PassthroughService"
        },
        "targets": [{
            "name": "ToFile"
        }]
    }
    Set expected = {
        "name": "FromFile",
        "config": {
            "className": "EnsLib.File.PassthroughService"
        }
    }

    Set mapped = ..mapper.CreateBusinessService(node, 0)
    Do $$$AssertEquals(mapped.%ToJSON(), expected.%ToJSON())
}

Method TestCreateBusinessServiceFail()
{
    Set node = {}
    Set expected = [
        (..mapper.CreateNoNamedActionError(0)),
        (..mapper.CreateNoConfigActionError(0))
    ]
    Set mapped = ..mapper.CreateBusinessService(node, 0)
    Set errors = ..mapper.errors
    Do $$$AssertEquals(mapped.%ToJSON(), {}.%ToJSON())
    Do $$$AssertEquals(errors.%ToJSON(), expected.%ToJSON())
    Do $$$AssertEquals(errors.%Size(), 2)
}

Method TestCreateBusinessOperation()
{
    Set node = {
        "name": "ToFile",
        "type": "action",
        "config": {
            "className": "EnsLib.File.PassthroughOperation"
        },
        "targets": []
    }
    Set expected = {
        "name": "ToFile",
        "config": {
            "className": "EnsLib.File.PassthroughOperation"
        }
    }

    Set mapped = ..mapper.CreateBusinessOperation(node, 0)
    Do $$$AssertEquals(mapped.%ToJSON(), expected.%ToJSON())
}

Method TestCreateBusinessOperationFail()
{
    Set node = {}
    Set expected = [
        (..mapper.CreateNoNamedActionError(0)),
        (..mapper.CreateNoConfigActionError(0))
    ]
    Set mapped = ..mapper.CreateBusinessOperation(node, 0)
    Set errors = ..mapper.errors
    Do $$$AssertEquals(mapped.%ToJSON(), {}.%ToJSON())
    Do $$$AssertEquals(errors.%ToJSON(), expected.%ToJSON())
    Do $$$AssertEquals(errors.%Size(), 2)
}

Method TestProcessNodeTargets()
{
    Set node = {
        "name": "FromFile",
        "type": "action",
        "config": {
            "className": "EnsLib.File.PassthroughService"
        },
        "targets": [{
            "name": "ToFile"
        }]
    }
    Set expected = [{
        "name": "DefaultFlowBP",
        "config": {
            "sequence": [{
                "type": "call",
                "target": {
                    "name":"ToFile"
                }
            }]
        }
    }]

    Do ..mapper.ProcessBPL(node)
    Set mapped = ..mapper.mapped.bp
    Do $$$AssertEquals(mapped.%ToJSON(), expected.%ToJSON())
}

}
