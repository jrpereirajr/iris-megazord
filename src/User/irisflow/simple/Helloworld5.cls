Class User.irisflow.simple.Helloworld5 Extends Ens.Production [ Not ProcedureBlock ]
{

XData ProductionDefinition
{
<Production Name="User.irisflow.simple.Helloworld5" LogGeneralTraceEvents="true">
  <Description></Description>
  <ActorPoolSize>1</ActorPoolSize>
  <Item Name="FromFile" Category="" ClassName="dc.components.file.FilePassthroughService" PoolSize="1" Enabled="true" Foreground="false" Comment="" LogTraceEvents="false" Schedule="">
    <Setting Target="Adapter" Name="FilePath">/tmp/test/in</Setting>
    <Setting Target="Host" Name="TargetConfigNames">ToFile</Setting>
  </Item>
  <Item Name="ToFile" Category="" ClassName="dc.components.file.FilePassthroughOperation" PoolSize="1" Enabled="true" Foreground="false" Comment="" LogTraceEvents="false" Schedule="">
    <Setting Target="Adapter" Name="FilePath">/tmp/test/out</Setting>
    <Setting Target="Adapter" Name="FilePath">/tmp/test/out</Setting>
    <Setting Target="Host" Name="TargetConfigNames">ToFile1</Setting>
  </Item>
  <Item Name="ToFile1" Category="" ClassName="dc.components.file.FilePassthroughOperation" PoolSize="1" Enabled="true" Foreground="false" Comment="" LogTraceEvents="false" Schedule="">
    <Setting Target="Adapter" Name="FilePath">/tmp/test/out</Setting>
    <Setting Target="Host" Name="TargetConfigNames">ToTelegram</Setting>
  </Item>
  <Item Name="ToTelegram" Category="" ClassName="dc.components.telegram.TelegramOperation" PoolSize="1" Enabled="true" Foreground="false" Comment="" LogTraceEvents="true" Schedule="">
    <Setting Target="Adapter" Name="Credentials">telegram</Setting>
    <Setting Target="Adapter" Name="SSLConfiguration">ISC.FeatureTracker.SSL.Config</Setting>
    <Setting Target="Host" Name="ChatId">5364421812</Setting>
  </Item>
</Production>
}

}
