<%@ page contentType="text/html;charset=UTF-8" language="java"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<%@ taglib prefix="security" uri="http://www.springframework.org/security/tags"%>
<!DOCTYPE html>
<html lang="en">
<head>
<meta charset="UTF-8">
<title>접근 거부</title>
<script>
	alert('${msg}');
	location.href = '${url}';
</script>
</head>
<body>
	<h2>권한이 부족합니다.</h2>
</body>
</html>