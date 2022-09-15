Class dc.irisflow.util.Setup
{

ClassMethod InitialComponents() As %Status
{
  Set tSC = $$$OK
	Try {
    Do ##class(dc.irisflow.data.Component).%KillExtent()
    $$$TOE(tSC, ..AddComponent("ToFile", "fas fa-file-signature", 1, 0, {"className": "dc.irisflow.components.file.FilePassthroughOperation"}))
    $$$TOE(tSC, ..AddComponent("ToTelegram","fab fa-telegram", 1, 0,{"className": "dc.irisflow.components.telegram.TelegramOperation","SSLConfiguration": "ISC.FeatureTracker.SSL.Config","Credentials": "telegram-api-key", "ChatId": ""}))
    $$$TOE(tSC, ..AddComponent("ToEmail","fas fa-envelope", 1, 0,{"className": "dc.irisflow.components.email.SMTPOperation","SSLConfig": "ISC.FeatureTracker.SSL.Config","Credentials": "imap-test", "SMTPPort": "465", "SMTPServer": "smtp.mail.yahoo.com"}))
    $$$TOE(tSC, ..AddComponent("FromFile", "fas fa-file-signature", 0, 1, {"className": "dc.irisflow.components.file.FilePassthroughService"}))
    $$$TOE(tSC, ..AddComponent("FromTelegram", "fab fa-telegram", 0, 1, {"className": "dc.irisflow.components.telegram.TelegramService","SSLConfiguration": "ISC.FeatureTracker.SSL.Config","Credentials": "telegram-api-key"}))
    $$$TOE(tSC, ..AddComponent("FromEmail(POP3)", "fas fa-envelope", 0, 1, {"className": "dc.irisflow.components.email.POP3Service","SSLConfig": "ISC.FeatureTracker.SSL.Config","Credentials": "imap-test", "POP3Port": "995", "POP3Server": "pop.mail.yahoo.com"}))
    $$$TOE(tSC, ..AddComponent("FromFHIRaaS", "fab fa-free-code-camp", 0, 1, {"className": "dc.irisflow.components.fhiraas.FHIRaaSService","SSLConfig": "ISC.FeatureTracker.SSL.Config", "Https": "1", "ApiKey": "fhiraas-api-key", "FHIRaaSDeploymentId": "", "FHIRResource": "Patient", "FHIRResourceId": "1431", "FHIRQueryString": ""}))
    $$$TOE(tSC, ..AddComponent("SimpleEchoOperation", "fas fa-cog", 1, 1, {"className": "dc.irisflow.components.misc.SimpleEchoOperation"}))
    $$$TOE(tSC, ..AddComponent("ObjectScriptOperation", "fas fa-cog", 1, 1, {"className": "dc.irisflow.components.misc.ObjectScriptOperation", "Expression": "", "ContextExpression": ""}))
    $$$TOE(tSC, ..AddComponent("ClimatiqOperation", "fas fa-cog", 1, 1, {"className": "dc.irisflow.components.climatiq.ClimatiqOperation", "SSLConfig": "ISC.FeatureTracker.SSL.Config", "ApiKeyCred": "climatiq-api-key", "ApiVersion": "beta3"}))
	} Catch tException {
		Set:$$$ISOK(tSC) tSC = tException.AsStatus()
	}
	Quit tSC
}

ClassMethod AddComponent(Name As %String, Icon As %String, In As %Integer, Out As %Integer, Fields As %DynamicObject) As %Status
{
  Set tSC = $$$OK
	Try {
    Set component = ##class(dc.irisflow.data.Component).%New()
    Set component.Name = Name
    Set component.Icon = Icon
    Set component.Input = In
    Set component.Output = Out
    Do component.Fields.Write(Fields.%ToJSON())
    TStart
    $$$TOE(tSC, component.%Save())
    TCommit
	} Catch tException {
    TRollback
		Set:$$$ISOK(tSC) tSC = tException.AsStatus()
	}
	Quit tSC
}

ClassMethod ChangePassword(pUserId As %String, pNewPassword As %String)
{
  Set ns = $NAMESPACE
  ZN "%SYS"
  Try {
    Set pUserId = $ZCONVERT(pUserId, "L")
    Set o = ##class(Security.Users).%OpenId(pUserId)
    Set o.PasswordExternal = pNewPassword
    $$$TOE(st, o.%Save())
    Write "Password changed for user: "_pUserId,!
  } Catch(e) {
    Write e.DisplayString()
  }
  ZN ns
}

ClassMethod DisabledUser(pUserId As %String)
{
  Set ns = $NAMESPACE
  ZN "%SYS"
  Try {
    Set pUserId = $ZCONVERT(pUserId, "L")
    Set o = ##class(Security.Users).%OpenId(pUserId)
    Set o.Enabled = 0
    $$$TOE(st, o.%Save())
    Write "User disabled: "_pUserId,!
  } Catch(e) {
    Write e.DisplayString()
  }
  ZN ns
}

ClassMethod AutoStartProduction(pProdName As %String, pPriority As %Integer)
{
  Try {
    $$$TOE(st, ##class(Ens.Director).SetAutoStart(pProdName, pPriority))
  } Catch(e) {
    Write e.DisplayString()
  }
}

ClassMethod SaveDiagram(diagram As %DynamicObject) As %Status
{
	Set tSC = $$$OK
	Try {
		Set diagramName = diagram.name
		Set diagramDef = diagram.def
		$$$TOE(st, ##class(dc.irisflow.data.Diagram).UpdateOrCreateByName(diagramName, diagramDef))
	} Catch tException {
		Set:$$$ISOK(tSC) tSC = tException.AsStatus()
	}
	Quit tSC
}

ClassMethod CreateContestUser()
{
  Set ns = $NAMESPACE
  ZN "%SYS"
  Try {
    $$$TOE(st, ##class(Security.Roles).Import("/home/irisowner/irisbuild/ContestRole.xml"))
    &SQL(DROP USER contest)
    &SQL(CREATE USER contest IDENTIFY BY contest2022)
    Throw:(SQLCODE '= 0) ##class(%Exception.SQL).CreateFromSQLCODE(SQLCODE,%msg)
    &SQL(GRANT %EnsRole_Administrator,ContestRole TO contest)
    Throw:(SQLCODE '= 0) ##class(%Exception.SQL).CreateFromSQLCODE(SQLCODE,%msg)
    Write "User contest created!",!
  } Catch(e) {
    Write e.DisplayString()
  }
  ZN ns
}

}
