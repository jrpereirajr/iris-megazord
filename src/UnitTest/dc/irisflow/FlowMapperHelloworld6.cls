Class UnitTest.dc.irisflow.FlowMapperHelloworld6 Extends %UnitTest.TestCase
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

Method TestMappingHelloworld6()
{
    Set flow = {
        "name": "Helloworld6",
        "nodes": [{
            "name": "FromTelegram",
            "type": "action",
            "config": {
                "className": "dc.irisflow.components.telegram.TelegramService",
                "SSLConfiguration": "ISC.FeatureTracker.SSL.Config",
                "Credentials": "telegram"
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
            "name": "Helloworld6"
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
                "name": "ToTelegram"
            }]
        }],
        "bp": [],
        "bo": [{
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
