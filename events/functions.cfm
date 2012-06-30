<!--- Place functions here that should be globally available in your application. --->
<cffunction name="decryptUserID" hint="Decrypts the User ID stored in the session">
	<cfreturn decrypt(SESSION.userID, GetEncryptKey(), "CFMX_COMPAT", "Hex")>
</cffunction>

<cffunction name="GetEncryptKey">
	<cfreturn "675FTYYSsdWT6&T6sta">
</cffunction>

<cffunction name="GetReporterKey">
	<cfreturn "AndyStephenson">
</cffunction>