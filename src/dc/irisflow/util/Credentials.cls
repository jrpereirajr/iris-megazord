Class dc.irisflow.util.Credentials
{

ClassMethod GetCredentials(pCredentialsKey As %String) As %String
{
    $$$TOE(st, ##class(Ens.Config.Credentials).GetCredentialsObj(.apiKeyCredObj, "", "Ens.Config.Credentials", pCredentialsKey))
    Return apiKeyCredObj.Password
}

}
