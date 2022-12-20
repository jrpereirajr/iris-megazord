Class dc.irisflow.rest.Dispatch Extends %CSP.REST
{

XData UrlMap [ XMLNamespace = "http://www.intersystems.com/urlmap" ]
{
<Routes>

<Route Url="/" Method="GET" Call="Test" Cors="true"/>
<Route Url="/components" Method="GET" Call="dc.irisflow.rest.Editor:ListAllComponents" Cors="true"/>
<Route Url="/production/:productionName" Method="GET" Call="dc.irisflow.rest.Editor:GetProduction" Cors="true"/>
<Route Url="/flow/generate" Method="POST" Call="dc.irisflow.rest.Editor:GenerateProduction" Cors="true"/>
<Route Url="/flow/save" Method="POST" Call="dc.irisflow.rest.Editor:SaveDiagram" Cors="true"/>
<Route Url="/flow/get/:diagramName" Method="GET" Call="dc.irisflow.rest.Editor:GetDiagram" Cors="true"/>
<Route Url="/message/:id" Method="GET" Call="dc.irismessageviewer.REST.Messages:getUnlimitedMessages" Cors="true"/>
<Route Url="/message/resend/" Method="POST" Call="dc.irismessageviewer.REST.Messages:ResendMessage" Cors="true"/>
<Route Url="/diagram" Method="POST" Call="dc.irismessageviewer.REST.Diagram:GetDiagram" Cors="true"/>
<Route Url="/diagram/message" Method="POST" Call="dc.irismessageviewer.REST.Diagram:GetMessageInfo" Cors="true"/>
<Route Url="/diagram/prev" Method="POST" Call="dc.irismessageviewer.REST.Diagram:GetPrevSession" Cors="true"/>
<Route Url="/diagram/next" Method="POST" Call="dc.irismessageviewer.REST.Diagram:GetNextSession" Cors="true"/>
<Route Url="/package" Method="GET" Call="dc.zpm.Utils:GetPackages" Cors="true"/>
<Route Url="/package" Method="POST" Call="dc.zpm.Utils:InstallPackage" Cors="true"/>
<Route Url="/package/delete" Method="POST" Call="UninstallSelectedPackages" Cors="true"/>
<Route Url="/installed" Method="GET" Call="dc.zpm.Utils:GetInstalledPackageAllNamespaces" Cors="true"/>
<Route Url="/namespace" Method="GET" Call="dc.zpm.Utils:getNamespaceList" Cors="true"/>
<Route Url="/export" Method="POST" Call="ExportDependencies" Cors="true"/>
<Route Url="/wordcloud" Method="GET" Call="dc.zpm.Charts:BuildWordCloudDatasource" Cors="true"/>
<Route Url="/sankey" Method="GET" Call="dc.zpm.Charts:BuildSankeyDataSource" Cors="true"/>
<Route Url="/oauth2" Method="GET" Call="OAuth2" Cors="true"/>

</Routes>
}

ClassMethod OAuth2() As %Status
{
	Set %response.ContentType = "application/json"
	Set retObj = {
		"issuer" : "https://iris-megazord.demo.community.intersystems.com/oauth2",
		"authorization_endpoint" : "https://iris-megazord.demo.community.intersystems.com/oauth2/authorize",
		"token_endpoint" : "https://iris-megazord.demo.community.intersystems.com/oauth2/token",
		"userinfo_endpoint" : "https://iris-megazord.demo.community.intersystems.com/oauth2/userinfo",
		"revocation_endpoint" : "https://iris-megazord.demo.community.intersystems.com/oauth2/revocation",
		"introspection_endpoint" : "https://iris-megazord.demo.community.intersystems.com/oauth2/introspection",
		"jwks_uri" : "https://iris-megazord.demo.community.intersystems.com/oauth2/jwks",
		"registration_endpoint" : "https://iris-megazord.demo.community.intersystems.com/oauth2/register",
		"end_session_endpoint" : "https://iris-megazord.demo.community.intersystems.com/oauth2/logout",
		"scopes_supported" : [ "openid", "profile", "email", "address", "phone", "all", "openid", "profile", "user" ],
		"response_types_supported" : [ "code" ],
		"response_modes_supported" : [ "query", "fragment", "form_post" ],
		"code_challenge_methods_supported" : [ "plain", "S256" ],
		"grant_types_supported" : [ "authorization_code", "client_credentials", "refresh_token" ],
		"subject_types_supported" : [ "public" ],
		"id_token_signing_alg_values_supported" : [ "HS256", "HS384", "HS512", "RS256", "RS384", "RS512", "ES256", "ES384", "ES512" ],
		"id_token_encryption_alg_values_supported" : [ "none", "RSA1_5", "RSA-OAEP", "A128KW", "A192KW", "A256KW", "dir" ],
		"id_token_encryption_enc_values_supported" : [ "none", "A128CBC-HS256", "A192CBC-HS384", "A256CBC-HS512" ],
		"userinfo_signing_alg_values_supported" : [ "none", "HS256", "HS384", "HS512", "RS256", "RS384", "RS512", "ES256", "ES384", "ES512" ],
		"userinfo_encryption_alg_values_supported" : [ "none", "RSA1_5", "RSA-OAEP", "A128KW", "A192KW", "A256KW", "dir" ],
		"userinfo_encryption_enc_values_supported" : [ "none", "A128CBC-HS256", "A192CBC-HS384", "A256CBC-HS512" ],
		"access_token_signing_alg_values_supported" : [ "none", "HS256", "HS384", "HS512", "RS256", "RS384", "RS512", "ES256", "ES384", "ES512" ],
		"access_token_encryption_alg_values_supported" : [ "none", "RSA1_5", "RSA-OAEP", "A128KW", "A192KW", "A256KW", "dir" ],
		"access_token_encryption_enc_values_supported" : [ "none", "A128CBC-HS256", "A192CBC-HS384", "A256CBC-HS512" ],
		"request_object_signing_alg_values_supported" : [ "none", "HS256", "HS384", "HS512", "RS256", "RS384", "RS512", "ES256", "ES384", "ES512" ],
		"request_object_encryption_alg_values_supported" : [ "none", "RSA1_5", "RSA-OAEP", "A128KW", "A192KW", "A256KW", "dir" ],
		"request_object_encryption_enc_values_supported" : [ "none", "A128CBC-HS256", "A192CBC-HS384", "A256CBC-HS512" ],
		"token_endpoint_auth_methods_supported" : [ "client_secret_post", "client_secret_basic", "client_secret_jwt", "private_key_jwt" ],
		"token_endpoint_auth_signing_alg_values_supported" : [ "HS256", "HS384", "HS512", "RS256", "RS384", "RS512", "ES256", "ES384", "ES512" ],
		"claims_supported" : [ "preferred_username", "email", "email_verified", "name", "phone_number", "phone_number_verified", "iss", "sub", "aud", "exp", "auth_time", "jti", "sid" ],
		"ui_locales_supported" : [ "de", "en", "en-gb", "en-us", "es", "fr", "it", "ja", "ko", "nl", "pt-br", "ru", "uk", "zh-cn" ],
		"claims_parameter_supported" : true,
		"request_parameter_supported" : true,
		"request_uri_parameter_supported" : true,
		"frontchannel_logout_supported" : true,
		"frontchannel_logout_session_supported" : true
	}
	Write retObj.%ToJSON()
	Quit $$$OK
}

ClassMethod Test() As %Status
{
	Set %response.ContentType = "application/json"
	Set retObj = { }
	Set retMessage = "Hello World!"
	Set retObj.Message = retMessage
	Write retObj.%ToJSON()
	Quit $$$OK
}

/// Description
ClassMethod ExportDependencies() As %Status
{
	Set sc = $$$OK
	Set obj = ##class(%DynamicAbstractObject).%FromJSON(%request.Content.Read())
	Set sc = ##class(dc.zpm.Utils).ExportDependecies(obj.dependencies)
	Return sc
}

/// Delete the packages selected in Installed Packages page
ClassMethod UninstallSelectedPackages() As %Status
{
	Set sc = $$$OK
	Set obj = ##class(%DynamicAbstractObject).%FromJSON(%request.Content.Read())
	Set sc = ##class(dc.zpm.Utils).UninstallPackage(obj.packages)
	Return sc
}

}
