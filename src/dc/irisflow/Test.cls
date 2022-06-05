Class dc.irisflow.Test Extends %RegisteredObject
{

ClassMethod CreateProductionHelloworld1() As %Status
{
    Set sc = $$$OK

    Set flow = {
        "name": "User.irisflow.simple.Helloworld1",
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

    Set mapper = ##class(dc.irisflow.FlowMapper).%New()
    Set config = mapper.Map(flow)

    Try{
        Do $system.OBJ.Delete(config.production.name, "/display=none")
    } Catch(e){}
    
    Set builder = ##class(dc.irisflow.ProductionBuilder).%New()
    Do builder.Build(config)

    Write "Production "_config.production.name_" created."

    Return sc
}

ClassMethod CreateProductionHelloworld2() As %Status
{
    Set sc = $$$OK

    Set flow = {
        "name": "User.irisflow.simple.Helloworld2",
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

    Set mapper = ##class(dc.irisflow.FlowMapper).%New()
    Set config = mapper.Map(flow)

    Try{
        Do $system.OBJ.Delete(config.production.name, "/display=none")
    } Catch(e){}
    
    Set builder = ##class(dc.irisflow.ProductionBuilder).%New()
    Do builder.Build(config)
    Write "Production "_config.production.name_" created."

    Return sc
}

ClassMethod CreateProductionHelloworld3() As %Status
{
    Set sc = $$$OK

    Set flow = {
        "name": "User.irisflow.simple.Helloworld3",
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
            "targets": []
        }]
    }

    Set mapper = ##class(dc.irisflow.FlowMapper).%New()
    Set config = mapper.Map(flow)

    Try{
        Do $system.OBJ.Delete(config.production.name, "/display=none")
    } Catch(e){}
    
    Set builder = ##class(dc.irisflow.ProductionBuilder).%New()
    Do builder.Build(config)
    Write "Production "_config.production.name_" created."

    Return sc
}

ClassMethod CreateProductionHelloworld4() As %Status
{
    Set sc = $$$OK

    Set flow = {
        "name": "User.irisflow.simple.Helloworld4",
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
            "name": "FromTelegram",
            "type": "action",
            "config": {
                "className": "dc.irisflow.components.telegram.TelegramService",
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
            "targets": []
        }]
    }

    Set mapper = ##class(dc.irisflow.FlowMapper).%New()
    Set config = mapper.Map(flow)

    Try{
        Do $system.OBJ.Delete(config.production.name, "/display=none")
    } Catch(e){}
    
    Set builder = ##class(dc.irisflow.ProductionBuilder).%New()
    Do builder.Build(config)
    Write "Production "_config.production.name_" created."

    Return sc
}

