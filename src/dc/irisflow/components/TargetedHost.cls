Class dc.irisflow.components.TargetedHost Extends Ens.Host [ Abstract ]
{

/// Configuration item(s) to which to send file stream messages
Property TargetConfigNames As %String(MAXLEN = 1000);

Parameter SETTINGS = "TargetConfigNames:Basic:selector?multiSelect=1&context={Ens.ContextSearch/ProductionItems?targets=1&productionName=@productionId}";

/// Copied from ##class(EnsLib.File.PassthroughService).OnProcessInput()
Method SendRequestToTargets(pRequest As dc.irisflow.components.GenericMessage)
{
	// todo: think on how to send request async
	#; Set tWorkAsync = 0
	For iTarget=1:1:$L(..TargetConfigNames, ",") {
        Set tOneTarget = $ZStrip($P(..TargetConfigNames, ",", iTarget), "<>W")
        Continue:("" = tOneTarget)
		#; If tWorkAsync {
		#; 	$$$TOE(st, ..SendRequestAsync(tOneTarget, pRequest))
		#; } Else {
		#; 	$$$TOE(st, ..SendRequestSync(tOneTarget, pRequest))
		#; }
		$$$TOE(st, ..SendRequestSync(tOneTarget, pRequest))
	}
}

}
