Class User.irisflow.bpl.HelloworldBPL Extends Ens.Production [ Not ProcedureBlock ]
{

XData ProductionDefinition
{
<Production Name="User.irisflow.bpl.HelloworldBPL" LogGeneralTraceEvents="true">
  <Description></Description>
  <ActorPoolSize>1</ActorPoolSize>
  <Item Name="FromFile" Category="" ClassName="EnsLib.File.PassthroughService" PoolSize="1" Enabled="true" Foreground="false" Comment="" LogTraceEvents="false" Schedule="">
    <Setting Target="Adapter" Name="FilePath">/tmp/test/in</Setting>
    <Setting Target="Host" Name="TargetConfigNames">DefaultFlowBP</Setting>
  </Item>
  <Item Name="ToFile" Category="" ClassName="EnsLib.File.PassthroughOperation" PoolSize="1" Enabled="true" Foreground="false" Comment="" LogTraceEvents="false" Schedule="">
    <Setting Target="Adapter" Name="FilePath">/tmp/test/out</Setting>
  </Item>
  <Item Name="DefaultFlowBP" Category="" ClassName="User.irisflow.bpl.DefaultFlowBP" PoolSize="0" Enabled="true" Foreground="false" Comment="" LogTraceEvents="false" Schedule="">
  </Item>
</Production>
}

}
