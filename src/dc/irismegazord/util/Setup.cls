Class dc.irismegazord.util.Setup
{

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
