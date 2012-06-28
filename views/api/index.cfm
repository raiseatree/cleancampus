<!---><cfparam name="apiuser">--->

<cfoutput>

	<!--->#startFormTag(controller="apiuser", action="add")#
	
		<p>#textField(objectName="apiuser", property="username", label="Username")#</p>
		<p>#submitTag(name="btnSubmit", class="submit", value="Add API User")#</p>
	
	#endFormTag()#--->
	
	<ul>
		<li>#linkTo(controller="university", action="view", text="*API* - Load Universities")#</li>
		<li>#linkTo(controller="reporter", action="new", text="*API* - New Reporter")#</li>
		<li>#linkTo(controller="problem", action="new", text="*API* - New Problem")#</li>	
		<li>#linkTo(controller="main", action="new", text="*API* - First Run")#</li>	
	</ul>


</cfoutput>