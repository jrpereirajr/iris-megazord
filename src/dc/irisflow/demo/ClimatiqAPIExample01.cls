Class dc.irisflow.demo.ClimatiqAPIExample01 Extends %RegisteredObject
{

Property mapper As dc.irisflow.FlowMapper;

Property builder As dc.irisflow.ProductionBuilder;

ClassMethod Create()
{
    Set flow = ..%New()
    Set flowDef = flow.GetProdDefinition()
    Set production = flow.mapper.Map(flowDef)
    Do flow.builder.Build(production)

    Set diagram = flow.GetDiagramDef()
    Do ##class(dc.irisflow.util.Setup).SaveDiagram(diagram)
}

Method %OnNew() As %Status
{
    Set ..builder = ##class(dc.irisflow.ProductionBuilder).%New()
    Set ..mapper = ##class(dc.irisflow.FlowMapper).%New()
    Quit $$$OK
}

Method GetProdDefinition() As %DynamicObject
{
    Return {
        "name":"User.ClimatiqAPIExample01",
        "nodes":[
            {
                "type":"action",
                "name":"FromTelegram",
                "config":{
                    "className":"dc.irisflow.components.telegram.TelegramService",
                    "SSLConfiguration":"ISC.FeatureTracker.SSL.Config",
                    "Credentials":"telegram-api-key"
                },
                "targets":[
                    {
                    "name":"HandleValidInput"
                    },
                    {
                    "name":"HandleInvalidInput"
                    }
                ]
            },
            {
                "type":"action",
                "name":"SendToTelegram",
                "config":{
                    "className":"dc.irisflow.components.telegram.TelegramOperation",
                    "SSLConfiguration":"ISC.FeatureTracker.SSL.Config",
                    "Credentials":"telegram-api-key",
                    "ChatId":""
                }
            },
            {
                "type":"action",
                "name":"AskClimatiqAPI",
                "config":{
                    "className":"dc.irisflow.components.climatiq.ClimatiqOperation",
                    "SSLConfig":"ISC.FeatureTracker.SSL.Config",
                    "ApiKeyCred":"climatiq-api-key",
                    "ApiVersion":"beta3"
                },
                "targets":[
                    {
                    "name":"FormatResponse"
                    }
                ]
            },
            {
                "type":"action",
                "name":"HandleValidInput",
                "config":{
                    "className":"dc.irisflow.components.misc.ObjectScriptOperation",
                    "Expression":"Return ##class(dc.irisflow.demo.ClimatiqAPIExample01Utils).ProcessValidInput(input)",
                    "ContextExpression":"Return ##class(dc.irisflow.demo.ClimatiqAPIExample01Utils).ProcessValidContext(input, context)"
                },
                "targets":[
                    {
                    "name":"AskClimatiqAPI"
                    }
                ]
            },
            {
                "type":"action",
                "name":"FormatResponse",
                "config":{
                    "className":"dc.irisflow.components.misc.ObjectScriptOperation",
                    "Expression":"Return ##class(dc.irisflow.demo.ClimatiqAPIExample01Utils).ProcessClimatiqResponse(input, context)",
                    "ContextExpression":"Return ##class(dc.irisflow.demo.ClimatiqAPIExample01Utils).ProcessClimatiqResponseContext(input, context)"
                },
                "targets":[
                    {
                    "name":"SendToTelegram"
                    }
                ]
            },
            {
                "type":"action",
                "name":"HandleInvalidInput",
                "config":{
                    "className":"dc.irisflow.components.misc.ObjectScriptOperation",
                    "Expression":"Return ##class(dc.irisflow.demo.ClimatiqAPIExample01Utils).ProcessInvalidInput(input)",
                    "ContextExpression":"Return ##class(dc.irisflow.demo.ClimatiqAPIExample01Utils).ProcessInvalidContext(input, context)"
                },
                "targets":[
                    {
                    "name":"SendToTelegram"
                    }
                ]
            }
        ]
    }
}

Method GetDiagramDef() As %DynamicObject
{
    Return {
        "name":"User.ClimatiqAPIExample01",
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
                        "html":"<div id=\"divHtmlNode_FromTelegram2\"><div class=\"title-box\"><i class=\"fab fa-telegram\" style=\"margin-right:5px\"></i><input type=\"text\" id=\"FromTelegram2\" value=\"FromTelegram\" oninput=\"this.setAttribute('value', this.value)\"></div><div class=\"box\"><label class=\"col-form-label\" for=\"className\">className\n                </label>\n                <input type=\"text\" class=\"form-control input-sm\" id=\"className\" placeholder=\"className\" value=\"dc.irisflow.components.telegram.TelegramService\" oninput=\"this.setAttribute('value', this.value)\"><label class=\"col-form-label\" for=\"SSLConfiguration\">SSLConfiguration\n                </label>\n                <input type=\"text\" class=\"form-control input-sm\" id=\"SSLConfiguration\" placeholder=\"SSLConfiguration\" value=\"ISC.FeatureTracker.SSL.Config\" oninput=\"this.setAttribute('value', this.value)\"><label class=\"col-form-label\" for=\"Credentials\">Credentials\n                </label>\n                <input type=\"text\" class=\"form-control input-sm\" id=\"Credentials\" placeholder=\"Credentials\" value=\"telegram-api-key\" oninput=\"this.setAttribute('value', this.value)\"></div></div>",
                        "typenode":false,
                        "inputs":{
                            
                        },
                        "outputs":{
                            "output_1":{
                                "connections":[
                                {
                                    "node":"9",
                                    "output":"input_1"
                                },
                                {
                                    "node":"11",
                                    "output":"input_1"
                                }
                                ]
                            }
                        },
                        "pos_x":-85.14285714285714,
                        "pos_y":134
                    },
                    "4":{
                        "id":4,
                        "name":"ToTelegram",
                        "data":{
                            
                        },
                        "class":"ToTelegram",
                        "html":"<div id=\"divHtmlNode_ToTelegram4\"><div class=\"title-box\"><i class=\"fab fa-telegram\" style=\"margin-right:5px\"></i><input type=\"text\" id=\"ToTelegram4\" value=\"SendToTelegram\" oninput=\"this.setAttribute('value', this.value)\"></div><div class=\"box\"><label class=\"col-form-label\" for=\"className\">className\n                </label>\n                <input type=\"text\" class=\"form-control input-sm\" id=\"className\" placeholder=\"className\" value=\"dc.irisflow.components.telegram.TelegramOperation\" oninput=\"this.setAttribute('value', this.value)\"><label class=\"col-form-label\" for=\"SSLConfiguration\">SSLConfiguration\n                </label>\n                <input type=\"text\" class=\"form-control input-sm\" id=\"SSLConfiguration\" placeholder=\"SSLConfiguration\" value=\"ISC.FeatureTracker.SSL.Config\" oninput=\"this.setAttribute('value', this.value)\"><label class=\"col-form-label\" for=\"Credentials\">Credentials\n                </label>\n                <input type=\"text\" class=\"form-control input-sm\" id=\"Credentials\" placeholder=\"Credentials\" value=\"telegram-api-key\" oninput=\"this.setAttribute('value', this.value)\"><label class=\"col-form-label\" for=\"ChatId\">ChatId\n                </label>\n                <input type=\"text\" class=\"form-control input-sm\" id=\"ChatId\" placeholder=\"ChatId\" value=\"\" oninput=\"this.setAttribute('value', this.value)\"></div></div>",
                        "typenode":false,
                        "inputs":{
                            "input_1":{
                                "connections":[
                                {
                                    "node":"10",
                                    "input":"output_1"
                                },
                                {
                                    "node":"11",
                                    "input":"output_1"
                                }
                                ]
                            }
                        },
                        "outputs":{
                            
                        },
                        "pos_x":899.4285714285714,
                        "pos_y":257.42857142857144
                    },
                    "8":{
                        "id":8,
                        "name":"ClimatiqOperation",
                        "data":{
                            
                        },
                        "class":"ClimatiqOperation",
                        "html":"<div id=\"divHtmlNode_ClimatiqOperation8\"><div class=\"title-box\"><i class=\"fas fa-cog\" style=\"margin-right:5px\"></i><input type=\"text\" id=\"ClimatiqOperation8\" value=\"AskClimatiqAPI\" oninput=\"this.setAttribute('value', this.value)\"></div><div class=\"box\"><label class=\"col-form-label\" for=\"className\">className\n                </label>\n                <input type=\"text\" class=\"form-control input-sm\" id=\"className\" placeholder=\"className\" value=\"dc.irisflow.components.climatiq.ClimatiqOperation\" oninput=\"this.setAttribute('value', this.value)\"><label class=\"col-form-label\" for=\"SSLConfig\">SSLConfig\n                </label>\n                <input type=\"text\" class=\"form-control input-sm\" id=\"SSLConfig\" placeholder=\"SSLConfig\" value=\"ISC.FeatureTracker.SSL.Config\" oninput=\"this.setAttribute('value', this.value)\"><label class=\"col-form-label\" for=\"ApiKeyCred\">ApiKeyCred\n                </label>\n                <input type=\"text\" class=\"form-control input-sm\" id=\"ApiKeyCred\" placeholder=\"ApiKeyCred\" value=\"climatiq-api-key\" oninput=\"this.setAttribute('value', this.value)\"><label class=\"col-form-label\" for=\"ApiVersion\">ApiVersion\n                </label>\n                <input type=\"text\" class=\"form-control input-sm\" id=\"ApiVersion\" placeholder=\"ApiVersion\" value=\"beta3\" oninput=\"this.setAttribute('value', this.value)\"></div></div>",
                        "typenode":false,
                        "inputs":{
                            "input_1":{
                                "connections":[
                                {
                                    "node":"9",
                                    "input":"output_1"
                                }
                                ]
                            }
                        },
                        "outputs":{
                            "output_1":{
                                "connections":[
                                {
                                    "node":"10",
                                    "output":"input_1"
                                }
                                ]
                            }
                        },
                        "pos_x":415.75,
                        "pos_y":51
                    },
                    "9":{
                        "id":9,
                        "name":"ObjectScriptOperation",
                        "data":{
                            
                        },
                        "class":"ObjectScriptOperation",
                        "html":"<div id=\"divHtmlNode_ObjectScriptOperation9\"><div class=\"title-box\"><i class=\"fas fa-cog\" style=\"margin-right:5px\"></i><input type=\"text\" id=\"ObjectScriptOperation9\" value=\"HandleValidInput\" oninput=\"this.setAttribute('value', this.value)\"></div><div class=\"box\"><label class=\"col-form-label\" for=\"className\">className\n                </label>\n                <input type=\"text\" class=\"form-control input-sm\" id=\"className\" placeholder=\"className\" value=\"dc.irisflow.components.misc.ObjectScriptOperation\" oninput=\"this.setAttribute('value', this.value)\"><label class=\"col-form-label\" for=\"Expression\">Expression\n                </label>\n                <input type=\"text\" class=\"form-control input-sm\" id=\"Expression\" placeholder=\"Expression\" value=\"Return ##class(dc.irisflow.demo.ClimatiqAPIExample01Utils).ProcessValidInput(input)\" oninput=\"this.setAttribute('value', this.value)\"><label class=\"col-form-label\" for=\"ContextExpression\">ContextExpression\n                </label>\n                <input type=\"text\" class=\"form-control input-sm\" id=\"ContextExpression\" placeholder=\"ContextExpression\" value=\"Return ##class(dc.irisflow.demo.ClimatiqAPIExample01Utils).ProcessValidContext(input, context)\" oninput=\"this.setAttribute('value', this.value)\"></div></div>",
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
                                    "node":"8",
                                    "output":"input_1"
                                }
                                ]
                            }
                        },
                        "pos_x":170.75,
                        "pos_y":41
                    },
                    "10":{
                        "id":10,
                        "name":"ObjectScriptOperation",
                        "data":{
                            
                        },
                        "class":"ObjectScriptOperation",
                        "html":"<div id=\"divHtmlNode_ObjectScriptOperation10\"><div class=\"title-box\"><i class=\"fas fa-cog\" style=\"margin-right:5px\"></i><input type=\"text\" id=\"ObjectScriptOperation10\" value=\"FormatResponse\" oninput=\"this.setAttribute('value', this.value)\"></div><div class=\"box\"><label class=\"col-form-label\" for=\"className\">className\n                </label>\n                <input type=\"text\" class=\"form-control input-sm\" id=\"className\" placeholder=\"className\" value=\"dc.irisflow.components.misc.ObjectScriptOperation\" oninput=\"this.setAttribute('value', this.value)\"><label class=\"col-form-label\" for=\"Expression\">Expression\n                </label>\n                <input type=\"text\" class=\"form-control input-sm\" id=\"Expression\" placeholder=\"Expression\" value=\"Return ##class(dc.irisflow.demo.ClimatiqAPIExample01Utils).ProcessClimatiqResponse(input, context)\" oninput=\"this.setAttribute('value', this.value)\"><label class=\"col-form-label\" for=\"ContextExpression\">ContextExpression\n                </label>\n                <input type=\"text\" class=\"form-control input-sm\" id=\"ContextExpression\" placeholder=\"ContextExpression\" value=\"Return ##class(dc.irisflow.demo.ClimatiqAPIExample01Utils).ProcessClimatiqResponseContext(input, context)\" oninput=\"this.setAttribute('value', this.value)\"></div></div>",
                        "typenode":false,
                        "inputs":{
                            "input_1":{
                                "connections":[
                                {
                                    "node":"8",
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
                        "pos_x":652.4285714285714,
                        "pos_y":88
                    },
                    "11":{
                        "id":11,
                        "name":"ObjectScriptOperation",
                        "data":{
                            
                        },
                        "class":"ObjectScriptOperation",
                        "html":"<div id=\"divHtmlNode_ObjectScriptOperation11\"><div class=\"title-box\"><i class=\"fas fa-cog\" style=\"margin-right:5px\"></i><input type=\"text\" id=\"ObjectScriptOperation11\" value=\"HandleInvalidInput\" oninput=\"this.setAttribute('value', this.value)\"></div><div class=\"box\"><label class=\"col-form-label\" for=\"className\">className\n                </label>\n                <input type=\"text\" class=\"form-control input-sm\" id=\"className\" placeholder=\"className\" value=\"dc.irisflow.components.misc.ObjectScriptOperation\" oninput=\"this.setAttribute('value', this.value)\"><label class=\"col-form-label\" for=\"Expression\">Expression\n                </label>\n                <input type=\"text\" class=\"form-control input-sm\" id=\"Expression\" placeholder=\"Expression\" value=\"Return ##class(dc.irisflow.demo.ClimatiqAPIExample01Utils).ProcessInvalidInput(input)\" oninput=\"this.setAttribute('value', this.value)\"><label class=\"col-form-label\" for=\"ContextExpression\">ContextExpression\n                </label>\n                <input type=\"text\" class=\"form-control input-sm\" id=\"ContextExpression\" placeholder=\"ContextExpression\" value=\"Return ##class(dc.irisflow.demo.ClimatiqAPIExample01Utils).ProcessInvalidContext(input, context)\" oninput=\"this.setAttribute('value', this.value)\"></div></div>",
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
                        "pos_x":175.78125,
                        "pos_y":361.62500381469727
                    }
                    }
                }
            }
        }
    }
}

}
