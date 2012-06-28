<cfparam name="rtn">

<cfdump var="#rtn#">

<cfoutput>

	#startFormTag(controller="problem", action="add", enctype="multipart/form-data")#
		
		<p>#selectTag(name="universityid", options=rtn.universities, 
			valueField="id", textField="uniname", label="University", 
			prepend="<br>")#
		</p>
		
		<p>#selectTag(name="problemtypeid", options=rtn.problemtypes, 
			valueField="id", textField="typeLabel", label="Problem Type", 
			prepend="<br>")#
		</p>
		
		<p>#selectTag(name="problemeffectid", options=rtn.problemeffects, 
			valueField="id", textField="effectLabel", label="Problem Effect", 
			prepend="<br>")#
		</p>
		
		<p>#textFieldTag(name="reporterid", value="37E0", label="Reporter", prepend="<br>")#</p>
		<p>#textFieldTag(name="description", value="Test Desc", label="Description", prepend="<br>")#</p>
		<p>#fileFieldTag(name="image", label="Image", prepend="<br>")#</p>
		
		<p>#textFieldTag(name="latitude", value="12.432", label="Latitude", prepend="<br>")#</p>
		<p>#textFieldTag(name="longitude", value="21.234", label="Longitude", prepend="<br>")#</p>
	
		<p>
			#hiddenFieldTag(name="apiToken", value="544506F8C7AAB7D1946B6EFDF833A7D106FFD677B9701B5A85CAC4CCC8DDFDDEA905DF")#
			#submitTag(name="submit", value="Add Problem")#
		</p>
	
	#endFormTag()#

</cfoutput>