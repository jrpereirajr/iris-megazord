/*
Author: Nikolay Soloviev
Repo: https://github.com/intersystems-community/TelegramAlerts
*/

/// ����� ��� ������ � API Telegram
Class Telegram.API Extends %RegisteredObject
{

Property Token As %String;

Parameter SERVER = "api.telegram.org";

Property SSLConfiguration As %String;

Method GetRequestObj() As %Net.HttpRequest [ Private ]
{
	#dim request as %Net.HttpRequest
	set request = ##class(%Net.HttpRequest).%New()
	set request.Server = ..#SERVER
	set request.SSLConfiguration = ..SSLConfiguration
	set request.Https = 1 
	return request
}

Method ExecuteRequest(request As %Net.HttpRequest, method As %String) As %DynamicObject [ Private ]
{
	set st = request.Post("bot"_..Token_"/"_method)
	if ($$$ISERR(st)) {
		throw ##class(%Exception.StatusException).CreateFromStatus(st)
	}
	return ##class(%Library.DynamicObject).%FromJSON(request.HttpResponse.Data)
}

Method %OnNew(token As %String, ssl As %String) As %Status [ Private ]
{
	return:(token="" || ssl="") 0
	set ..Token = token
	set ..SSLConfiguration = ssl
	return $$$OK
}

Method GetMe() As %DynamicObject
{
	return ..ExecuteRequest(..GetRequestObj(), "getMe")
}

Method GetUpdates(offset As %Integer = "", limit As %Integer = 100, timeout As %Integer = 0) As %DynamicObject
{
	#dim request as %Net.HttpRequest
	set request = ..GetRequestObj()
	if (offset'="") {
		do request.InsertFormData("offset",offset)
	}
	do request.InsertFormData("limit",limit)
	do request.InsertFormData("timeout",timeout)
	return ..ExecuteRequest(request, "getUpdates")
}

Method SendMessage(chatId As %Integer, text As %String, parseMode As %String = "", disableWebPagePreview As %Boolean = 0, disableNotification As %Boolean = 0, replyToMessageId As %Integer = 0, replyMarkup As %DynamicObject = 0) As %DynamicObject
{
	#dim request as %Net.HttpRequest
	set request = ..GetRequestObj()
	do request.InsertFormData("chat_id",chatId)
	do request.InsertFormData("text",text)
	if (replyMarkup'=0) {
		do request.InsertFormData("reply_markup",replyMarkup.%ToJSON())
	}
	return ..ExecuteRequest(request, "sendMessage")
}

/// First create instance of Telegram.API: 
///    set api = ##class(Telegram.API).%New(token, <ssl_configuration_name)
/// Set webhook with
///    write api.SetWebhook(url,certificate_folder, certificate_filename).%ToJSON()
Method SetWebhook(url As %String, filedir As %String, filename As %String) As %DynamicObject
{
	Set SentHttpRequest=..GetRequestObj()
	
	Set RootMIMEPart = ##class(%Net.MIMEPart).%New()
	
	Set BinaryMIMEPart = ##class(%Net.MIMEPart).%New()
    Set contentdisp = "form-data; name="_$CHAR(34)_"certificate"_$CHAR(34)_"; filename="
                    _$CHAR(34)_""_filename_""_$CHAR(34)
    Do BinaryMIMEPart.SetHeader("Content-Disposition",contentdisp)
    
    Set stream=##class(%FileBinaryStream).%New()
    Set stream.Filename=filedir_filename
    Do stream.LinkToFile(filedir_filename)
     
    Set BinaryMIMEPart.Body=stream
    Do BinaryMIMEPart.SetHeader("Content-Type","text/plain")   
     
    Do RootMIMEPart.Parts.Insert(BinaryMIMEPart)
    
    Set TextMIMEPart=##class(%Net.MIMEPart).%New()
    Set TextMIMEPart.Body=##class(%GlobalCharacterStream).%New()
    Do TextMIMEPart.Body.Write(url)
    
    Set contentdisp = "form-data; name="_$CHAR(34)_"url"_$CHAR(34)_";"
    Do TextMIMEPart.SetHeader("Content-Disposition",contentdisp)
    
    Do RootMIMEPart.Parts.Insert(TextMIMEPart)
    
    Set writer=##class(%Net.MIMEWriter).%New()
    
	$$$TOE(status, writer.OutputToStream(SentHttpRequest.EntityBody))
	$$$TOE(status, writer.WriteMIMEBody(RootMIMEPart))
       
     
	//do SentHttpRequest.InsertFormData("url",url)
	
	Set ContentType= "multipart/form-data; boundary="_RootMIMEPart.Boundary
    Set SentHttpRequest.ContentType=ContentType
    
    set st = SentHttpRequest.Post("bot"_..Token_"/setWebhook")
    

    return ##class(%Library.DynamicObject).%FromJSON(SentHttpRequest.HttpResponse.Data)
}

Method DeleteWebhook() As %DynamicObject
{
	return ..ExecuteRequest(..GetRequestObj(), "deleteWebhook")
}

Method GetWebhookInfo() As %DynamicObject
{
	return ..ExecuteRequest(..GetRequestObj(), "getWebhookInfo")
}

}
