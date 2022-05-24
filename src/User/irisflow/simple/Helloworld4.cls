Class User.irisflow.simple.Helloworld4 Extends Ens.Production [ Not ProcedureBlock ]
{

XData ProductionDefinition
{
<Production Name="User.irisflow.simple.Helloworld4" LogGeneralTraceEvents="true">
  <Description></Description>
  <ActorPoolSize>1</ActorPoolSize>
  <Item Name="FromFile" Category="" ClassName="dc.irisflow.components.file.FilePassthroughService" PoolSize="1" Enabled="true" Foreground="false" Comment="" LogTraceEvents="false" Schedule="">
    <Setting Target="Adapter" Name="FilePath">/tmp/test/in</Setting>
    <Setting Target="Host" Name="TargetConfigNames">ToFile</Setting>
  </Item>
  <Item Name="ToFile" Category="" ClassName="dc.irisflow.components.file.FilePassthroughOperation" PoolSize="1" Enabled="true" Foreground="false" Comment="" LogTraceEvents="false" Schedule="">
    <Setting Target="Adapter" Name="FilePath">/tmp/test/out</Setting>
    <Setting Target="Adapter" Name="FilePath">/tmp/test/out</Setting>
    <Setting Target="Host" Name="TargetConfigNames">ToFile1</Setting>
  </Item>
  <Item Name="ToFile1" Category="" ClassName="dc.irisflow.components.file.FilePassthroughOperation" PoolSize="1" Enabled="true" Foreground="false" Comment="" LogTraceEvents="false" Schedule="">
    <Setting Target="Adapter" Name="FilePath">/tmp/test/out</Setting>
  </Item>
  <Item Name="FromTelegram" Category="" ClassName="dc.irisflow.components.telegram.TelegramService" PoolSize="1" Enabled="true" Foreground="false" Comment="" LogTraceEvents="true" Schedule="">
    <Setting Target="Adapter" Name="SSLConfiguration">ISC.FeatureTracker.SSL.Config</Setting>
    <Setting Target="Adapter" Name="Credentials">telegram</Setting>
    <Setting Target="Host" Name="TargetConfigNames">ToFile</Setting>
  </Item>
</Production>
}

}
