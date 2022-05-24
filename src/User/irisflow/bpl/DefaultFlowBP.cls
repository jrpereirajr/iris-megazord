Class User.irisflow.bpl.DefaultFlowBP Extends Ens.BusinessProcessBPL [ Not ProcedureBlock ]
{

XData BPL
{
<process language='objectscript' request='Ens.Request' response='Ens.Response' height='2000' width='2000' > <sequence xend='200' yend='450' > <call name='ToFile' target='ToFile' async='0' xpos='200' ypos='350' > <request type='Ens.Request' > <assign property="callrequest" value="request" action="set" /> </request> <response type='Ens.Response' /> </call> </sequence> </process>
}

Storage Default
{
<Type>%Storage.Persistent</Type>
}

}
