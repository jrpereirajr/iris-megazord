Class UnitTest.dc.irisflow.Utils
{

ClassMethod Setup()
{
    Set ^UnitTestRoot = "/irisrun/repo/src"
}

ClassMethod Run(executeThisClass As %String = "")
{
    If ($G(^UnitTestRoot) = "") {
        Do ..Setup()
    }
    Do ##class(%UnitTest.Manager).RunTest("UnitTest/dc/irisflow:"_executeThisClass, "/nodelete")
}

}
