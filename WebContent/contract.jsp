<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.io.*,java.util.*,java.sql.*,java.net.*"%>
<%@ page import="javax.servlet.http.*,javax.servlet.*"%>
<%@ page import="java.text.SimpleDateFormat"%><!-- JSP時間轉換格式 -->
<%@ page import="java.lang.Math"%><!-- 處理long類型計算的套件 -->
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
	<title>簽署合約</title>
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
            background-color:rgba(225,245,241,0.947);
            }
	</style>
</head>
<body>
	<br>
	<h1 align="center"><span style="font-weight:bold;">租賃條約</span></h1>
	<div class="container-fluid" id="align_center">
		<div class="row">
			<div class="col-2"></div><!-- 空白部分 -->
			<div class="col-8">
				<h3><span style="font-weight:bold;">本服務內容</span></h3>
				<p>在租賃期間內，凡參與本服務之顧客得享有以下服務：</p>
				<p>1、組裝服務</p>
				<p>於租賃合約開始前協助安排一次家具組裝服務，並於租賃合約終止後自租賃地點收回租賃家具。於租賃家具送達並完成全部組裝之日，會與顧客共同確認商品狀態並拍照存檔以完成驗收手續。</p>
    			<p>2、維修替換服務</p>
    			<p>如有任何租賃家具之維修需求，請透過官方網站通知服務人員辦理，以確保家具以正確方式維修及拆組。</p>
    			<p>3、額外收費事項：</p>
    			<p>以上組裝服務不包含運送/回收等其他服務費用，請於簽訂合約時，繳納運費之款項</p>
    			<h3><span style="font-weight:bold;">租賃家具使用與損害賠償</span></h3>
    			<p></p>
   				<p>1、妥善使用</p>
    			<p>租賃期間內，顧客應對租賃家具保管、使用盡善良管理人之注意責任，並按商品使用及保養手冊內容，正確使用及維護租賃家具，顧客如故意或過失侵害之財產與權利應負損害賠償之責。</p>
    			<p>2、租賃家具人為損害賠償</p>
    			<p>租賃期間相關人為損壞，顧客須負賠償責任，並應立即向本公司報修。</p>
    			<h3><span style="font-weight:bold;">品質及保證</span></h3>
    			<p>1、品質及爭議判定</p>
    			<p>本服務租賃家具為顧客自選之標準優質商品，如有任何相關租賃家具品質、損壞或使用等爭議發生時，其適用之保固條件、損壞原因判定，悉由家具產品製造商提供之方案設計及判定為最終標準。</p>
    			<p>2、同級品替換</p>
    			<p>原指定品牌家具、耗材或飾品等如因故無法替換時，本公司得以提供同級品替換或逕減收相關費用等方式向顧客履行或延續本服務。</p>
    			<h3><span style="font-weight:bold;">租賃家具返還</span></h3>
    			<p>租賃合約期滿或終止時，顧客應恢復租賃家具外觀、功能及配件完整，並合於正常使用之狀態，且不得殘留異味(含煙味)、髒污、文字、記號或破損。顧客返還租賃家具時，如有上述情況，本公司得報價向顧客收取清潔費或修復費用。<p>
    		</div>
    		<div class="col-2"></div><!-- 空白部分 -->
    	</div>
    </div>
    <br>
	<!-- 引用Bootstrap -->
	<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0-alpha1/dist/js/bootstrap.bundle.min.js" integrity="sha384-w76AqPfDkMBDXo30jS1Sgez6pr3x5MlQ1ZAGC+nuZB+EYdgRZgiwxhTBTkF7CXvN" crossorigin="anonymous"></script>
	<script src="https://cdn.jsdelivr.net/npm/@popperjs/core@2.11.6/dist/umd/popper.min.js" integrity="sha384-oBqDVmMz9ATKxIep9tiCxS/Z9fNfEXiDAYTujMAeBAsjFuCZSmKbSSUnQlmh/jp3" crossorigin="anonymous"></script>
    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0-alpha1/dist/js/bootstrap.min.js" integrity="sha384-mQ93GR66B00ZXjt0YO5KlohRA5SY2XofN4zfuZxLkoj1gXtW8ANNCe9d5Y3eG5eD" crossorigin="anonymous"></script>
</body>
</html>