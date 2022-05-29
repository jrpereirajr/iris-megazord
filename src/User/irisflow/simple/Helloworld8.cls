Class User.irisflow.simple.Helloworld8 Extends Ens.Production [ Not ProcedureBlock ]
{

XData ProductionDefinition
{
<Production Name="User.irisflow.simple.Helloworld8" LogGeneralTraceEvents="true">
  <Description></Description>
  <ActorPoolSize>1</ActorPoolSize>
  <Item Name="FromTelegram" Category="" ClassName="dc.irisflow.components.telegram.TelegramService" PoolSize="1" Enabled="true" Foreground="false" Comment="" LogTraceEvents="false" Schedule="">
    <Setting Target="Adapter" Name="SSLConfiguration">ISC.FeatureTracker.SSL.Config</Setting>
    <Setting Target="Adapter" Name="Credentials">telegram</Setting>
    <Setting Target="Host" Name="TargetConfigNames">SimpleEchoOperation</Setting>
  </Item>
  <Item Name="SimpleEchoOperation" Category="" ClassName="dc.irisflow.components.SimpleEchoOperation" PoolSize="1" Enabled="true" Foreground="false" Comment="" LogTraceEvents="false" Schedule="">
    <Setting Target="Host" Name="TargetConfigNames">ToEmail</Setting>
  </Item>
  <Item Name="ToTelegram" Category="" ClassName="dc.irisflow.components.telegram.TelegramOperation" PoolSize="1" Enabled="true" Foreground="false" Comment="" LogTraceEvents="true" Schedule="">
    <Setting Target="Adapter" Name="SSLConfiguration">ISC.FeatureTracker.SSL.Config</Setting>
    <Setting Target="Adapter" Name="Credentials">telegram</Setting>
    <Setting Target="Host" Name="TargetConfigNames"></Setting>
    <Setting Target="Host" Name="ChatId">telegram-chat-id</Setting>
  </Item>
  <Item Name="FromEmail" Category="" ClassName="dc.irisflow.components.email.POP3Service" PoolSize="1" Enabled="true" Foreground="false" Comment="" LogTraceEvents="true" Schedule="">
    <Setting Target="Adapter" Name="POP3Port">995</Setting>
    <Setting Target="Adapter" Name="POP3Server">pop.mail.yahoo.com</Setting>
    <Setting Target="Adapter" Name="Credentials">imap-test</Setting>
    <Setting Target="Adapter" Name="SSLConfig">ISC.FeatureTracker.SSL.Config</Setting>
    <Setting Target="Host" Name="TargetConfigNames">ToTelegram</Setting>
  </Item>
  <Item Name="ToEmail" Category="" ClassName="dc.irisflow.components.email.SMTPOperation" PoolSize="1" Enabled="true" Foreground="false" Comment="" LogTraceEvents="true" Schedule="">
    <Setting Target="Adapter" Name="Credentials">imap-test</Setting>
    <Setting Target="Adapter" Name="SMTPPort">465</Setting>
    <Setting Target="Adapter" Name="SMTPServer">smtp.mail.yahoo.com</Setting>
    <Setting Target="Adapter" Name="From"></Setting>
    <Setting Target="Adapter" Name="Recipient"></Setting>
    <Setting Target="Adapter" Name="SSLConfig">ISC.FeatureTracker.SSL.Config</Setting>
  </Item>
</Production>
}

}
