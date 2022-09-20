Class dc.irisflow.demo.ChatbotDecisionTree Extends %RegisteredObject
{

Parameter CallClimatiqAPI = "CallClimatiqAPI";

Property pChatid As %String;

Property pStream As %String;

Property output As %String;

Method %OnNew(pChatid As %String, pStream As %String) As %Status
{
    Set ..pChatid = pChatid
    Set ..pStream = $ZStrip($ZConvert(pStream, "L"), "<>W")
    Set ..output = ""
    Return $$$OK
}

Method WriteLine(data As %String)
{
    Set ..output = ..output_data_$Char(13,10)
}

/// Telegram input
Method input() As %String
{
    Set sc = $$$OK
    
    Set tType = $ZCONVERT(..pStream,"l")

    If '$Data(^zChatId(..pChatid)) {
        // If there is no chatId, means there are no interactions before.
        Set ^zChatId(..pChatid)=""

        // Make the introduction and show the options to the user 
        Do ..GreetingsMsg()
    } Else {
        // If there is no value for the chat, it means the user didn't choose the topic
        If ($get(^zChatId(..pChatid))="") || ($get(^zChatId(..pChatid))="invalid") {
            Set tType=$CASE(..pStream,1:"flight",2:"water treatment",3:"plastic",4:"clothes",:"invalid")
            Set ^zChatId(..pChatid)=tType
            Do ..Routing()
        } Else {
            // If there is value for the chat, it means the user did choose the topic
            // Now all the messages will be to respond to the bot's questions.
            Do ..Routing()
        }
    }

    Return ..output
}

Method GreetingsMsg()
{
    Do ..WriteLine("Hi, ")
    Do ..WriteLine("Climatiq helps you calculate the environmental footprint created by a broad range of emission-generating activities.")
    Do ..WriteLine("I can talk about the following topics:")
    Do ..WriteLine("1 - Flights")
    Do ..WriteLine("2 - Water Treatment") 
    Do ..WriteLine("3 - Plastic Waste") 
    Do ..WriteLine("4 - Clothing and Footwear")
}

/// Routing Method
Method Routing() As %Status
{
    Set sc = $$$OK

    Set route = $get(^zChatId(..pChatid))

    If (route = "flight") {
        do ..Flight()
    } ElseIf (route = "water treatment") {
        do ..WaterTreatment()
    } ElseIf (route = "plastic") {
        do ..PlasticWaste()
    } ElseIf (route = "clothes") {
        do ..ClothingFootwear()
    } Else {
        If ($get(^zChatId(..pChatid)) = "invalid") {
            Do ..GreetingsMsg()
        } Else {
            Do ..WriteLine("I didn't understand")
            Do ..WriteLine("Please, tell me again what do you want to know")
        }
    }

    Return sc
}

/// flights
Method Flight() As %Status
{
    Set sc = $$$OK
    
    // Checking if user chose a flight route
    If '$Data(^zChatId(..pChatid,"flight",1)) {
        
        Set ^zChatId(..pChatid,"flight",1)=""
        Do ..WriteLine("Which route do you want to calculate the Carbon emissions? (numbers only)")
        Do ..WriteLine("1 - GRU to JFK")
		Do ..WriteLine("2 - GRU to DXB")
		Do ..WriteLine("3 - GRU to MIA")

    } ElseIf '$Data(^zChatId(..pChatid,"flight",2)) {
        
        // Saving the user previous answer
        Set ^zChatId(..pChatid,"flight",1)=..pStream

        // Checking if the user infor how many passengers
        Set ^zChatId(..pChatid,"flight",2)=""
        Do ..WriteLine("How many passengers? (numbers only)")

    } ElseIf '$Data(^zChatId(..pChatid,"flight",3)) {
        
        // Saving the user previous answer
        Set ^zChatId(..pChatid,"flight",2)=..pStream

        // Checking if the user inform the class flight
        Set ^zChatId(..pChatid,"flight",3)=""
        Do ..WriteLine("Which class the flight was on?  Allowed values are: unknown, economy, business, first")

    } Else {
        
        Set listClass = $LFS("unknown,economy,business,first")
        
        If ($LF(listClass, $ZCONVERT(..pStream,"l")) = 0) {
            Do ..WriteLine("Class type not allowed")
        } Else {
            // Saving the user previous answer
            Set ^zChatId(..pChatid,"flight",3)=..pStream

            // if user informs everything, call the API and after that kill the control global 
            #; write "Route: "_$get(^zChatId(..pChatid,"flight",1)),!
            #; write "Passengers: "_$get(^zChatId(..pChatid,"flight",2)),!
            #; write "Class: "_$get(^zChatId(..pChatid,"flight",3)),!

            Merge ^zChatIdFinalized(..pChatid) = ^zChatId(..pChatid)
            kill ^zChatId(..pChatid)

            Do ..WriteLine(..#CallClimatiqAPI)
        }
    }

    Return sc
}

