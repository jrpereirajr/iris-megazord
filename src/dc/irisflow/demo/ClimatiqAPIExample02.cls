Class dc.irisflow.demo.ClimatiqAPIExample02 Extends %RegisteredObject
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
        "name":"User.ClimatiqAPIExample02",
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
                    "name":"ChatbotDecisionTree"
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
                "name":"CallClimatiqAPI",
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
                "name":"ChatbotDecisionTree",
                "config":{
                    "className":"dc.irisflow.components.misc.ObjectScriptOperation",
                    "Expression":"Return ##class(dc.irisflow.demo.ClimatiqAPIExample02Utils).ChatbotDecisionTree(input, context)",
                    "ContextExpression":"Return ##class(dc.irisflow.demo.ClimatiqAPIExample02Utils).ChatbotDecisionTreeContext(input, context)"
                },
                "targets":[
                    {
                    "name":"HandleUserInteration"
                    },
                    {
                    "name":"HandleClimatiqApiCalls"
                    }
                ]
            },
            {
                "type":"action",
                "name":"FormatResponse",
                "config":{
                    "className":"dc.irisflow.components.misc.ObjectScriptOperation",
                    "Expression":"Return ##class(dc.irisflow.demo.ClimatiqAPIExample02Utils).FormatResponse(input, context)",
                    "ContextExpression":"Return ##class(dc.irisflow.demo.ClimatiqAPIExample02Utils).FormatResponseContext(input, context)"
                },
                "targets":[
                    {
                    "name":"SendToTelegram"
                    }
                ]
            },
            {
                "type":"action",
                "name":"HandleUserInteration",
                "config":{
                    "className":"dc.irisflow.components.misc.ObjectScriptOperation",
                    "Expression":"Return ##class(dc.irisflow.demo.ClimatiqAPIExample02Utils).HandleUserInteration(input, context)",
                    "ContextExpression":"Return ##class(dc.irisflow.demo.ClimatiqAPIExample02Utils).HandleUserInterationContext(input, context)"
                },
                "targets":[
                    {
                    "name":"SendToTelegram"
                    }
                ]
            },
            {
                "type":"action",
                "name":"HandleClimatiqApiCalls",
                "config":{
                    "className":"dc.irisflow.components.misc.ObjectScriptOperation",
                    "Expression":"Return ##class(dc.irisflow.demo.ClimatiqAPIExample02Utils).HandleClimatiqApiCalls(input, context)",
                    "ContextExpression":"Return ##class(dc.irisflow.demo.ClimatiqAPIExample02Utils).HandleClimatiqApiCallsContext(input, context)"
                },
                "targets":[
                    {
                    "name":"CallClimatiqAPI"
                    }
                ]
            }
        ]
    }
}

