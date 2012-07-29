<cfoutput>
	
	#errorMessagesFor("data.comment")#
	
	<fieldset>
		<legend>Add Comment</legend>

		<p class="cb">
			#textarea(objectName="data.comment", property="comment", 
				labelPlacement="before", label="<span>Comment#imageTag('req.png')#<br/></span>", 
				class="textfield", cols="50", rows="4")#
		</p>
	
		<p>
			#hiddenField(objectName="data.comment", property="problemID")#
			#hiddenField(objectName="data.comment", property="userID")#
		</p>
		
	</fieldset>

</cfoutput>