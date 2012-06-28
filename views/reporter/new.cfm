<cfoutput>

	#startFormTag(controller="reporter", action="add")#
	
		<p>#textFieldTag(name="udid", value="12345", label="UDID", prepend="<br>")#</p>
	
		<p>
			#hiddenFieldTag(name="apiToken", value="544506F8C7AAB7D1946B6EFDF833A7D106FFD677B9701B5A85CAC4CCC8DDFDDEA905DF")#
			#submitTag(name="submit", value="Add Reporter")#
		</p>
	
	#endFormTag()#
	
</cfoutput>