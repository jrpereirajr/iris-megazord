Class UnitTest.dc.irisflow.FlowMapperHelloworld2 Extends %UnitTest.TestCase
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

Method TestMappingHelloworld3()
{
    Set flow = {
        "name": "Helloworld2",
        "nodes": [{
            "name": "FromFile",
            "type": "action",
            "config": {
                "className": "dc.irisflow.components.file.FilePassthroughService",
                "FilePath": "/tmp/test/in"
            },
            "targets": [{
                "name": "ToFile,ToFile1"
            }]
        },{
            "name": "ToFile",
            "type": "action",
            "config": {
                "className": "dc.irisflow.components.file.FilePassthroughOperation",
                "FilePath": "/tmp/test/out"
            },
            "targets": []
        },{
            "name": "ToFile1",
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
            "name": "Helloworld2"
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

    Set mapped = ..mapper.Map(flow)
    Do $$$AssertEquals(mapped.%ToJSON(), expected.%ToJSON())
}

}
