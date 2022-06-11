/*
Author: Nikolay Soloviev
Repo: https://github.com/intersystems-community/TelegramAlerts
*/

Class dc.Telegram.Msg.ButtonRequest Extends Ens.Request
{

Property ChatId As %Integer;

Property Text As %String(MAXLEN = 5000);

Property Button As %String;

Storage Default
{
<Data name="ButtonRequestDefaultData">
<Subscript>"ButtonRequest"</Subscript>
<Value name="1">
<Value>ChatId</Value>
</Value>
<Value name="2">
<Value>Text</Value>
</Value>
<Value name="3">
<Value>Button</Value>
</Value>
</Data>
<DefaultData>ButtonRequestDefaultData</DefaultData>
<Type>%Storage.Persistent</Type>
}

}
