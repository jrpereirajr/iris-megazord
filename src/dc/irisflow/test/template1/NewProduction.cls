Class dc.irisflow.test.template1.NewProduction Extends Ens.Production
{

XData ProductionDefinition
{
<Production Name="dc.irisflow.test.template1.NewProduction" LogGeneralTraceEvents="false">
  <Description></Description>
  <ActorPoolSize>2</ActorPoolSize>
  <Item Name="FromFileMsg" Category="" ClassName="EnsLib.File.PassthroughService" PoolSize="1" Enabled="true" Foreground="false" Comment="" LogTraceEvents="true" Schedule="">
    <Setting Target="Adapter" Name="FilePath">/tmp/test/in</Setting>
    <Setting Target="Host" Name="TargetConfigNames">Router</Setting>
  </Item>
  <Item Name="ToFileMsg" Category="" ClassName="EnsLib.File.PassthroughOperation" PoolSize="1" Enabled="true" Foreground="false" Comment="" LogTraceEvents="true" Schedule="">
    <Setting Target="Adapter" Name="FilePath">/tmp/test/out</Setting>
  </Item>
  <Item Name="Router" Category="" ClassName="dc.irisflow.test.template1.Router" PoolSize="1" Enabled="true" Foreground="false" Comment="" LogTraceEvents="true" Schedule="">
  </Item>
</Production>
}

}