ClassMethod CreateProductionHelloworld5() As %Status
{
    Set sc = $$$OK

    Set flow = {
        "name": "User.irisflow.simple.Helloworld5",
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

    Set mapper = ##class(dc.irisflow.FlowMapper).%New()
    Set config = mapper.Map(flow)

    Try{
        Do $system.OBJ.Delete(config.production.name, "/display=none")
    } Catch(e){}
    
    Set builder = ##class(dc.irisflow.ProductionBuilder).%New()
    Do builder.Build(config)
    Write "Production "_config.production.name_" created."

    Return sc
}

ClassMethod CreateProductionHelloworld6() As %Status
{
    Set sc = $$$OK

    Set flow = {
        "name": "User.irisflow.simple.Helloworld6",
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

    Set mapper = ##class(dc.irisflow.FlowMapper).%New()
    Set config = mapper.Map(flow)

    Try{
        Do $system.OBJ.Delete(config.production.name, "/display=none")
    } Catch(e){}
    
    Set builder = ##class(dc.irisflow.ProductionBuilder).%New()
    Do builder.Build(config)
    Write "Production "_config.production.name_" created."

    Return sc
}

ClassMethod CreateProductionHelloworld7() As %Status
{
    Set sc = $$$OK
    Set flow = {
        "name": "User.irisflow.simple.Helloworld7",
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

    Set mapper = ##class(dc.irisflow.FlowMapper).%New()
    Set config = mapper.Map(flow)

    Try{
        Do $system.OBJ.Delete(config.production.name, "/display=none")
    } Catch(e){}
    
    Set builder = ##class(dc.irisflow.ProductionBuilder).%New()
    Do builder.Build(config)
    Write "Production "_config.production.name_" created."

    Return sc
}

ClassMethod CreateProductionHelloworld8() As %Status
{
    Set sc = $$$OK
    Set flow = {
        "name": "User.irisflow.simple.Helloworld8",
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
            "name": "FromEmail",
            "type": "action",
            "config": {
                "className": "dc.irisflow.components.email.POP3Service",
                "POP3Port": "995",
                "POP3Server": "pop.mail.yahoo.com",
                "Credentials": "imap-test",
                "SSLConfig": "ISC.FeatureTracker.SSL.Config"
            },
            "targets": [{
                "name": "ToTelegram"
            }]
        },{
            "name": "SimpleEchoOperation",
            "type": "action",
            "config": {
                "className": "dc.irisflow.components.misc.SimpleEchoOperation"
            },
            "targets": [{
                "name": "ToEmail"
            }]
        },{
            "name": "ToEmail",
            "type": "action",
            "config": {
                "className": "dc.irisflow.components.email.SMTPOperation",
                "SMTPPort": "465",
                "SMTPServer": "smtp.mail.yahoo.com",
                "Credentials": "imap-test",
                "SSLConfig": "ISC.FeatureTracker.SSL.Config"
            },
            "targets": []
        },{
            "name": "ToTelegram",
            "type": "action",
            "config": {
                "className": "dc.irisflow.components.telegram.TelegramOperation",
                "SSLConfiguration": "ISC.FeatureTracker.SSL.Config",
                "ChatId": "telegram-chat-id",
                "Credentials": "telegram"
            },
            "targets": []
        }]
    }

    Set mapper = ##class(dc.irisflow.FlowMapper).%New()
    Set config = mapper.Map(flow)

    Try{
        Do $system.OBJ.Delete(config.production.name, "/display=none")
    } Catch(e){}
    
    Set builder = ##class(dc.irisflow.ProductionBuilder).%New()
    Do builder.Build(config)
    Write "Production "_config.production.name_" created."

    Return sc
}

ClassMethod CreateProductionHelloworldBPL() As %Status
{
    Set sc = $$$OK

    Set config = {
        "production": {
            "name": "User.irisflow.bpl.HelloworldBPL"
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
            "className": "User.irisflow.bpl.DefaultFlowBP",
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

    Try{
        Do $system.OBJ.Delete("User.irisflow.bpl.*", "/display=none")
    } Catch(e){}
    
    Set builder = ##class(dc.irisflow.ProductionBuilder).%New()
    Do builder.Build(config)
    Write "Production "_config.production.name_" created."

    Return sc
}

ClassMethod TestFHIRaaS()
{
    #dim httprequest as %Net.HttpRequest
    #dim httpResponse as %DynamicObject
    Set deployId = "mrxfu71pjkah"
    Set server = "fhir."_deployId_".static-test-account.isccloud.io"
    Set sslconfig = "ISC.FeatureTracker.SSL.Config"
    Set apikey = ""
    Set headers = {
        "x-api-key" : (apikey)
    }
    
    Try {
        Set httprequest = ##class(%Net.HttpRequest).%New()
        Do httprequest.SSLConfigurationSet(sslconfig)
        Set httprequest.Https = 1
        Set httprequest.Server = server
        Set headersIt = headers.%GetIterator()
        While (headersIt.%GetNext(.headerName, .headerValue)) {
            Do httprequest.SetHeader(headerName, headerValue)
        }
        Set requestString = "/Patient?_count=2"
        $$$TOE(st, httprequest.Get(requestString))
        Set httpResponse = httprequest.HttpResponse
        If (httpResponse.StatusCode '=200) {
            $$$ThrowStatus($$$ERROR(5001, "HTTP StatusCode = "_httpResponse.StatusCode))
        }
        Set jo = {}.%FromJSON(httpResponse.Data)
        zw jo.entry.%Size()
        zw httpResponse
        #; w httpResponse.ReturnHeaders(),!
    } Catch ex {
        zw ex
        w ex.DisplayString(),!
    }
}

}