/// Clothing and Footwear
Method ClothingFootwear() As %Status
{
    Set sc = $$$OK
    
    If '$Data(^zChatId(..pChatid,"clothes",1)) {
        Set ^zChatId(..pChatid,"clothes",1)=""
        Do ..WriteLine("How much money spent in clothes or footwear?")
    } ElseIf '$Data(^zChatId(..pChatid,"clothes",2)) {
        // Saving the user previous answer
        Set ^zChatId(..pChatid,"clothes",1)=..pStream

        // Checking for the currency
        Set ^zChatId(..pChatid,"clothes",2)=""
        Do ..WriteLine("Which is the currency ISO code? (Values allowed: usd,eur,brl,jpy)")
    } Else {
        Set listClass = $LFS("usd,eur,brl,jpy")
        
        If ($LF(listClass, $ZCONVERT(..pStream,"l")) = 0) {
            Do ..WriteLine("ISO code not supported")
        } Else {
            // Saving the user previous answer
            Set ^zChatId(..pChatid,"clothes",2)=$ZCONVERT(..pStream,"l")

            // if user informs everything, call the API and after that kill the control global 
            #; write "Money: "_$get(^zChatId(..pChatid,"clothes",1)),!
            #; write "Currency: "_$get(^zChatId(..pChatid,"clothes",2)),!

            Merge ^zChatIdFinalized(..pChatid) = ^zChatId(..pChatid)
            kill ^zChatId(..pChatid)

            Do ..WriteLine(..#CallClimatiqAPI)
        }
    }

    Return sc
}

/// Water Treatment
Method WaterTreatment() As %Status
{
    Set sc = $$$OK
    
    If '$Data(^zChatId(..pChatid,"water",1)) {
        Set ^zChatId(..pChatid,"water",1)=""
        Do ..WriteLine("What is the volume of water to be treated? (liters)")
    } Else {
        // Saving the user previous answer
        Set ^zChatId(..pChatid,"water",1)=..pStream
        
        // if user informs everything, call the API and after that kill the control global 
        #; write "Water Volume: "_$get(^zChatId(..pChatid,"water",1)),!

        Merge ^zChatIdFinalized(..pChatid) = ^zChatId(..pChatid)
        kill ^zChatId(..pChatid)

        Do ..WriteLine(..#CallClimatiqAPI)
    }

    Return sc
}

/// Plastic Waste
Method PlasticWaste() As %Status
{
    Set sc = $$$OK
    
    If '$Data(^zChatId(..pChatid,"plastic",1)) {
        Set ^zChatId(..pChatid,"plastic",1)=""
        Do ..WriteLine("What is the weight of plastic waste? (numbers)")
    } ElseIf '$Data(^zChatId(..pChatid,"plastic",2)) {
        // Saving the user previous answer
        Set ^zChatId(..pChatid,"plastic",1)=..pStream
        
        // Checking the unity type
        Set ^zChatId(..pChatid,"plastic",2)=""
        Do ..WriteLine("Which unity type (Values allowed: kg for kilograms,t for tonnes(metric tons),ton US short tons)")
    } Else {
        Set listClass = $LFS("kg,t,ton")
        
        If ($LF(listClass, $ZCONVERT(..pStream,"l")) = 0) {
            Do ..WriteLine("unit type not allowed")
        } Else {
            // Saving the user previous answer
            Set ^zChatId(..pChatid,"plastic",2)=..pStream

            // if user informs everything, call the API and after that kill the control global 
            #; write "Volume: "_$get(^zChatId(..pChatid,"plastic",1)),!
            #; write "Unit Type: "_$get(^zChatId(..pChatid,"plastic",2)),!

            Merge ^zChatIdFinalized(..pChatid) = ^zChatId(..pChatid)
            kill ^zChatId(..pChatid)

            Do ..WriteLine(..#CallClimatiqAPI)
        }
    }

    Return sc
}

}
