<%--
  Created by IntelliJ IDEA.
  User: 同创
  Date: 2022/11/22
  Time: 9:43
  To change this template use File | Settings | File Templates.
--%>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%
    String path = request.getContextPath();
    String basePath = request.getScheme() + "://" + request.getServerName() + ":" + request.getServerPort()+path+"/";
%>
<html>
<head>
    <base href="<%=basePath %>">
    <title>Title</title>
</head>
<body>

</body>
</html>
