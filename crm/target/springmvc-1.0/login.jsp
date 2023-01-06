<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%
    String path = request.getContextPath();
    String basePath = request.getScheme() + "://" + request.getServerName() + ":" + request.getServerPort() + path + "/";
%>
<!DOCTYPE html>
<html>
<head>
    <base href="<%=basePath%>">
    <meta charset="UTF-8">
    <link href="jquery/bootstrap_3.3.0/css/bootstrap.min.css" type="text/css" rel="stylesheet"/>
    <script type="text/javascript" src="jquery/jquery-1.11.1-min.js"></script>
    <script type="text/javascript" src="jquery/bootstrap_3.3.0/js/bootstrap.min.js"></script>
    <script>
        function login() {
            //验证账号密码不为空
			//获取账号密码
			//使用$.trim()将文本的左右空格去掉
			var loginAct = $.trim($("#loginAct").val());
			var loginPwd = $.trim($("#loginPwd").val());

			if (loginAct==""||loginPwd==""){
				$("#msg").html("账号密码不能为空");
				return false;
			}

			//后台验证登录相关操作
			$.ajax({
				url : "settings/user/login.do",
				data : {
                    "loginAct" : loginAct,
					"loginPwd" : loginPwd
				},
				type : "POST",
				dataType : "json",
				success : function (data) {
					/*
					         data
					         后端传过来的json串
					         {"success":true/false}
					 */
					if (data.success){
						//如果登录成功。跳转到工作台初始页（欢迎页）
						window.location.href = "workbench/index.jsp";

					}else {
						//如果登录失败
						$("#msg").html(data.msg);
					}

				}

			})
        }

        $(function () {
            if (window.top!=window){
                window.top.location = window.location;
            }
            //获得焦点
            $("#loginAct").focus();

            //给登录按钮添加点击事件   执行登录操作
            $("#btn").click(function () {
                login();
            })

            $(window).keydown(function (event) {
                //alert(event.keyCode);  输出键位码
                //当键位码为13是为回车键
                if (event.keyCode == 13) {
                    //执行登录操作
                    login();
                }
            })
        })
    </script>
</head>
<body>
<div style="position: absolute; top: 0px; left: 0px; width: 60%;">
    <img src="image/IMG_7114.JPG" style="width: 100%; height: 90%; position: relative; top: 50px;">
</div>
<div id="top" style="height: 50px; background-color: #3C3C3C; width: 100%;">
    <div style="position: absolute; top: 5px; left: 0px; font-size: 30px; font-weight: 400; color: white; font-family: 'times new roman'">
        CRM &nbsp;<span style="font-size: 12px;">&copy;2017&nbsp;动力节点</span></div>
</div>

<div style="position: absolute; top: 120px; right: 100px;width:450px;height:400px;border:1px solid #D5D5D5">
    <div style="position: absolute; top: 0px; right: 60px;">
        <div class="page-header">
            <h1>登录</h1>
        </div>
        <form action="workbench/index.jsp" class="form-horizontal" role="form">
            <div class="form-group form-group-lg">
                <div style="width: 350px;">
                    <input class="form-control" type="text" placeholder="用户名" id="loginAct">
                </div>
                <div style="width: 350px; position: relative;top: 20px;">
                    <input class="form-control" type="password" placeholder="密码" id="loginPwd">
                </div>
                <div class="checkbox" style="position: relative;top: 30px; left: 10px;">

                    <span id="msg" style="color: red"></span>

                </div>
                <button type="button" id="btn" class="btn btn-primary btn-lg btn-block"
                        style="width: 350px; position: relative;top: 45px;">登录
                </button>
            </div>
        </form>
    </div>
</div>
</body>
</html>