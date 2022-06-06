Class dc.irisflow.components.file.FilePassthroughService Extends (EnsLib.File.PassthroughService, dc.irisflow.components.IrisFlowBusinessService)
{

Parameter CONTAINERCLASS = "dc.irisflow.components.GenericMessage";

Method OnCreateMessage(pInput As %SystemBase) As dc.irisflow.components.GenericMessage
{
    Return $classmethod(..#CONTAINERCLASS,"%New",pInput)
}

Method OnAfterSendMessage(pInput As %SystemBase)
{
	Set tWorkArchive=(""'=..Adapter.ArchivePath)&&(..Adapter.ArchivePath=..Adapter.WorkPath || (""=..Adapter.WorkPath && (..Adapter.ArchivePath=..Adapter.FilePath)))
	If 'tWorkArchive {
		Set tSC1 = ..removeStreamFromInput(pInput)
		Set:$$$ISERR(tSC1) tSC=$$$ADDSC(tSC,tSC1)
	}
}

}
