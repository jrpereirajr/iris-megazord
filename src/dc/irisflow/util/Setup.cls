Class dc.irisflow.util.Setup
{

ClassMethod InitialComponents() As %Status
{
  Set tSC = $$$OK
	Try {
    $$$TOE(tSC, ..AddComponent("ToFile", "fas fa-file-signature", 1, 0, {"className": "dc.irisflow.components.file.FilePassthroughOperation"}))
    $$$TOE(tSC, ..AddComponent("ToTelegram","fab fa-telegram", 1, 0,{"className": "dc.irisflow.components.telegram.TelegramOperation","SSLConfiguration": "ISC.FeatureTracker.SSL.Config","Credentials": "telegram"}))
    $$$TOE(tSC, ..AddComponent("ToEmail","fas fa-envelope", 1, 0,{"className": "dc.irisflow.components.email.SMTPOperation","SSLConfig": "ISC.FeatureTracker.SSL.Config","Credentials": "test-imap", "SMTPPort": "465", "SMTPServer": "smtp.mail.yahoo.com"}))
    $$$TOE(tSC, ..AddComponent("FromFile", "fas fa-file-signature", 0, 1, {"className": "dc.irisflow.components.file.FilePassthroughService"}))
    $$$TOE(tSC, ..AddComponent("FromTelegram", "fab fa-telegram", 0, 1, {"className": "dc.irisflow.components.telegram.TelegramService","SSLConfiguration": "ISC.FeatureTracker.SSL.Config","Credentials": "telegram"}))
    $$$TOE(tSC, ..AddComponent("FromEmail(POP3)", "fas fa-envelope", 0, 1, {"className": "dc.irisflow.components.email.POP3Service","SSLConfig": "ISC.FeatureTracker.SSL.Config","Credentials": "test-imap", "SMTPPort": "465", "SMTPServer": "smtp.mail.yahoo.com"}))
    $$$TOE(tSC, ..AddComponent("SimpleEchoOperation", "fas fa-cog", 1, 1, {"className": "dc.irisflow.components.misc.SimpleEchoOperation"}))
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

}
