/*
Author: Nikolay Soloviev
Repo: https://github.com/intersystems-community/TelegramAlerts
*/

Class dc.Telegram.TelegramOperation Extends Ens.BusinessOperation
{

Parameter ADAPTER = "dc.Telegram.TelegramOutboundAdapter";

Parameter INVOCATION = "Queue";

Property Adapter As dc.Telegram.TelegramOutboundAdapter;

Method SendMessage(pInput As dc.Telegram.Msg.TextRequest, Output pOutput As Ens.Response) As %Status
{
	Quit ..Adapter.SendMessage(pInput.ChatId,pInput.Text,1)
}

Method SendButton(pInput As dc.Telegram.Msg.ButtonRequest, Output pOutput As Ens.Response) As %Status
{
	Quit ..Adapter.SendButton(pInput.ChatId,pInput.Text,pInput.Button,1)
}

XData MessageMap
{
<MapItems>
    <MapItem MessageType="dc.Telegram.Msg.TextRequest">
        <Method>SendMessage</Method>
    </MapItem>
    <MapItem MessageType="dc.Telegram.Msg.ButtonRequest">
        <Method>SendButton</Method>
    </MapItem>
</MapItems>
}

}
