Class User.MyFlow1 Extends Ens.Production [ Not ProcedureBlock ]
{

XData ProductionDefinition
{
<Production Name="User.MyFlow1" LogGeneralTraceEvents="true">
  <Description></Description>
  <ActorPoolSize>1</ActorPoolSize>
  <Item Name="FromTelegram" Category="" ClassName="dc.irisflow.components.telegram.TelegramService" PoolSize="1" Enabled="true" Foreground="false" Comment="" LogTraceEvents="true" Schedule="">
    <Setting Target="Adapter" Name="SSLConfiguration">ISC.FeatureTracker.SSL.Config</Setting>
    <Setting Target="Adapter" Name="Credentials">telegram</Setting>
    <Setting Target="Host" Name="TargetConfigNames">SimpleEchoOperation</Setting>
  </Item>
  <Item Name="SimpleEchoOperation" Category="" ClassName="dc.irisflow.components.misc.SimpleEchoOperation" PoolSize="1" Enabled="true" Foreground="false" Comment="" LogTraceEvents="false" Schedule="">
    <Setting Target="Host" Name="TargetConfigNames">ToTelegram</Setting>
  </Item>
  <Item Name="ToTelegram" Category="" ClassName="dc.irisflow.components.telegram.TelegramOperation" PoolSize="1" Enabled="true" Foreground="false" Comment="" LogTraceEvents="true" Schedule="">
    <Setting Target="Adapter" Name="SSLConfiguration">ISC.FeatureTracker.SSL.Config</Setting>
    <Setting Target="Adapter" Name="Credentials">telegram</Setting>
    <Setting Target="Host" Name="ChatId"></Setting>
  </Item>
  <Item Name="dc.irisflow.components.httpclient.HttpRequestService" Category="" ClassName="dc.irisflow.components.httpclient.HttpRequestService" PoolSize="1" Enabled="false" Foreground="false" Comment="" LogTraceEvents="true" Schedule="">
    <Setting Target="Adapter" Name="SSLConfig">ISC.FeatureTracker.SSL.Config</Setting>
    <Setting Target="Adapter" Name="Https">1</Setting>
    <Setting Target="Adapter" Name="Server">fhir.mrxfu71pjkah.static-test-account.isccloud.io</Setting>
    <Setting Target="Adapter" Name="ApiKey">fhiraas-apikey</Setting>
    <Setting Target="Adapter" Name="Path">/Patient?_count=1</Setting>
    <Setting Target="Host" Name="TargetConfigNames">ToTelegram</Setting>
  </Item>
  <Item Name="dc.irisflow.components.fhiraas.FHIRaaSService" Category="" ClassName="dc.irisflow.components.fhiraas.FHIRaaSService" PoolSize="1" Enabled="true" Foreground="false" Comment="" LogTraceEvents="true" Schedule="">
    <Setting Target="Adapter" Name="ApiKey">fhiraas-apikey</Setting>
    <Setting Target="Adapter" Name="FHIRQueryString"></Setting>
    <Setting Target="Adapter" Name="FHIRResource">Patient</Setting>
    <Setting Target="Adapter" Name="FHIRaaSDeploymentId">mrxfu71pjkah</Setting>
    <Setting Target="Adapter" Name="Https">1</Setting>
    <Setting Target="Adapter" Name="SSLConfig">ISC.FeatureTracker.SSL.Config</Setting>
    <Setting Target="Adapter" Name="FHIRResourceId">1</Setting>
    <Setting Target="Host" Name="TargetConfigNames">dc.irisflow.components.misc.ObjectScriptOperation</Setting>
  </Item>
  <Item Name="dc.irisflow.components.misc.ObjectScriptOperation" Category="" ClassName="dc.irisflow.components.misc.ObjectScriptOperation" PoolSize="1" Enabled="true" Foreground="false" Comment="" LogTraceEvents="true" Schedule="">
    <Setting Target="Host" Name="TargetConfigNames">ToTelegram</Setting>
    <Setting Target="Host" Name="Expression">Set input = {}.%FromJSON(input)
Do ##class(Ens.Util.Trace).WriteTrace("user",$classname(),"","Patient ID: "_input.id)
Quit "👋 Hi "_input.name.%Get(0).given.%Get(0)_"! This is a reminder for your appointment! 📆"</Setting>
    <Setting Target="Host" Name="ContextExpression">Set input = {}.%FromJSON(input)

Set record = $G(^MyDatabase(input.id))
If (record '= "") {
	Set email = $LG(record, 1)
	Set telegram = $LG(record, 2)
	Do ##class(Ens.Util.Trace).WriteTrace("user",$classname(),"",email)
	Do ##class(Ens.Util.Trace).WriteTrace("user",$classname(),"",telegram)

	Set st = ##class(Ens.Config.Credentials).GetCredentialsObj(.credObj, "", "Ens.Config.Credentials", telegram)
	Set context.ChatId = credObj.Password

} Else {
	Do ##class(Ens.Util.Trace).WriteTrace("user", $classname(), "", "No record for patient "_input.id)
}

Quit context</Setting>
  </Item>
</Production>
}

}
