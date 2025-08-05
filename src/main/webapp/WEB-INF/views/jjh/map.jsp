<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ include file="/WEB-INF/views/header.jsp" %>
<!DOCTYPE html>
<html>
<head>
	<meta charset="utf-8"/>
	<title>Map</title>
	<style>
        html, body {
            margin: 0;
            padding: 0;
            height: 100%;
            overflow: hidden;
        }
    </style>
</head>
<body>
	<div id="map" style="width:100vw; height:100%;"></div>
	<script type="text/javascript" src="//dapi.kakao.com/v2/maps/sdk.js?appkey=355b679f9ec17e7c677b8177cc2b3695"></script>
	<script>

        if (navigator.geolocation) {
          navigator.geolocation.getCurrentPosition(function (position) {
            const lat = position.coords.latitude;
            const lon = position.coords.longitude;

            // 원래 기준 offsetLat = 0.00345
            const offsetLat = 0.0033;
            const offsetLon = 0.01285;

            const locPosition = new kakao.maps.LatLng(lat + offsetLat, lon - offsetLon);
            const mapContainer = document.getElementById('map');
            const mapOption = {
              center: locPosition,
              level: 1
            };

            const map = new kakao.maps.Map(mapContainer, mapOption);

            }, function (error) {
                    alert('위치 정보를 가져올 수 없습니다.');
                    console.error(error);
               });
            } else {
              alert('이 브라우저는 위치 기능을 지원하지 않습니다.');
            }
	</script>
</body>
</html>