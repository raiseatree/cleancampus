<cfoutput>

	#startFormTag(controller="main", action="firstrun")#
	
		<p>#textFieldTag(name="udid", value="12345", label="UDID", prepend="<br>")#</p>
		<p>#textFieldTag(name="format", value="html", label="Format", prepend="<br>")#</p>
	
		<p>
			#hiddenFieldTag(name="apiToken", value="544506F8C7AAB7D1946B6EFDF833A7D106FFD677B9701B5A85CAC4CCC8DDFDDEA905DF")#
			#submitTag(name="submit", value="Start First Run")#
		</p>
	
	#endFormTag()#
	
</cfoutput>