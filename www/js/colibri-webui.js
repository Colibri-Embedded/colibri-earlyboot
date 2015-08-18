var reloadTimer = null;
var ajaxIsBusy = false;
var ajaxWaitingFor = null;
var queryQueue = null;
var userResponse = false;
var pollingTheInstaller = 0;

function addCSSClassToElementsStartsWithId( id, cssClass ) {
	var children = document.body.getElementsByTagName('*');
	var child;
	for (var i = 0, length = children.length; i < length; i++) {
		child = children[i];
		if (child.id.substr(0, id.length) == id)
		{
			child.classList.add(cssClass);
		}
	}
}

function setCSSClassToElementsStartsWithId( id, cssClass ) {
	var children = document.body.getElementsByTagName('*');
	var child;
	for (var i = 0, length = children.length; i < length; i++) {
		child = children[i];
		if (child.id.substr(0, id.length) == id)
		{
			child.className = cssClass;
		}
	}
}

function myTimer()
{
	if(ajaxWaitingFor == null)
	{
		ajaxWaitingFor = "get";
		loadXMLDoc("cgi-bin/webui.cgi?GET");
	}
}

function scheduleReload()
{
	clearInterval(reloadTimer);
	reloadTimer = setTimeout(function(){myTimer()},600);
}

function webuiResponde(item_id, resp)
{	
	resp_escaped = escape(resp);
	queryString = "cgi-bin/webui.cgi?SET&id=" + item_id + "&value=" + resp_escaped;
	if(ajaxWaitingFor == "get")
		ajaxWaitingFor = "drop";
	else
		ajaxWaitingFor = "set";
		
	setCSSClassToElementsStartsWithId("item"+item_id, "pure-button pure-button-disabled");
	
	loadXMLDoc(queryString);
}

function loadXMLDoc(query_string, callback)
{
	var xmlhttp;
	
	if(ajaxIsBusy == true)
	{
		if(queryQueue == null)
		{
			queryQueue = query_string;
		}
		return;
	}
	
	if (window.XMLHttpRequest)
	{// code for IE7+, Firefox, Chrome, Opera, Safari
		xmlhttp=new XMLHttpRequest();
	}
	else
	{// code for IE6, IE5
		xmlhttp=new ActiveXObject("Microsoft.XMLHTTP");
	}
	xmlhttp.onreadystatechange=function()
	{
		if (xmlhttp.readyState==4)
		{
			if(xmlhttp.status==200)
			{
				if(ajaxWaitingFor != "drop") {
					if ('function' == typeof callback)
						callback(null, xmlhttp);
					else
						document.getElementById("webui-content").innerHTML=unescape(xmlhttp.responseText);
				} else {
					ajaxWaitingFor = "set";
				}
			}
			else
			{
				if ('function' == typeof callback) {
					callback(xmlhttp, null);
				} else if (!(pollingTheInstaller++)) {
					setTimeout(pollInstaller, 1);
					document.getElementById("webui-content").innerHTML='<div><i class="fa fa-cog rotating fa-fw"></i>Booting the system for next step...</div>';
				} else {
					document.getElementById("webui-content").innerHTML="<div>WebUI connection error.</div>";
				}
			}
			ajaxIsBusy = false;
			if(queryQueue != null)
			{
				loadXMLDoc(queryQueue);
				queryQueue = null;
			}
			else
			{
				scheduleReload();
			}
			
			ajaxWaitingFor = null;
		}
		
	}
	ajaxIsBusy = true;
	xmlhttp.open("GET",query_string,true);
	xmlhttp.send();
}

/* maybe embed method and conf in object literal */
pollInstaller.timeout = 1000;
pollInstaller.url = 'recovery/install/';
function pollInstaller ()
{
	loadXMLDoc(pollInstaller.url, function (err, res) {
		if (err) {
			console.error(err);
			setTimeout(pollInstaller, pollInstaller.timeout);
		} else {
			window.location.assign(pollInstaller.url);
		}
	});
}
