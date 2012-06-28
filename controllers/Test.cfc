<cfcomponent extends="Controller" output="false">
	
	<cffunction name="problem">
	
		<!--- Problem/Add --->
		<cfhttp url="http://cleancampus.local/problem/add" port="8600" method="post" result="addData">
			<cfhttpparam type="FormField" name="universityID" value="1">
			<cfhttpparam type="FormField" name="problemTypeID" value="1">
			<cfhttpparam type="FormField" name="problemEffectID" value="1">
			<cfhttpparam type="FormField" name="reporterID" value="1">
			<cfhttpparam type="FormField" name="description" value="Test Description">
			<cfhttpparam type="FormField" name="latitude" value="54.9760239">
			<cfhttpparam type="FormField" name="longitude" value="1.6183166">
			<cfhttpparam type="FormField" name="format" value="html">
			<cfhttpparam type="FormField" name="apitoken" value="544506F8C7AAB7D1946B6EFDF833A7D106FFD677B9701B5A85CAC4CCC8DDFDDEA905DF">
		</cfhttp>
		
		<cfdump var="#addData.FileContent#"><cfabort>
	
		
	
	</cffunction>
	
	<cffunction name="text">
	
		<cfreturn 'Text'>
	
	</cffunction>

	<cffunction name="booleanTrue">
	
		<cfreturn true>
	
	</cffunction>
	
	<cffunction name="struct">
	
		<cfreturn StructNew()>
	
	</cffunction>

	<cffunction name="query">
	
		<cfreturn QueryNew("one,two")>
	
	</cffunction>
	
	<cffunction name="handleParams">
	
		<cfif IsDefined("params.arg1")>
			<cfset andrew = true>
		<cfelse>
			<cfset andrew = false>
		</cfif>
		
		<cfreturn andrew>
	
	</cffunction>
	
</cfcomponent>