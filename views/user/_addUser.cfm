<cfparam name="data">
<cfoutput>

	#startFormTag(controller="user", action="add")#
		#errorMessagesFor("data.user")#
		
		<fieldset>
			<legend>Personal Details</legend>
			<p>#textField(objectName="data.user", property="firstname", label="<span>First Name<br/></span>", labelPlacement="before", class="textfield")#</p>
			<p class="cb">#textField(objectName="data.user", property="surname", label="<span>Surname<br/></span>", labelPlacement="before", class="textfield")#</p>
			<p class="cb">#textField(objectName="data.user", property="email", label="<span>Email<br/></span>", labelPlacement="before", class="textfield")#</p>
			<p class="cb">#passwordField(objectName="data.user", property="password", label="<span>Password<br/></span>", labelPlacement="before", class="textfield")#</p>
		</fieldset>
		
		<fieldset>
			<legend>Assigned Categories</legend>
			<cfloop query="data.categories">
				<span class="checkboxList">
					#checkboxTag(name="problemtypes[#id#]", label="#typelabel#", labelPlacement="after", append=" ", value=typeLabel)#
				</span>
			</cfloop>
		</fieldset>		
		
		<p class="overflow">
			#hiddenField(objectName="data.user", property="ID")#
			#hiddenField(objectName="data.user", property="universityID")#
			#submitTag(name="submit", class="activeButton", value="Add User")#
		</p>
	#endFormTag()#

</cfoutput>