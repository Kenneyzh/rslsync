<title>软件中心 - rslsync</title>
<content>
<script type="text/javascript">
getAppData();
var Apps;
function getAppData(){
var appsInfo;
	$.ajax({
	  	type: "GET",
	 	url: "/_api/rslsync_",
	  	dataType: "json",
	  	async:false,
	 	success: function(data){
	 	 	Apps = data.result[0];
	  	}
	});
}
if (Apps.rslsync_webui == undefined||rslsync_webui == null){
		Apps.rslsync_webui = '--';
	}
//console.log('Apps',Apps);
//数据 -  绘制界面用 - 直接 声明一个 Apps 然后 post 到 sh 然后 由 sh 执行 存到 dbus
function verifyFields(focused, quiet){
	var port =E('_rslsync_port').value ;
    if(port < 1024 || port > 65535){
        alert("端口应设置为1024-65535之间");
    }
	return 1;
}
function save(){
	Apps.rslsync_enable = E('_rslsync_enable').checked ? '1':'0';
	Apps.rslsync_wan_enable = E('_rslsync_wan_enable').checked ? '1':'0';
	Apps.rslsync_port = E('_rslsync_port').value;
	//Apps.rslsync_sk = E('_rslsync_sk').value;
	//left>down>Apps.rslsync_up = E('_rslsync_up').value;
	//left>down>Apps.rslsync_interval = E('_rslsync_interval').value;
	//left>down>Apps.rslsync_domain = E('_rslsync_domain').value;
	//left>down>Apps.rslsync_dns = E('_rslsync_dns').value;
	//left>down>Apps.rslsync_curl = E('_rslsync_curl').value;
	//Apps.rslsync_ttl = E('_rslsync_ttl').value;
	//-------------- post Apps to dbus ---------------
	var id = 1 + Math.floor(Math.random() * 6);
	var postData = {"id": id, "method":'rslsync_config.sh', "params":[], "fields": Apps};
	var success = function(data) {
		//
		$('#footer-msg').text(data.result);
		$('#footer-msg').show();
		setTimeout("window.location.reload()", 3000);

		//  do someting here.
		//
	};
	var error = function(data) {
		//
		//  do someting here.
		//
	};
	$('#footer-msg').text('保存中……');
	$('#footer-msg').show();
	$('button').addClass('disabled');
	$('button').prop('disabled', true);
	$.ajax({
	  type: "POST",
	  url: "/_api/",
	  data: JSON.stringify(postData),
	  success: success,
	  error: error,
	  dataType: "json"
	});
	
	//-------------- post Apps to dbus ---------------
}
</script>
<div class="box">
<div class="heading">rslsync <a href="javascript:history.back()" class="btn" style="float:right;border-radius:3px;">返回</a></div>
<br><hr>
<div class="content">
<div id="rslsync-fields"></div>
<script type="text/javascript">
$('#rslsync-fields').forms([
{ title: '开启rslsync', name: 'rslsync_enable', type: 'checkbox', value: ((Apps.rslsync_enable == '1')? 1:0)},
{ title: '外网访问Web', name: 'rslsync_wan_enable', type: 'checkbox', value: ((Apps.rslsync_wan_enable == '1')? 1:0)},
//{ title: '运行状态', name: 'rslsync_last_act', text: Apps.rslsync_last_act ||'--' },
{ title: 'Web访问端口', name: 'rslsync_port', type: 'text', maxlen: 5, size: 5, value: Apps.rslsync_port || "8856" },
{ title: 'Web控制页面', name: 'rslsync_webui', text: '<a style="font-size: 14px;" href="'+Apps.rslsync_webui+'" target="_blank">'+Apps.rslsync_webui+'</a>' ||'--' },
//{ title: '启动方式', name: 'rslsync_up', type: 'select', options:upoption_mode,value:Apps.rslsync_up || '2'},
//{ title: '检查周期', name: 'rslsync_interval', type: 'text', maxlen: 5, size: 5, value: Apps.rslsync_interval || '5',suffix:'分钟(当启动方式为WAN UP时，此选项无效)'},
]);
</script>
</div>
</div>
<button type="button" value="Save" id="save-button" onclick="save()" class="btn btn-primary">保存 <i class="icon-check"></i></button>
<button type="button" value="Cancel" id="cancel-button" onclick="javascript:reloadPage();" class="btn">取消 <i class="icon-cancel"></i></button>
<span id="footer-msg" class="alert alert-warning" style="display: none;"></span>
<script type="text/javascript">verifyFields(null, 1);</script>
</content>
