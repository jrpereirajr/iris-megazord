Class dc.irisflow.demo.CarbonFootprintTelegramBot Extends %RegisteredObject
{

Property mapper As dc.irisflow.FlowMapper;

Property builder As dc.irisflow.ProductionBuilder;

ClassMethod Create()
{
    Set flow = ..%New()
    Set flowDef = flow.GetDefinition()
    Set production = flow.mapper.Map(flowDef)
    Do flow.builder.Build(production)
}

Method %OnNew() As %Status
{
    Set ..builder = ##class(dc.irisflow.ProductionBuilder).%New()
    Set ..mapper = ##class(dc.irisflow.FlowMapper).%New()
    Quit $$$OK
}

Method GetProdDefinition()
{
    Return {
        "name":"User.flow.demo.CarbonFootprintTelegramBotFlow",
        "nodes":[
            {
                "type":"action",
                "name":"ListenFromTelegram",
                "config":{
                    "className":"dc.irisflow.components.telegram.TelegramService",
                    "SSLConfiguration":"ISC.FeatureTracker.SSL.Config",
                    "Credentials":"telegram-api-key"
                },
                "targets":[
                    {
                    "name":"ProcessValidInput"
                    },
                    {
                    "name":"ProcessInvalidInput"
                    }
                ]
            },
            {
                "type":"action",
                "name":"ProcessValidInput",
                "config":{
                    "className":"dc.irisflow.components.misc.ObjectScriptOperation",
                    "Expression":"Return ##class(dc.irisflow.demo.CarbonFootprintTelegramBotUtils).ProcessValidInput(input)",
                    "ContextExpression":"Return ##class(dc.irisflow.demo.CarbonFootprintTelegramBotUtils).ProcessValidContext(input, context)"
                },
                "targets":[
                    {
                    "name":"GetCarbonFootprint"
                    }
                ]
            },
            {
                "type":"action",
                "name":"GetCarbonFootprint",
                "config":{
                    "className":"dc.irisflow.components.climatiq.ClimatiqOperation",
                    "SSLConfig":"ISC.FeatureTracker.SSL.Config",
                    "ApiKeyCred":"climatiq-api-key",
                    "ApiVersion":"beta3"
                },
                "targets":[
                    {
                    "name":"ProcessClimatiqResponse"
                    }
                ]
            },
            {
                "type":"action",
                "name":"ProcessClimatiqResponse",
                "config":{
                    "className":"dc.irisflow.components.misc.ObjectScriptOperation",
                    "Expression":"Return ##class(dc.irisflow.demo.CarbonFootprintTelegramBotUtils).ProcessClimatiqResponse(input)",
                    "ContextExpression":"Return ##class(dc.irisflow.demo.CarbonFootprintTelegramBotUtils).ProcessClimatiqResponseContext(input, context)"
                },
                "targets":[
                    {
                    "name":"SendResponseToTelegram"
                    }
                ]
            },
            {
                "type":"action",
                "name":"SendResponseToTelegram",
                "config":{
                    "className":"dc.irisflow.components.telegram.TelegramOperation",
                    "SSLConfiguration":"ISC.FeatureTracker.SSL.Config",
                    "Credentials":"telegram-api-key",
                    "ChatId":""
                }
            },
            {
                "type":"action",
                "name":"ProcessInvalidInput",
                "config":{
                    "className":"dc.irisflow.components.misc.ObjectScriptOperation",
                    "Expression":"Return ##class(dc.irisflow.demo.CarbonFootprintTelegramBotUtils).ProcessInvalidInput(input)",
                    "ContextExpression":"Return ##class(dc.irisflow.demo.CarbonFootprintTelegramBotUtils).ProcessInvalidContext(input, context)"
                },
                "targets":[
                    {
                    "name":"SendResponseToTelegram"
                    }
                ]
            }
        ]
        }
}

Method GetDiagramDef()
{
    Return {
        "name":"User.flow.demo.CarbonFootprintTelegramBotFlow",
        "def":{
            "drawflow":{
                "Home":{
                    "data":{
                    "2":{
                        "id":2,
                        "name":"FromTelegram",
                        "data":{
                            
                        },
                        "class":"FromTelegram",
                        "html":"<div id=\"divHtmlNode_FromTelegram2\"><div class=\"title-box\"><i class=\"fab fa-telegram\" style=\"margin-right:5px\"></i><input type=\"text\" id=\"FromTelegram2\" value=\"ListenFromTelegram\" oninput=\"this.setAttribute('value', this.value)\"></div><div class=\"box\"><label class=\"col-form-label\" for=\"className\">className\n                </label>\n                <input type=\"text\" class=\"form-control input-sm\" id=\"className\" placeholder=\"className\" value=\"dc.irisflow.components.telegram.TelegramService\" oninput=\"this.setAttribute('value', this.value)\"><label class=\"col-form-label\" for=\"SSLConfiguration\">SSLConfiguration\n                </label>\n                <input type=\"text\" class=\"form-control input-sm\" id=\"SSLConfiguration\" placeholder=\"SSLConfiguration\" value=\"ISC.FeatureTracker.SSL.Config\" oninput=\"this.setAttribute('value', this.value)\"><label class=\"col-form-label\" for=\"Credentials\">Credentials\n                </label>\n                <input type=\"text\" class=\"form-control input-sm\" id=\"Credentials\" placeholder=\"Credentials\" value=\"telegram-api-key\" oninput=\"this.setAttribute('value', this.value)\"></div></div>",
                        "typenode":false,
                        "inputs":{
                            
                        },
                        "outputs":{
                            "output_1":{
                                "connections":[
                                {
                                    "node":"3",
                                    "output":"input_1"
                                },
                                {
                                    "node":"7",
                                    "output":"input_1"
                                }
                                ]
                            }
                        },
                        "pos_x":-17.666666666666668,
                        "pos_y":225.33333333333334
                    },
                    "3":{
                        "id":3,
                        "name":"ObjectScriptOperation",
                        "data":{
                            
                        },
                        "class":"ObjectScriptOperation",
                        "html":"<div id=\"divHtmlNode_ObjectScriptOperation3\"><div class=\"title-box\"><i class=\"fas fa-cog\" style=\"margin-right:5px\"></i><input type=\"text\" id=\"ObjectScriptOperation3\" value=\"ProcessValidInput\" oninput=\"this.setAttribute('value', this.value)\"></div><div class=\"box\"><label class=\"col-form-label\" for=\"className\">className\n                </label>\n                <input type=\"text\" class=\"form-control input-sm\" id=\"className\" placeholder=\"className\" value=\"dc.irisflow.components.misc.ObjectScriptOperation\" oninput=\"this.setAttribute('value', this.value)\"><label class=\"col-form-label\" for=\"Expression\">Expression\n                </label>\n                <input type=\"text\" class=\"form-control input-sm\" id=\"Expression\" placeholder=\"Expression\" value=\"Return ##class(dc.irisflow.demo.CarbonFootprintTelegramBotUtils).ProcessValidInput(input)\" oninput=\"this.setAttribute('value', this.value)\"><label class=\"col-form-label\" for=\"ContextExpression\">ContextExpression\n                </label>\n                <input type=\"text\" class=\"form-control input-sm\" id=\"ContextExpression\" placeholder=\"ContextExpression\" value=\"Return ##class(dc.irisflow.demo.CarbonFootprintTelegramBotUtils).ProcessValidContext(input, context)\" oninput=\"this.setAttribute('value', this.value)\"></div></div>",
                        "typenode":false,
                        "inputs":{
                            "input_1":{
                                "connections":[
                                {
                                    "node":"2",
                                    "input":"output_1"
                                }
                                ]
                            }
                        },
                        "outputs":{
                            "output_1":{
                                "connections":[
                                {
                                    "node":"4",
                                    "output":"input_1"
                                }
                                ]
                            }
                        },
                        "pos_x":288.6666666666667,
                        "pos_y":80.66666666666667
                    },
                    "4":{
                        "id":4,
                        "name":"ClimatiqOperation",
                        "data":{
                            
                        },
                        "class":"ClimatiqOperation",
                        "html":"<div id=\"divHtmlNode_ClimatiqOperation4\"><div class=\"title-box\"><i class=\"fas fa-cog\" style=\"margin-right:5px\"></i><input type=\"text\" id=\"ClimatiqOperation4\" value=\"GetCarbonFootprint\" oninput=\"this.setAttribute('value', this.value)\"></div><div class=\"box\"><label class=\"col-form-label\" for=\"className\">className\n                </label>\n                <input type=\"text\" class=\"form-control input-sm\" id=\"className\" placeholder=\"className\" value=\"dc.irisflow.components.climatiq.ClimatiqOperation\" oninput=\"this.setAttribute('value', this.value)\"><label class=\"col-form-label\" for=\"SSLConfig\">SSLConfig\n                </label>\n                <input type=\"text\" class=\"form-control input-sm\" id=\"SSLConfig\" placeholder=\"SSLConfig\" value=\"ISC.FeatureTracker.SSL.Config\" oninput=\"this.setAttribute('value', this.value)\"><label class=\"col-form-label\" for=\"ApiKeyCred\">ApiKeyCred\n                </label>\n                <input type=\"text\" class=\"form-control input-sm\" id=\"ApiKeyCred\" placeholder=\"ApiKeyCred\" value=\"climatiq-api-key\" oninput=\"this.setAttribute('value', this.value)\"><label class=\"col-form-label\" for=\"ApiVersion\">ApiVersion\n                </label>\n                <input type=\"text\" class=\"form-control input-sm\" id=\"ApiVersion\" placeholder=\"ApiVersion\" value=\"beta3\" oninput=\"this.setAttribute('value', this.value)\"></div></div>",
                        "typenode":false,
                        "inputs":{
                            "input_1":{
                                "connections":[
                                {
                                    "node":"3",
                                    "input":"output_1"
                                }
                                ]
                            }
                        },
                        "outputs":{
                            "output_1":{
                                "connections":[
                                {
                                    "node":"5",
                                    "output":"input_1"
                                }
                                ]
                            }
                        },
                        "pos_x":556,
                        "pos_y":1.3333333333333337
                    },
                    "5":{
                        "id":5,
                        "name":"ObjectScriptOperation",
                        "data":{
                            
                        },
                        "class":"ObjectScriptOperation",
                        "html":"<div id=\"divHtmlNode_ObjectScriptOperation5\"><div class=\"title-box\"><i class=\"fas fa-cog\" style=\"margin-right:5px\"></i><input type=\"text\" id=\"ObjectScriptOperation5\" value=\"ProcessClimatiqResponse\" oninput=\"this.setAttribute('value', this.value)\"></div><div class=\"box\"><label class=\"col-form-label\" for=\"className\">className\n                </label>\n                <input type=\"text\" class=\"form-control input-sm\" id=\"className\" placeholder=\"className\" value=\"dc.irisflow.components.misc.ObjectScriptOperation\" oninput=\"this.setAttribute('value', this.value)\"><label class=\"col-form-label\" for=\"Expression\">Expression\n                </label>\n                <input type=\"text\" class=\"form-control input-sm\" id=\"Expression\" placeholder=\"Expression\" value=\"Return ##class(dc.irisflow.demo.CarbonFootprintTelegramBotUtils).ProcessClimatiqResponse(input)\" oninput=\"this.setAttribute('value', this.value)\"><label class=\"col-form-label\" for=\"ContextExpression\">ContextExpression\n                </label>\n                <input type=\"text\" class=\"form-control input-sm\" id=\"ContextExpression\" placeholder=\"ContextExpression\" value=\"Return ##class(dc.irisflow.demo.CarbonFootprintTelegramBotUtils).ProcessClimatiqResponseContext(input, context)\" oninput=\"this.setAttribute('value', this.value)\"></div></div>",
                        "typenode":false,
                        "inputs":{
                            "input_1":{
                                "connections":[
                                {
                                    "node":"4",
                                    "input":"output_1"
                                }
                                ]
                            }
                        },
                        "outputs":{
                            "output_1":{
                                "connections":[
                                {
                                    "node":"6",
                                    "output":"input_1"
                                }
                                ]
                            }
                        },
                        "pos_x":830,
                        "pos_y":76.33333333333333
                    },
                    "6":{
                        "id":6,
                        "name":"ToTelegram",
                        "data":{
                            
                        },
                        "class":"ToTelegram",
                        "html":"<div id=\"divHtmlNode_ToTelegram6\"><div class=\"title-box\"><i class=\"fab fa-telegram\" style=\"margin-right:5px\"></i><input type=\"text\" id=\"ToTelegram6\" value=\"SendResponseToTelegram\" oninput=\"this.setAttribute('value', this.value)\"></div><div class=\"box\"><label class=\"col-form-label\" for=\"className\">className\n                </label>\n                <input type=\"text\" class=\"form-control input-sm\" id=\"className\" placeholder=\"className\" value=\"dc.irisflow.components.telegram.TelegramOperation\" oninput=\"this.setAttribute('value', this.value)\"><label class=\"col-form-label\" for=\"SSLConfiguration\">SSLConfiguration\n                </label>\n                <input type=\"text\" class=\"form-control input-sm\" id=\"SSLConfiguration\" placeholder=\"SSLConfiguration\" value=\"ISC.FeatureTracker.SSL.Config\"><label class=\"col-form-label\" for=\"Credentials\">Credentials\n                </label>\n                <input type=\"text\" class=\"form-control input-sm\" id=\"Credentials\" placeholder=\"Credentials\" value=\"telegram-api-key\" oninput=\"this.setAttribute('value', this.value)\"><label class=\"col-form-label\" for=\"ChatId\">ChatId\n                </label>\n                <input type=\"text\" class=\"form-control input-sm\" id=\"ChatId\" placeholder=\"ChatId\" value=\"\" oninput=\"this.setAttribute('value', this.value)\"></div></div>",
                        "typenode":false,
                        "inputs":{
                            "input_1":{
                                "connections":[
                                {
                                    "node":"5",
                                    "input":"output_1"
                                },
                                {
                                    "node":"7",
                                    "input":"output_1"
                                }
                                ]
                            }
                        },
                        "outputs":{
                            
                        },
                        "pos_x":1115.5714285714287,
                        "pos_y":218
                    },
                    "7":{
                        "id":7,
                        "name":"ObjectScriptOperation",
                        "data":{
                            
                        },
                        "class":"ObjectScriptOperation",
                        "html":"<div id=\"divHtmlNode_ObjectScriptOperation7\"><div class=\"title-box\"><i class=\"fas fa-cog\" style=\"margin-right:5px\"></i><input type=\"text\" id=\"ObjectScriptOperation7\" value=\"ProcessInvalidInput\" oninput=\"this.setAttribute('value', this.value)\"></div><div class=\"box\"><label class=\"col-form-label\" for=\"className\">className\n                </label>\n                <input type=\"text\" class=\"form-control input-sm\" id=\"className\" placeholder=\"className\" value=\"dc.irisflow.components.misc.ObjectScriptOperation\" oninput=\"this.setAttribute('value', this.value)\"><label class=\"col-form-label\" for=\"Expression\">Expression\n                </label>\n                <input type=\"text\" class=\"form-control input-sm\" id=\"Expression\" placeholder=\"Expression\" value=\"Return ##class(dc.irisflow.demo.CarbonFootprintTelegramBotUtils).ProcessInvalidInput(input)\" oninput=\"this.setAttribute('value', this.value)\"><label class=\"col-form-label\" for=\"ContextExpression\">ContextExpression\n                </label>\n                <input type=\"text\" class=\"form-control input-sm\" id=\"ContextExpression\" placeholder=\"ContextExpression\" value=\"Return ##class(dc.irisflow.demo.CarbonFootprintTelegramBotUtils).ProcessInvalidContext(input, context)\" oninput=\"this.setAttribute('value', this.value)\"></div></div>",
                        "typenode":false,
                        "inputs":{
                            "input_1":{
                                "connections":[
                                {
                                    "node":"2",
                                    "input":"output_1"
                                }
                                ]
                            }
                        },
                        "outputs":{
                            "output_1":{
                                "connections":[
                                {
                                    "node":"6",
                                    "output":"input_1"
                                }
                                ]
                            }
                        },
                        "pos_x":277.3333333333333,
                        "pos_y":366
                    }
                    }
                }
            }
        }
    }
}

}
