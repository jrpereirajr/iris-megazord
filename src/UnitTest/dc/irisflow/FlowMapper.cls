Class UnitTest.dc.irisflow.FlowMapper Extends %UnitTest.TestCase
{

Property mapper As dc.irisflow.FlowMapper;

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
    Set expected = [(..mapper.errorHelper.CreateNoProductionDefinedError())]
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
                "className": "dc.irisflow.components.file.FilePassthroughService"
            },
            "targets": [{
                "name": "ToFile"
            }]
        },{
            "name": "ToFile",
            "type": "action",
            "config": {
                "className": "dc.irisflow.components.file.FilePassthroughOperation"
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
                "className": "dc.irisflow.components.file.FilePassthroughService"
            },
            "targets": [{
                "name": "ToFile"
            }]
        },{
            "name": "ToFile",
            "type": "action",
            "config": {
                "className": "dc.irisflow.components.file.FilePassthroughOperation"
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
            "className": "dc.irisflow.components.file.FilePassthroughService"
        },
        "targets": [{
            "name": "ToFile"
        }]
    }
    Set expected = {
        "name": "FromFile",
        "className": "dc.irisflow.components.file.FilePassthroughService",
        "config": [],
        "targets": [{
            "name": "ToFile"
        }]
    }

    Set mapped = ..mapper.CreateBusinessService(node, 0)
    Do $$$AssertEquals(mapped.%ToJSON(), expected.%ToJSON())
}

Method TestCreateBusinessServiceFail()
{
    Set node = {}
    Set expected = [
        (..mapper.errorHelper.CreateNoNamedActionError(0)),
        (..mapper.errorHelper.CreateNoConfigActionError(0))
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
            "className": "dc.irisflow.components.file.FilePassthroughOperation"
        },
        "targets": []
    }
    Set expected = {
        "name": "ToFile",
        "className": "dc.irisflow.components.file.FilePassthroughOperation",
        "config": [],
        "targets": []
    }

    Set mapped = ..mapper.CreateBusinessOperation(node, 0)
    Do $$$AssertEquals(mapped.%ToJSON(), expected.%ToJSON())
}

Method TestCreateBusinessOperationFail()
{
    Set node = {}
    Set expected = [
        (..mapper.errorHelper.CreateNoNamedActionError(0)),
        (..mapper.errorHelper.CreateNoConfigActionError(0))
    ]
    Set mapped = ..mapper.CreateBusinessOperation(node, 0)
    Set errors = ..mapper.errors
    Do $$$AssertEquals(mapped.%ToJSON(), {}.%ToJSON())
    Do $$$AssertEquals(errors.%ToJSON(), expected.%ToJSON())
    Do $$$AssertEquals(errors.%Size(), 2)
}

/* BPL support will be redesigned */

/*
Method TestProcessNodeTargets()
{
    Set node = {
        "name": "FromFile",
        "type": "action",
        "config": {
            "className": "dc.irisflow.components.file.FilePassthroughService"
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
*/
Method TestMappingHelloworld1()
{
    Set flow = {
        "name": "Helloworld1",
        "nodes": [{
            "name": "FromFile",
            "type": "action",
            "config": {
                "className": "dc.irisflow.components.file.FilePassthroughService",
                "FilePath": "/tmp/test/in"
            },
            "targets": [{
                "name": "ToFile"
            }]
        },{
            "name": "ToFile",
            "type": "action",
            "config": {
                "className": "dc.irisflow.components.file.FilePassthroughOperation",
                "FilePath": "/tmp/test/out"
            },
            "targets": []
        }]
    }

    Set expected = {
        "production": {
            "name": "Helloworld1"
        },
        "bs": [{
            "name": "FromFile",
            "className": "dc.irisflow.components.file.FilePassthroughService",
            "config": [{
                "name": "FilePath",
                "value": "/tmp/test/in"
            }],
            "targets": [{
                "name": "ToFile"
            }]
        }],
        "bp":[],
        "bo": [{
            "name": "ToFile",
            "className": "dc.irisflow.components.file.FilePassthroughOperation",
            "config": [{
                "name": "FilePath",
                "value": "/tmp/test/out"
            }],
            "targets": []
        }]
    }

    Set mapped = ..mapper.Map(flow)
    Do $$$AssertEquals(mapped.%ToJSON(), expected.%ToJSON())
}

Method TestMappingHelloworld7()
{
    Set flow = {
        "name": "Helloworld7",
        "nodes": [{
            "name": "FromTelegram",
            "type": "action",
            "config": {
                "className": "dc.irisflow.components.telegram.TelegramService",
                "SSLConfiguration": "ISC.FeatureTracker.SSL.Config",
                "Credentials": "telegram"
            },
            "targets": [{
                "name": "SimpleEchoOperation"
            }]
        },{
            "name": "SimpleEchoOperation",
            "type": "action",
            "config": {
                "className": "dc.irisflow.components.misc.SimpleEchoOperation"
            },
            "targets": [{
                "name": "ToTelegram"
            }]
        },{
            "name": "ToTelegram",
            "type": "action",
            "config": {
                "className": "dc.irisflow.components.telegram.TelegramOperation",
                "SSLConfiguration": "ISC.FeatureTracker.SSL.Config",
                "Credentials": "telegram"
            },
            "targets": [{
                "name": "ToFile"
            }]
        },{
            "name": "ToFile",
            "type": "action",
            "config": {
                "className": "dc.irisflow.components.file.FilePassthroughOperation",
                "FilePath": "/tmp/test/out"
            },
            "targets": []
        }]
    }

    Set expected = {
        "production": {
            "name": "Helloworld7"
        },
        "bs": [{
            "name": "FromTelegram",
            "className": "dc.irisflow.components.telegram.TelegramService",
            "config": [{
                "name": "SSLConfiguration",
                "value": "ISC.FeatureTracker.SSL.Config"
            },{
                "name": "Credentials",
                "value": "telegram"
            }],
            "targets": [{
                "name": "SimpleEchoOperation"
            }]
        }],
        "bp": [],
        "bo": [{
            "name": "SimpleEchoOperation",
            "className": "dc.irisflow.components.misc.SimpleEchoOperation",
            "config": [],
            "targets": [{
                "name": "ToTelegram"
            }]
        },{
            "name": "ToTelegram",
            "className": "dc.irisflow.components.telegram.TelegramOperation",
            "config": [{
                "name": "SSLConfiguration",
                "value": "ISC.FeatureTracker.SSL.Config"
            },{
                "name": "Credentials",
                "value": "telegram"
            }],
            "targets": [{
                "name": "ToFile"
            }]
        },{
            "name": "ToFile",
            "className": "dc.irisflow.components.file.FilePassthroughOperation",
            "config": [{
                "name": "FilePath",
                "value": "/tmp/test/out"
            }],
            "targets": []
        }]
    }

    Set mapped = ..mapper.Map(flow)
    Do $$$AssertEquals(mapped.%ToJSON(), expected.%ToJSON())
}

}
