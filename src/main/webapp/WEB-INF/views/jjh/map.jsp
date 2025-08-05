<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ include file="/WEB-INF/views/header.jsp" %>
<!DOCTYPE html>
<html>
<head>
	<meta charset="utf-8"/>
	<title>Map</title>
</head>
<body>
	<div id="map" style="width:500px;height:400px;"></div>
	<script type="text/javascript" src="//dapi.kakao.com/v2/maps/sdk.js?appkey=355b679f9ec17e7c677b8177cc2b3695"></script>
	<script>
		var container = document.getElementById('map');
		var options = {
			center: new kakao.maps.LatLng(37.489996, 126.927081),
			level: 3
		};

		var map = new kakao.maps.Map(container, options);
	</script>
</body>
</html>