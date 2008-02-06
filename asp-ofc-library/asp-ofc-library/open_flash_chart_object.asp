<%
open_flash_chart_seqno = 0

function open_flash_chart_object_str(width, height, url, use_swfobject, base)
	'defaults
	if use_swfobject = "" then use_swfobject=true
	
    'return the HTML as a string
    open_flash_chart_object_str = ofc(width, height, url, use_swfobject, base)
end function

function open_flash_chart_object( width, height, url, use_swfobject, base)
	'defaults
	if use_swfobject = "" then use_swfobject=true
	
    'stream the HTML into the page
    response.write ofc( width, height, url, use_swfobject, base)
end function

function ofc(width, height, url, use_swfobject, base)
	'encode the URL
	dataurl = server.URLEncode(url)
	'check for HTTP or HTTPS
	if ucase(request.ServerVariables("HTTPS")) = "ON" then
		protocol="https:"
	else
		protocol="http:"
	end if

	
	
	'allow for more than one chart on a page, and assigne a unique name for each chart
	if open_flash_chart_seqno = 0 then
		ofc = "<script type='text/javascript' src='" & base & "js/swfobject.js'></script>" & vbCRLF
	end if
	
	obj_id = "chart_" & open_flash_chart_seqno
	div_name = "flashcontent_" & open_flash_chart_seqno
	open_flash_chart_seqno = open_flash_chart_seqno + 1
	if(use_swfobject) then
		'Using library for auto-enabling Flash object on IE, disabled-Javascript proof  
	    ofc = ofc & "<div id=" & div_name & "></div>" & vbCRLF
		ofc = ofc & "<script type=""text/javascript"">" & vbCRLF
		ofc = ofc & vbtab & "var so = new SWFObject(""" & base & "open-flash-chart.swf"", " & obj_id & ", " & width & ", " & height & ", ""9"", ""#FFFFFF"");" & vbCRLF
		ofc = ofc & vbtab & "so.addVariable(""width"", '" & width & "');" & vbCRLF
		ofc = ofc & vbtab & "so.addVariable(""height"", '" & height & "');" & vbCRLF
		ofc = ofc & vbtab & "so.addVariable(""data"", '" & dataurl & "');" & vbCRLF
		ofc = ofc & vbtab & "so.addParam(""allowScriptAccess"", ""sameDomain"");" & vbCRLF
		ofc = ofc & vbtab & "so.write('" & div_name & ");" & vbCRLF
		ofc = ofc & "</script>" & vbCRLF
		ofc = ofc & "<noscript>" & vbCRLF
	end if

	ofc = ofc & "<object classid=""clsid:d27cdb6e-ae6d-11cf-96b8-444553540000"" codebase=""" & protocol & "//fpdownload.macromedia.com/pub/shockwave/cabs/flash/swflash.cab#version=8,0,0,0""" & vbCRLF
	ofc = ofc & "width=""" & width & """ height=""" & height & """ id=""ie_" & obj_id & """ align=""middle"">" & vbCRLF
	ofc = ofc & vbtab & "<param name=""allowScriptAccess"" value=""sameDomain"" />" & vbCRLF
	ofc = ofc & vbtab & "<param name=""movie"" value=""" & base & "open-flash-chart.swf?width=" & width & "&height=" & height & "&data=" & dataurl & """ />" & vbCRLF
	ofc = ofc & vbtab & "<param name=""quality"" value=""high"" />" & vbCRLF
	ofc = ofc & vbtab & "<param name=""bgcolor"" value=""#FFFFFF"" />" & vbCRLF
	ofc = ofc & vbtab & "<embed src=""" & base & "open-flash-chart.swf?data=" & dataurl & """ quality=""high"" bgcolor=""#FFFFFF"" width=""" & width & """ height=""" & height & """ name=""" & obj_id & """ align=""middle"" allowScriptAccess=""sameDomain"" " & vbCRLF
	ofc = ofc & vbtab & vbtab & "type=""application/x-shockwave-flash"" pluginspage=""" & protocol & "//www.macromedia.com/go/getflashplayer"" id=""" & obj_id & """/>" & vbCRLF
	ofc = ofc & "</object>" & vbCRLF

	if(use_swfobject) then
		ofc = ofc & "</noscript>" & vbCRLF
	end if
	
end function
%>