Method GetDiagramDef() As %DynamicObject
{
    Return {
        "name":"User.ClimatiqAPIExample02",
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
                                }
                                ]
                            }
                        },
                        "pos_x":-338.42857142857144,
                        "pos_y":167.42857142857142
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
                        "html":"<div id=\"divHtmlNode_ClimatiqOperation8\"><div class=\"title-box\"><i class=\"fas fa-cog\" style=\"margin-right:5px\"></i><input type=\"text\" id=\"ClimatiqOperation8\" value=\"CallClimatiqAPI\" oninput=\"this.setAttribute('value', this.value)\"></div><div class=\"box\"><label class=\"col-form-label\" for=\"className\">className\n                </label>\n                <input type=\"text\" class=\"form-control input-sm\" id=\"className\" placeholder=\"className\" value=\"dc.irisflow.components.climatiq.ClimatiqOperation\" oninput=\"this.setAttribute('value', this.value)\"><label class=\"col-form-label\" for=\"SSLConfig\">SSLConfig\n                </label>\n                <input type=\"text\" class=\"form-control input-sm\" id=\"SSLConfig\" placeholder=\"SSLConfig\" value=\"ISC.FeatureTracker.SSL.Config\" oninput=\"this.setAttribute('value', this.value)\"><label class=\"col-form-label\" for=\"ApiKeyCred\">ApiKeyCred\n                </label>\n                <input type=\"text\" class=\"form-control input-sm\" id=\"ApiKeyCred\" placeholder=\"ApiKeyCred\" value=\"climatiq-api-key\" oninput=\"this.setAttribute('value', this.value)\"><label class=\"col-form-label\" for=\"ApiVersion\">ApiVersion\n                </label>\n                <input type=\"text\" class=\"form-control input-sm\" id=\"ApiVersion\" placeholder=\"ApiVersion\" value=\"beta3\" oninput=\"this.setAttribute('value', this.value)\"></div></div>",
                        "typenode":false,
                        "inputs":{
                            "input_1":{
                                "connections":[
                                {
                                    "node":"12",
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
                        "html":"<div id=\"divHtmlNode_ObjectScriptOperation9\"><div class=\"title-box\"><i class=\"fas fa-cog\" style=\"margin-right:5px\"></i><input type=\"text\" id=\"ObjectScriptOperation9\" value=\"ChatbotDecisionTree\" oninput=\"this.setAttribute('value', this.value)\"></div><div class=\"box\"><label class=\"col-form-label\" for=\"className\">className\n                </label>\n                <input type=\"text\" class=\"form-control input-sm\" id=\"className\" placeholder=\"className\" value=\"dc.irisflow.components.misc.ObjectScriptOperation\" oninput=\"this.setAttribute('value', this.value)\"><label class=\"col-form-label\" for=\"Expression\">Expression\n                </label>\n                <input type=\"text\" class=\"form-control input-sm\" id=\"Expression\" placeholder=\"Expression\" value=\"Return ##class(dc.irisflow.demo.ClimatiqAPIExample02Utils).ChatbotDecisionTree(input, context)\" oninput=\"this.setAttribute('value', this.value)\"><label class=\"col-form-label\" for=\"ContextExpression\">ContextExpression\n                </label>\n                <input type=\"text\" class=\"form-control input-sm\" id=\"ContextExpression\" placeholder=\"ContextExpression\" value=\"Return ##class(dc.irisflow.demo.ClimatiqAPIExample02Utils).ChatbotDecisionTreeContext(input, context)\" oninput=\"this.setAttribute('value', this.value)\"></div></div>",
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
                                    "node":"11",
                                    "output":"input_1"
                                },
                                {
                                    "node":"12",
                                    "output":"input_1"
                                }
                                ]
                            }
                        },
                        "pos_x":-88,
                        "pos_y":164.57142857142858
                    },
                    "10":{
                        "id":10,
                        "name":"ObjectScriptOperation",
                        "data":{
                            
                        },
                        "class":"ObjectScriptOperation",
                        "html":"<div id=\"divHtmlNode_ObjectScriptOperation10\"><div class=\"title-box\"><i class=\"fas fa-cog\" style=\"margin-right:5px\"></i><input type=\"text\" id=\"ObjectScriptOperation10\" value=\"FormatResponse\" oninput=\"this.setAttribute('value', this.value)\"></div><div class=\"box\"><label class=\"col-form-label\" for=\"className\">className\n                </label>\n                <input type=\"text\" class=\"form-control input-sm\" id=\"className\" placeholder=\"className\" value=\"dc.irisflow.components.misc.ObjectScriptOperation\" oninput=\"this.setAttribute('value', this.value)\"><label class=\"col-form-label\" for=\"Expression\">Expression\n                </label>\n                <input type=\"text\" class=\"form-control input-sm\" id=\"Expression\" placeholder=\"Expression\" value=\"Return ##class(dc.irisflow.demo.ClimatiqAPIExample02Utils).FormatResponse(input, context)\" oninput=\"this.setAttribute('value', this.value)\"><label class=\"col-form-label\" for=\"ContextExpression\">ContextExpression\n                </label>\n                <input type=\"text\" class=\"form-control input-sm\" id=\"ContextExpression\" placeholder=\"ContextExpression\" value=\"Return ##class(dc.irisflow.demo.ClimatiqAPIExample02Utils).FormatResponseContext(input, context)\" oninput=\"this.setAttribute('value', this.value)\"></div></div>",
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
                        "pos_x":660.5714285714286,
                        "pos_y":88
                    },
                    "11":{
                        "id":11,
                        "name":"ObjectScriptOperation",
                        "data":{
                            
                        },
                        "class":"ObjectScriptOperation",
                        "html":"<div id=\"divHtmlNode_ObjectScriptOperation11\"><div class=\"title-box\"><i class=\"fas fa-cog\" style=\"margin-right:5px\"></i><input type=\"text\" id=\"ObjectScriptOperation11\" value=\"HandleUserInteration\" oninput=\"this.setAttribute('value', this.value)\"></div><div class=\"box\"><label class=\"col-form-label\" for=\"className\">className\n                </label>\n                <input type=\"text\" class=\"form-control input-sm\" id=\"className\" placeholder=\"className\" value=\"dc.irisflow.components.misc.ObjectScriptOperation\" oninput=\"this.setAttribute('value', this.value)\"><label class=\"col-form-label\" for=\"Expression\">Expression\n                </label>\n                <input type=\"text\" class=\"form-control input-sm\" id=\"Expression\" placeholder=\"Expression\" value=\"Return ##class(dc.irisflow.demo.ClimatiqAPIExample02Utils).HandleUserInteration(input, context)\" oninput=\"this.setAttribute('value', this.value)\"><label class=\"col-form-label\" for=\"ContextExpression\">ContextExpression\n                </label>\n                <input type=\"text\" class=\"form-control input-sm\" id=\"ContextExpression\" placeholder=\"ContextExpression\" value=\"Return ##class(dc.irisflow.demo.ClimatiqAPIExample02Utils).HandleUserInterationContext(input, context)\" oninput=\"this.setAttribute('value', this.value)\"></div></div>",
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
                                    "node":"4",
                                    "output":"input_1"
                                }
                                ]
                            }
                        },
                        "pos_x":172.57142857142858,
                        "pos_y":377
                    },
                    "12":{
                        "id":12,
                        "name":"ObjectScriptOperation",
                        "data":{
                            
                        },
                        "class":"ObjectScriptOperation",
                        "html":"<div id=\"divHtmlNode_ObjectScriptOperation12\"><div class=\"title-box\"><i class=\"fas fa-cog\" style=\"margin-right:5px\"></i><input type=\"text\" id=\"ObjectScriptOperation12\" value=\"HandleClimatiqApiCalls\" oninput=\"this.setAttribute('value', this.value)\"></div><div class=\"box\"><label class=\"col-form-label\" for=\"className\">className\n                </label>\n                <input type=\"text\" class=\"form-control input-sm\" id=\"className\" placeholder=\"className\" value=\"dc.irisflow.components.misc.ObjectScriptOperation\" oninput=\"this.setAttribute('value', this.value)\"><label class=\"col-form-label\" for=\"Expression\">Expression\n                </label>\n                <input type=\"text\" class=\"form-control input-sm\" id=\"Expression\" placeholder=\"Expression\" value=\"Return ##class(dc.irisflow.demo.ClimatiqAPIExample02Utils).HandleClimatiqApiCalls(input, context)\" oninput=\"this.setAttribute('value', this.value)\"><label class=\"col-form-label\" for=\"ContextExpression\">ContextExpression\n                </label>\n                <input type=\"text\" class=\"form-control input-sm\" id=\"ContextExpression\" placeholder=\"ContextExpression\" value=\"Return ##class(dc.irisflow.demo.ClimatiqAPIExample02Utils).HandleClimatiqApiCallsContext(input, context)\" oninput=\"this.setAttribute('value', this.value)\"></div></div>",
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
                                    "node":"8",
                                    "output":"input_1"
                                }
                                ]
                            }
                        },
                        "pos_x":168.42857142857142,
                        "pos_y":71.57142857142857
                    }
                    }
                }
            }
        }
    }
}

}
