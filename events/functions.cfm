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

<cffunction name="LoadSiteTitle">
	<cfreturn "My Clean Campus">
</cffunction>

<cffunction name="LoadSiteURL">
	<cfreturn "http://www.mycleancampus.com">
</cffunction>

<cffunction name="LoadEmailFrom">
	<cfreturn "hello@cleancampus.co.uk">
</cffunction>

<cffunction name="LoadEmailServer">
	<cfreturn "smtp.gmail.com">
</cffunction>

<cffunction name="LoadEmailPort">
	<cfreturn "465">
</cffunction>

<cffunction name="LoadEmailUsername">
	<cfreturn "hello@raiseatree.co.uk">
</cffunction>

<cffunction name="LoadEmailPassword">
	<cfreturn "manutd88">
</cffunction>

<cffunction name="LoadSiteURL">
	<cfreturn "http://#CGI.SERVER_NAME#:#CGI.SERVER_PORT#">
</cffunction>