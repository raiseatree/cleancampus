<cfparam name="data">

<cfoutput>
<section id="main">
				
	#loadLoggedInHeader()#
	
	<h1>Edit User</h1>
	
	<section class="postRibbon">
	
		#startFormTag(controller="user", action="update")#
			#errorMessagesFor("data.editUser")#
			
			<fieldset>
				<legend>Personal Details</legend>
				<p>#textField(objectName="data.editUser", property="firstname", label="<span>First Name<br/></span>", labelPlacement="before", class="textfield")#</p>
				<p class="cb">#textField(objectName="data.editUser", property="surname", label="<span>Surname<br/></span>", labelPlacement="before", class="textfield")#</p>
				<p class="cb">#textField(objectName="data.editUser", property="email", label="<span>Email<br/></span>", labelPlacement="before", class="textfield")#</p>
			</fieldset>
			
			<fieldset>
				<legend>Assigned Categories</legend>
				<cfloop query="data.categories">
					<span class="checkboxList">
						<cfif listContainsNoCase(data.editUserCategories, typelabel, ',')>
							#checkboxTag(name="problemtypes[#id#]", label="#typelabel#", labelPlacement="after", append=" ", checked=true, value=typeLabel)#
						<cfelse>
							#checkboxTag(name="problemtypes[#id#]", label="#typelabel#", labelPlacement="after", append=" ", value=typeLabel)#
						</cfif>
					</span>
				</cfloop>
			</fieldset>		
			
			
			<p>
				#hiddenField(objectName="data.editUser", property="ID")#
				#submitTag(name="submit", class="activeButton", value="Update User")#
			</p>
		#endFormTag()#
	
	</section>
</section>
</cfoutput>