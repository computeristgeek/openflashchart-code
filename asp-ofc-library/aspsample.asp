<% Language = VBSCRIPT %>
<!--#INCLUDE FILE="asp-ofc-library/open_flash_chart_object.asp"-->

<html><head></head><body>
<%
	response.write "<H1>Source Data:" & sourcedata & "</H1>"
	open_flash_chart_object 500, 250, "http://" & request.ServerVariables("SERVER_NAME") & "/data-files/data-47.txt", false, "/" 
	open_flash_chart_object 500, 250, "http://" & request.ServerVariables("SERVER_NAME") & "/data-files/data-55.txt", false, "/" 
	open_flash_chart_object 500, 250, "http://" & request.ServerVariables("SERVER_NAME") & "/data-files/data-54.txt", false, "/" 
%>

</body></html>