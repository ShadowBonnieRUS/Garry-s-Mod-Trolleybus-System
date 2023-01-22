-- Copyright © Platunov I. M., 2020 All rights reserved

Trolleybus_System.LanguagePhraseCache = Trolleybus_System.LanguagePhraseCache or {}

function Trolleybus_System.GetLanguagePhrase(phrase,...)
	local full = "trolleybus_system."..phrase
	local fphrase = language.GetPhrase(full)
	
	if full==fphrase then
		return phrase,true
	end
	
	local tfphrase = Trolleybus_System.LanguagePhraseCache[fphrase]
	
	if !tfphrase then
		tfphrase = fphrase:Trim()
		local i = 1
		
		while i<#tfphrase do
			if tfphrase[i]=="|" and tfphrase[i+1]=="n" then
				tfphrase = tfphrase:sub(1,i-1).."\n"..tfphrase:sub(i+2,-1)
			end
		
			i = i+1
		end
		
		Trolleybus_System.LanguagePhraseCache[fphrase] = tfphrase
	end
	
	return Format(tfphrase,...),false
end

function Trolleybus_System.GetLanguagePhraseName(prefix,phrase,...)
	local tphrase,nophrase = Trolleybus_System.GetLanguagePhrase((prefix or "")..phrase,...)
	
	return nophrase and phrase or tphrase
end