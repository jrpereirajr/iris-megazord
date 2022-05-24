Class UnitTest.dc.irisflow.FlowMapperHelloworld5 Extends %UnitTest.TestCase
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

Method TestMappingHelloworld5()
{
    Set flow = {
        "name": "Helloworld5",
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
            "targets": [{
                "name": "ToFile1"
            }]
        },{
            "name": "ToFile1",
            "type": "action",
            "config": {
                "className": "dc.irisflow.components.file.FilePassthroughOperation",
                "FilePath": "/tmp/test/out"
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
                "Credentials": "telegram",
                "ChatId": "telegram-chat-id"
            },
            "targets": []
        }]
    }

    Set expected = {
        "production": {
            "name": "Helloworld5"
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
        "bp": [],
        "bo": [{
            "name": "ToFile",
            "className": "dc.irisflow.components.file.FilePassthroughOperation",
            "config": [{
                "name": "FilePath",
                "value": "/tmp/test/out"
            }],
            "targets": [{
                "name": "ToFile1"
            }]
        },{
            "name": "ToFile1",
            "className": "dc.irisflow.components.file.FilePassthroughOperation",
            "config": [{
                "name": "FilePath",
                "value": "/tmp/test/out"
            }],
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
            },{
                "name": "ChatId",
                "value": "telegram-chat-id"
            }],
            "targets": []
        }]
    }

    Set mapped = ..mapper.Map(flow)
    Do $$$AssertEquals(mapped.%ToJSON(), expected.%ToJSON())
}

}
