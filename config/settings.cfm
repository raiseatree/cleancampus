<!--- Datasource --->
<cfset set(dataSourceName="cleancampus")>

<!--- Add password to stop application reloading itself --->
<cfset set(reloadPassword="raiseatree")>

<!--- Define mail settings --->
<cfset set(
    functionName="sendEmail",
	server="smtp.gmail.com",
	port="465",
    username="hello@raiseatree.co.uk",
    password="manutd88",
	useSSL="true"
)>