<cfoutput>

#startFormTag(action='addImage', name='add', enctype="multipart/form-data")#

	<p>#textfieldTag(name="id", value="6", labelPlacement="before", label="ID: ")#</p>
	<p>#filefieldTag(name="image", labelPlacement="before", label="Image: ")#</p>
	#hiddenFieldTag(name="apitoken", value="544506F8C7AAB7D1946B6EFDF833A7D106FFD677B9701B5A85CAC4CCC8DDFDDEA905DF")#
	#hiddenFieldTag(name="format", value="json")#
	<p>#submitTag(value="submit")#</p>

#endFormTag()#

</cfoutput>