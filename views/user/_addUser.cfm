<cfparam name="data">
<cfoutput>

	#startFormTag(controller="user", action="add")#
		#errorMessagesFor("data.newUser")#
		
		<fieldset>
			<legend>Personal Details</legend>
			<p>#textField(objectName="data.newUser", property="firstname", label="<span>First Name<br/></span>", labelPlacement="before", class="textfield")#</p>
			<p class="cb">#textField(objectName="data.newUser", property="surname", label="<span>Surname<br/></span>", labelPlacement="before", class="textfield")#</p>
			<p class="cb">#textField(objectName="data.newUser", property="email", label="<span>Email<br/></span>", labelPlacement="before", class="textfield")#</p>
			<p class="cb">#passwordField(objectName="data.newUser", property="password", label="<span>Password<br/></span>", labelPlacement="before", class="textfield")#</p>
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
			#hiddenField(objectName="data.newUser", property="ID")#
			#hiddenField(objectName="data.newUser", property="universityID")#
			#submitTag(name="submit", class="activeButton", value="Add User")#
		</p>
	#endFormTag()#

</cfoutput>