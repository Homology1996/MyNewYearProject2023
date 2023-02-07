<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.io.*,java.util.*,java.sql.*,java.net.*"%>
<%@ page import="javax.servlet.http.*,javax.servlet.*" %>
<%@ page import="java.text.SimpleDateFormat" %><!-- JSP時間轉換格式 -->
<%@ page import="java.lang.Math" %><!-- 處理long類型計算的套件 -->
<!-- 引入JSTL -->
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="x" uri="http://java.sun.com/jsp/jstl/xml" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<%@ taglib prefix="sql" uri="http://java.sun.com/jsp/jstl/sql" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<!DOCTYPE html>
<html>
<head>
	<meta charset="UTF-8">
	<meta name="viewport" content="width=device-width, initial-scale=1.0">
	<title>資料修改</title>
	<!-- 引用Bootstrap -->
	<link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0-alpha1/dist/css/bootstrap.min.css" rel="stylesheet" integrity="sha384-GLhlTQ8iRABdZLl6O3oVMWSktQOp6b7In1Zl3/Jr59b6EGGoI1aFkw7cmDA6j6gD" crossorigin="anonymous">
	<!-- 引用外部css -->
	<link rel="stylesheet" href="css/BodyDefault.css">
	<!-- 引用外部javascript -->
	<script src="scripts/GetCookie.js"></script>
	<script src="scripts/SetCookie.js"></script>
	<!-- 引用jQuery -->
	<script src="scripts/jquery.min.js"></script>
	<script src="scripts/jquery.cookie.js"></script>
	<!-- 下拉式選單需要的腳本 -->
	<script src="scripts/popper.min.js"></script>
	<!-- Bootstrap時間挑選器 -->
	<link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/bootstrap-datepicker/1.9.0/css/bootstrap-datepicker3.min.css">
	<script src="https://cdnjs.cloudflare.com/ajax/libs/bootstrap-datepicker/1.9.0/js/bootstrap-datepicker.min.js"></script>
	<style>
		body{
            background-image:url("images/back.png");
            background-size:cover;
        }
	</style>
</head>
<body>
	<div class="container">
		<div class="row">
			<div class="col-3">
				<button type="button" class="btn">
					<h3>資料修改</h3>
				</button>
			</div>
			<div class="col-6"></div>
			<div class="col-3">
				<button type="button" class="btn" onclick="javascript:Return();">
					<script>
						function Return(){
							window.location.assign("index.html");
						}
					</script>
					<h3>返回首頁</h3>
				</button>
			</div>
		</div>
	</div>
	<c:set var="param_account" value="${param['account']}"/>
	<div class="container">
		<form action="revise_member.jsp" method="get">
			<input type="hidden" name="revise_account" value="${param_account}">
			<table class="table">
				<tr>
					<td>姓名</td>
					<td><input type="text" name="revise_name" placeholder="請輸入姓名"></td>
				</tr>
				<tr>
					<td>電話</td>
					<td><input type="text" name="revise_phone" placeholder="請輸入電話"></td>
				</tr>
				<tr>
					<td>地址</td>
					<td><input type="text" name="revise_address" placeholder="請輸入地址"></td>
				</tr>
				<tr>
					<td>密碼</td>
					<td><input type="text" name="revise_password" placeholder="請輸入密碼"></td>
				</tr>
				<tr>
					<td><button type="reset">重設</button></td>
					<td>
						<button type="button" name="check" id="check">送出</button>
						<input type="reset" id="cancel" value="取消">
						<input type="submit" name="submit" id="submit" value="確認">
					</td>
				</tr>
			</table>
		</form>
	</div>
	<script>
		$(document).ready(function(){
			$("#cancel").hide();          //一開始先把按鍵藏起來
			$("#submit").hide();
			$("#check").click(function(){ //按下送出時，再把按鈕顯示出來
				$("#cancel").toggle(500);
				$("#submit").toggle(500);
			});
		});
	</script>
	<!-- 引用Bootstrap -->
	<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0-alpha1/dist/js/bootstrap.bundle.min.js" integrity="sha384-w76AqPfDkMBDXo30jS1Sgez6pr3x5MlQ1ZAGC+nuZB+EYdgRZgiwxhTBTkF7CXvN" crossorigin="anonymous"></script>
	<script src="https://cdn.jsdelivr.net/npm/@popperjs/core@2.11.6/dist/umd/popper.min.js" integrity="sha384-oBqDVmMz9ATKxIep9tiCxS/Z9fNfEXiDAYTujMAeBAsjFuCZSmKbSSUnQlmh/jp3" crossorigin="anonymous"></script>
    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0-alpha1/dist/js/bootstrap.min.js" integrity="sha384-mQ93GR66B00ZXjt0YO5KlohRA5SY2XofN4zfuZxLkoj1gXtW8ANNCe9d5Y3eG5eD" crossorigin="anonymous"></script>
</body>
</html>