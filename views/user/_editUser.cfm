<cfoutput>
	#startFormTag(controller="user", action="update", autocomplete="off")#
		#errorMessagesFor("data.editUser")#
		
		<fieldset>
			<legend>Personal Details</legend>
			<p>#textField(objectName="data.editUser", property="firstname", label="<span>First Name<br/></span>", labelPlacement="before", class="textfield")#</p>
			<p class="cb">#textField(objectName="data.editUser", property="surname", label="<span>Surname<br/></span>", labelPlacement="before", class="textfield")#</p>
			<p class="cb">#textField(objectName="data.editUser", property="email", label="<span>Email<br/></span>", labelPlacement="before", class="textfield")#</p>
			<p class="cb"><a href="##" class="showPasswordOpts">Show Change Password Options</a></p>
			<div class="showPassword hidden">
				<p class="cb">#passwordFieldTag(name="editUser[newPassword]", label="<span>New Password<br/></span>", labelPlacement="before", class="textfield")#</p>
				<p class="cb">#passwordFieldTag(name="editUser[newPassword2]", label="<span>Verify Password<br/></span>", labelPlacement="before", class="textfield")#</p>
			</div>
		</fieldset>
		
		<cfif data.editCategories EQ true>
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
		</cfif>
		
		<p>
			#hiddenField(objectName="data.editUser", property="ID")#
			#submitTag(name="submit", class="activeButton", value="Update User")#
		</p>
	#endFormTag()#
	
	<script language="javascript" type="text/javascript">
		$(document).ready(function() {
			$('.showPasswordOpts').click(function() {
				$('.showPasswordOpts').hide();
				$('.showPassword').show();
			});
		});
		
	</script>
</cfoutput>