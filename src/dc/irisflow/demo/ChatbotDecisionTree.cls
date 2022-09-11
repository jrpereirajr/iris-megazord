Class dc.irisflow.demo.ChatbotDecisionTree
{

/// Telegram input
ClassMethod input(pChatid, pStream)
{
    Set sc = $$$OK
    
    Set tType = $ZCONVERT(pStream,"l")

    If '$Data(^zChatId(pChatid)) {
        // If there is no chatId, means there are no interactions before.
        Set ^zChatId(pChatid)=""

        // Make the introduction and show the options to the user
        write "Hi, ",!
        write "Climatiq helps you calculate the environmental footprint created by a broad range of emission-generating activities.",!
        write "I can talk about the following topics:",!
        write "1 - Flights",!
        write "2 - Water Treatment",! 
        write "3 - Plastic Waste",! 
        write "4 - Clothing and Footwear",!  
    } Else {
        // If there is no value for the chat, it means the user didn't choose the topic
        If ($get(^zChatId(pChatid))="") {
            Set tType=$CASE(pStream,1:"flight",2:"water treatment",3:"plastic",4:"clothes")
            Set ^zChatId(pChatid)=tType
            Do ..Routing(pChatid,tType)
        } Else {
            // If there is value for the chat, it means the user did choose the topic
            // Now all the messages will be to respond to the bot's questions.
            Do ..Routing(pChatid,pStream)
        }
    }

    Return sc
}

/// Routing Method
ClassMethod Routing(pChatid, pStream) As %Status
{
    Set sc = $$$OK

    Set route = $get(^zChatId(pChatid))

    If (route = "flight") {
        do ..Flight(pChatid, pStream)
    } ElseIf (route = "water treatment") {
        do ..WaterTreatment(pChatid,pStream)
    } ElseIf (route = "plastic") {
        do ..PlasticWaste(pChatid,pStream)
    } ElseIf (route = "clothes") {
        do ..ClothingFootwear(pChatid,pStream)
    } Else {
        write "I didn't understand",!
        write "Please, tell me again what do you want to know",!
    }

    Return sc
}

/// flights
ClassMethod Flight(pChatid, pStream) As %Status
{
    Set sc = $$$OK
    
    // Checking if user chose a flight route
    If '$Data(^zChatId(pChatid,"flight",1)) {
        
        Set ^zChatId(pChatid,"flight",1)=""
        write "Which route do you want to calculate the Carbon emissions? (numbers only)",!
        write "1 - GRU to JFK",!
		write "2 - GRU to DXB",!
		write "3 - GRU to MIA",!

    } ElseIf '$Data(^zChatId(pChatid,"flight",2)) {
        
        // Saving the user previous answer
        Set ^zChatId(pChatid,"flight",1)=pStream

        // Checking if the user infor how many passengers
        Set ^zChatId(pChatid,"flight",2)=""
        write "How many passengers? (numbers only)",!

    } ElseIf '$Data(^zChatId(pChatid,"flight",3)) {
        
        // Saving the user previous answer
        Set ^zChatId(pChatid,"flight",2)=pStream

        // Checking if the user inform the class flight
        Set ^zChatId(pChatid,"flight",3)=""
        write "Which class the flight was on?  Allowed values are: unknown, economy, business, first",!

    } Else {
        
        Set listClass = $LFS("unknown,economy,business,first")
        
        If ($LF(listClass, $ZCONVERT(pStream,"l")) = 0) {
            write "Class type not allowed",!
        } Else {
            // Saving the user previous answer
            Set ^zChatId(pChatid,"flight",3)=pStream

            // if user informs everything, call the API and after that kill the control global 
            write "Route: "_$get(^zChatId(pChatid,"flight",1)),!
            write "Passengers: "_$get(^zChatId(pChatid,"flight",2)),!
            write "Class: "_$get(^zChatId(pChatid,"flight",3)),!
            write "API chamada",!

            kill ^zChatId(pChatid)
        }
    }

    Return sc
}

/// Clothing and Footwear
ClassMethod ClothingFootwear(pChatid, pStream) As %Status
{
    Set sc = $$$OK
    
    If '$Data(^zChatId(pChatid,"clothes",1)) {
        Set ^zChatId(pChatid,"clothes",1)=""
        write "How much money spent in clothes or footwear?",!
    } ElseIf '$Data(^zChatId(pChatid,"clothes",2)) {
        // Saving the user previous answer
        Set ^zChatId(pChatid,"clothes",1)=pStream

        // Checking for the currency
        Set ^zChatId(pChatid,"clothes",2)=""
        write "Which is the currency ISO code? (Values allowed: usd,eur,brl,jpy)",!
    } Else {
        Set listClass = $LFS("usd,eur,brl,jpy")
        
        If ($LF(listClass, $ZCONVERT(pStream,"l")) = 0) {
            write "ISO code not supported",!
        } Else {
            // Saving the user previous answer
            Set ^zChatId(pChatid,"clothes",2)=$ZCONVERT(pStream,"l")

            // if user informs everything, call the API and after that kill the control global 
            write "Money: "_$get(^zChatId(pChatid,"clothes",1)),!
            write "Currency: "_$get(^zChatId(pChatid,"clothes",2)),!
            write "API chamada",!

            kill ^zChatId(pChatid)
        }
    }

    Return sc
}

/// Water Treatment
ClassMethod WaterTreatment(pChatid, pStream) As %Status
{
    Set sc = $$$OK
    
    If '$Data(^zChatId(pChatid,"water",1)) {
        Set ^zChatId(pChatid,"water",1)=""
        write "What is the volume of water to be treated? (liters)",!
    } Else {
        // Saving the user previous answer
        Set ^zChatId(pChatid,"water",1)=pStream
        
        // if user informs everything, call the API and after that kill the control global 
        write "Water Volume: "_$get(^zChatId(pChatid,"water",1)),!
        write "API chamada",!

        kill ^zChatId(pChatid)
    }

    Return sc
}

/// Plastic Waste
ClassMethod PlasticWaste(pChatid, pStream) As %Status
{
    Set sc = $$$OK
    
    If '$Data(^zChatId(pChatid,"plastic",1)) {
        Set ^zChatId(pChatid,"plastic",1)=""
        write "What is the volume of plastic waste? (numbers)",!
    } ElseIf '$Data(^zChatId(pChatid,"plastic",2)) {
        // Saving the user previous answer
        Set ^zChatId(pChatid,"plastic",1)=pStream
        
        // Checking the unity type
        Set ^zChatId(pChatid,"plastic",2)=""
        write "Which unity type (Values allowed: kg for kilograms,t for tonnes(metric tons),ton US short tons)",!
    } Else {
        Set listClass = $LFS("kg,t,ton")
        
        If ($LF(listClass, $ZCONVERT(pStream,"l")) = 0) {
            write "unit type not allowed",!
        } Else {
            // Saving the user previous answer
            Set ^zChatId(pChatid,"plastic",2)=pStream

            // if user informs everything, call the API and after that kill the control global 
            write "Volume: "_$get(^zChatId(pChatid,"plastic",1)),!
            write "Unit Type: "_$get(^zChatId(pChatid,"plastic",2)),!
            write "API chamada",!

            kill ^zChatId(pChatid)
        }
    }

    Return sc
}

}
