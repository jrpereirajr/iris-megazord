Class User.irisflow.simple.Helloworld7 Extends Ens.Production [ Not ProcedureBlock ]
{

XData ProductionDefinition
{
<Production Name="User.irisflow.simple.Helloworld7" LogGeneralTraceEvents="true">
  <Description></Description>
  <ActorPoolSize>1</ActorPoolSize>
  <Item Name="FromTelegram" Category="" ClassName="dc.irisflow.components.telegram.TelegramService" PoolSize="1" Enabled="true" Foreground="false" Comment="" LogTraceEvents="false" Schedule="">
    <Setting Target="Adapter" Name="SSLConfiguration">ISC.FeatureTracker.SSL.Config</Setting>
    <Setting Target="Adapter" Name="Credentials">telegram</Setting>
    <Setting Target="Host" Name="TargetConfigNames">SimpleEchoOperation</Setting>
  </Item>
  <Item Name="SimpleEchoOperation" Category="" ClassName="dc.irisflow.components.misc.SimpleEchoOperation" PoolSize="1" Enabled="true" Foreground="false" Comment="" LogTraceEvents="false" Schedule="">
    <Setting Target="Host" Name="TargetConfigNames">ToTelegram</Setting>
  </Item>
  <Item Name="ToTelegram" Category="" ClassName="dc.irisflow.components.telegram.TelegramOperation" PoolSize="1" Enabled="true" Foreground="false" Comment="" LogTraceEvents="false" Schedule="">
    <Setting Target="Adapter" Name="SSLConfiguration">ISC.FeatureTracker.SSL.Config</Setting>
    <Setting Target="Adapter" Name="Credentials">telegram</Setting>
    <Setting Target="Adapter" Name="SSLConfiguration">ISC.FeatureTracker.SSL.Config</Setting>
    <Setting Target="Adapter" Name="Credentials">telegram</Setting>
    <Setting Target="Host" Name="TargetConfigNames">ToFile</Setting>
    <Setting Target="Host" Name="ChatId">telegram-chat-id</Setting>
  </Item>
  <Item Name="ToFile" Category="" ClassName="dc.irisflow.components.file.FilePassthroughOperation" PoolSize="1" Enabled="true" Foreground="false" Comment="" LogTraceEvents="false" Schedule="">
    <Setting Target="Adapter" Name="FilePath">/tmp/test/out</Setting>
  </Item>
</Production>
}

}
