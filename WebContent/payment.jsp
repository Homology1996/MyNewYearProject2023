<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.io.*,java.util.*,java.sql.*,java.net.*"%>
<%@ page import="javax.servlet.http.*,javax.servlet.*" %>
<%@ page import="java.text.SimpleDateFormat" %>
<%@ page import="java.lang.Math" %>
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
	<title>付款頁面</title>
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
        #div_all{
        	width:100%;
        	height:80%;
        	margin:0 auto;
        	text-align:center;
        }
	</style>
</head>
<body>
	<c:set var="id_Value_list"/>
	<c:set var="Price" value="${0}"/>
	<!-- 讀取表單送出資訊 -->
	<%
	/*找出表單送出的所有變數與數值，並且把結果儲存到一個list裡面。奇數項為名稱，偶數項為數值*/
	/*在JSTL則是把結果儲存到一個字串，用逗點隔開項目。奇數項為名稱，偶數項為數值*/
	Enumeration ParameterNames=request.getParameterNames();
	List<String> id_value_list=new ArrayList<String>();
	while(ParameterNames.hasMoreElements()){
		String Id_value_list=(String)pageContext.getAttribute("id_Value_list");
		/*------------------------------------------------------*/
		String ParameterName=(String)ParameterNames.nextElement();
		String ParameterValue=request.getParameter(ParameterName);
		id_value_list.add(ParameterName.substring(5)); /*java物件*/
		id_value_list.add(ParameterValue);             /*java物件*/
		/*------------------------------------------------------*/
		Id_value_list=Id_value_list+","+ParameterName.substring(5)+"="+ParameterValue;
		pageContext.setAttribute("id_Value_list",Id_value_list);
	}
	/*刪除開頭的逗號*/
	String Id_value_list=(String)pageContext.getAttribute("id_Value_list");
	if(Id_value_list.length()>1){  /*1代表這個字串只有一個開頭的逗號*/
		Id_value_list=Id_value_list.substring(1);
		pageContext.setAttribute("id_Value_list",Id_value_list);
	}
	%>
	<!-- 把表單送的資料拆開來 -->
	<c:set var="ID_Value_list"/>
	<c:set var="Start_ID_list"/>
	<c:forTokens  var="name" delims="," items="${id_Value_list}">
		<c:choose>
			<c:when test="${fn:contains(name,'-')}">
				<%
				String start_id_list=(String)pageContext.getAttribute("Start_ID_list");
				String name=(String)pageContext.getAttribute("name");
				String alter=start_id_list+","+name;
				pageContext.setAttribute("Start_ID_list",alter);
				%>
			</c:when>
			<c:otherwise>
				<%
				String Myid_value_list=(String)pageContext.getAttribute("ID_Value_list");
				String name=(String)pageContext.getAttribute("name");
				String alter=Myid_value_list+","+name;
				pageContext.setAttribute("ID_Value_list",alter);
				%>
			</c:otherwise>
		</c:choose>
	</c:forTokens>
	<c:choose>
		<c:when test="${ID_Value_list.length()<4}"><!-- 如果遇到購物車都沒選就來按結帳，就使用此情況 -->
			<script>
				window.alert("空的購物車不能結帳喔~");
				window.location.assign("commodity.jsp");
			</script>
		</c:when>
		<c:otherwise>
			<!-- 去除開頭的逗號 -->
			<%
			String Myid_value_list=(String)pageContext.getAttribute("ID_Value_list");
			String Mystart_id_list=(String)pageContext.getAttribute("Start_ID_list");
			String id_value_delete_head=Myid_value_list.substring(1);
			String start_id_delete_head=Mystart_id_list.substring(1);
			pageContext.setAttribute("ID_Value_list",id_value_delete_head);
			pageContext.setAttribute("Start_ID_list",start_id_delete_head);
			%>
			<!-- 表單部分 -->
			<form action="bill.jsp" method="get">
				<br>
				<div class="container" id="div_all">
					<div class="row">
						<c:forTokens var="Item_Value" delims="," items="${ID_Value_list}"><!-- 先把項目清單拆開來 -->
							<c:set var="array" value="${fn:split(Item_Value,'=')}"/>
							<c:set var="ID" value="${array[0]}"/>
							<c:set var="Value" value="${array[1]}"/>
							<c:set var="InfoID"/>
							<c:set var="PicID"/>
							<c:set var="ImgID"/>
							<c:set var="StartID"/>
							<%
							String id=(String)pageContext.getAttribute("ID");
							String value=(String)pageContext.getAttribute("Value");
							String infoid="info"+id;
							String picid="pic"+id;
							String imgid="images/pic"+id+".jpg";
							String startid="Start"+id;
							pageContext.setAttribute("InfoID",infoid);
							pageContext.setAttribute("PicID",picid);
							pageContext.setAttribute("ImgID",imgid);
							pageContext.setAttribute("StartID",startid);
							%>
							<div class="col-6" id="${PicID}">
								<img src="${ImgID}" width="95%" height="95%">
							</div><!-- 對應到PicID -->
							<div class="col-6" id="${InfoID}">
								<br>
								<h3>商品編號 : <c:out value="${ID}"/></h3>
								<br>
								<h4>租期 : <c:out value="${Value}"/> 個月</h4>
								<c:set var="DataBaseName" value="newyear"/>
								<c:set var="DataBaseUserAccount" value="newyear"/>
								<c:set var="DataBaseUserPassword" value="newyear"/>
								<c:set var="DataBaseURL"/>
								<%
								String name=(String)pageContext.getAttribute("DataBaseName");
								String url="jdbc:mysql://localhost:3306/"+name;
								pageContext.setAttribute("DataBaseURL",url);
								%>
								<sql:setDataSource var="DataBase" driver="com.mysql.cj.jdbc.Driver"
								url="${DataBaseURL}" user="${DataBaseUserAccount}" password="${DataBaseUserPassword}"/>
    							<sql:query dataSource="${DataBase}" var="result">
			    					SELECT * FROM commodity;
								</sql:query>
								<!-- 租金部分 -->
								<c:forEach var="row" items="${result.rows}">
									<c:if test="${row.item_index==Integer.parseInt(ID)}">
										<c:forTokens var="name" delims="," items="${Start_ID_list}">
											<c:set var="array" value="${fn:split(name,'=')}"/>
											<c:if test="${array[0]==row.item_index}">
												<br>
												<h5>起始時間 : <c:out value="${array[1]}"/></h5>
												<!-- 使用折舊費率計算租金 -->
												<c:set var="New" value="${1.5}"/>
												<c:set var="Old" value="${0.7}"/>
												<c:set var="Cost" value="${row.cost}"/>
												<c:set var="Life_month" value="${row.Life_month}"/>
												<c:set var="item_rent_time"/>
												<c:forEach var="picklist" items="${ID_Value_list}">
													<c:set var="myarray" value="${fn:split(picklist,'=')}"/>
													<c:set var="array_name" value="${myarray[0]}"/>
													<c:set var="array_value" value="${myarray[1]}"/>
													<c:if test="${myarray[0]==row.item_index}">
														<%
														String str_item_rent_time=(String)pageContext.getAttribute("array_value");
														long ToLong=(long)Integer.parseInt(str_item_rent_time);
														int ToInt=Math.toIntExact(ToLong);/*把long轉換成int*/
														pageContext.setAttribute("item_rent_time",ToInt);
														%>
													</c:if>
												</c:forEach>
												<c:set var="Purchasetime" value="${row.purchasetime}"/>
												<c:set var="Start" value="${array[1]}"/>
												<!-- 顯示結束時間 -->
												<c:set var="month" value="${1000*60*60*24*30}"/>
												<fmt:parseDate type="both" value="${Start}" var="parsedStart" pattern="yyyy-MM-dd"/>
												<c:set var="End" value="${parsedStart}"/>
												<c:set target="${End}" property="time" value="${End.time+month*item_rent_time}"/>
												<h5>結束時間 : <fmt:formatDate value="${End}" pattern="yyyy-MM-dd" /></h5>
												<c:set var="ThisRent"/>
												<%!/*寫函數時記得加上!*/
												double rate(double New, double Old, int Life_month, String Purchasetime, String Now){
													long day=1000*60*60*24L;
													long month=day*30L;
													SimpleDateFormat formatter=new SimpleDateFormat("yyyy-MM-dd");/*格式化物件*/
													double rate=0.0;
													/*寫成函數時，要使用try,catch來處理字串轉換成時間時可能會出現的exception*/
													try {
											            java.util.Date parsedPurchasetime=formatter.parse(Purchasetime);
											            java.util.Date parsedNow=formatter.parse(Now);
											            /*算出特定日期距離1970-01-01有幾微秒*/
											            long Purchasetime_millisecond=parsedPurchasetime.getTime();
											            long Now_millisecond=parsedNow.getTime();
											            long Now_Pur_Diff_milli=Now_millisecond-Purchasetime_millisecond;
											            /*把上面的微秒換成月*/
											            double Now_Pur_Diff_month=(Now_Pur_Diff_milli/month);
											            if(Now_millisecond<Purchasetime_millisecond){
											    			/*對應到現在的時間比購買時間還早，也就是錯誤的時間*/
											    			rate=0.0;
											    		}
											    		else if(Now_millisecond<Purchasetime_millisecond+Life_month*month){
											    			/*對應到現在的時間落在起始與結束時間之內*/
											    			rate=New-((New-Old)*Now_Pur_Diff_month)/Life_month;
											    		}
											    		else{
											    			/*對應到現在的時間比預期壽命還大，那就直接回傳最舊的費率*/
											    			rate=Old;
											    		}
											        } 
													catch (java.text.ParseException e) {
											            e.printStackTrace();
											        }
													return rate;
												}
												double Summation(double New, double Old, int Cost, int Life_month, int item_rent_time, String Purchasetime, String Start){
													long month=1000*60*60*24*30L;
													SimpleDateFormat formatter = new SimpleDateFormat("yyyy-MM-dd");
													double average=Cost/Life_month;
													double sum=0.0;
													try{
														java.util.Date purchasetime = formatter.parse(Purchasetime);
													    java.util.Date start = formatter.parse(Start);
													    long purchasemillisec = purchasetime.getTime();
													    long startmillisec = start.getTime();
													    for(int i=0;i<item_rent_time;i++){
													    	long nowmillisec=startmillisec+i*month;
													    	java.util.Date milli_to_date = new java.util.Date(nowmillisec);  
													        String Now=formatter.format(milli_to_date);
													    	double rate_this_month=rate(New, Old, Life_month, Purchasetime, Now);
													    	sum=sum+average*rate_this_month;
													    }
													}
													catch (java.text.ParseException e) {
											            e.printStackTrace();
											        }
													return sum;
												}
												%>
												<%
												double New=(double)pageContext.getAttribute("New");
												double Old=(double)pageContext.getAttribute("Old");
												int Cost=(int)pageContext.getAttribute("Cost");
												int Life_month=(int)pageContext.getAttribute("Life_month");
												int item_rent_time=(int)pageContext.getAttribute("item_rent_time");
												String Purchasetime=(String)pageContext.getAttribute("Purchasetime");
												String Start=(String)pageContext.getAttribute("Start");
												double money=Summation(New,Old,Cost,Life_month,item_rent_time,Purchasetime,Start);
												pageContext.setAttribute("ThisRent",money);
												%>
												<fmt:formatNumber var="ThisRentFinal" value="${ThisRent}" groupingUsed="false" minFractionDigits="0" maxFractionDigits="0"/>
												<br>
												<h4>商品價格 : <c:out value="${ThisRentFinal}"/>元</h4>
												<%
												long Price=(long)pageContext.getAttribute("Price");
												String STRThisRentFinal=(String)pageContext.getAttribute("ThisRentFinal");
												long ThisRentFinal=(long)Integer.parseInt(STRThisRentFinal);
												Price+=ThisRentFinal;
												pageContext.setAttribute("Price",Price);
												%>
												<input type="hidden" name="${StartID}" value="${Start}">
											</c:if>
										</c:forTokens>
									</c:if>
								</c:forEach>
								<br>
								<button type="button" class="btn btn-dark" onclick="javascript:Contract();">
									<script>
										function Contract(){
											window.location.assign("contract.jsp");
										}
									</script>
									簽署合約
								</button>
							</div><!-- 對應到InfoID -->
							<c:remove var="ID"/>
							<c:remove var="Value"/>
							<c:remove var="InfoID"/>
							<c:remove var="PicID"/>
							<c:remove var="ImgID"/>
							<c:remove var="StartID"/>
						</c:forTokens>
					</div><!-- 對應到row -->
				</div><!-- 對應到div_all -->
				<div class="container" id="div_all">
					<div class="row">
						<div class="col-6"></div>
						<div class="col-6">												
							<table class="table">
								<tr>
									<td><h3>總金額</h3></td>
									<td><h3><c:out value="${Price}"/> 元</h3></td>
								</tr>
								<tr>
									<td><h3>付款方式</h3></td>
									<td>
										<select class="form-select" name="pay">
											<option selected value="0" id="noselect">請選擇</option>
											<option value="mobile_payment">行動支付</option>
											<option value="credit_card">信用卡</option>
											<option value="store">超商繳費</option>
										</select>
									</td>
								</tr>
								<tr>
									<td>
										<button type="reset" class="btn btn-warning" onclick="javascript:Return();">
											<script>
												function Return(){
													window.location.assign("cart.jsp");
												}
											</script>
											重新選擇
										</button>
									</td>
									<td>
										<button type="submit" class="btn btn-success">付款</button>
									</td>
								</tr>
							</table>						
						</div>
					</div><!-- 對應到row -->
				</div><!-- 對應到div_all -->
				<input type="hidden" name="ID_Value_list" value="${ID_Value_list}">
				<input type="hidden" name="price" value="${Price}"><!-- 在表單裡面用來記錄價錢的項目 -->
			</form>
			<br>
			<script>
				$(document).ready(function(){
					$('#noselect').attr('disabled',true);/*停用相同class的功能，這裡用來停止選項的功能*/
				});
			</script>
		</c:otherwise>
	</c:choose>
	<!-- 引用Bootstrap -->
	<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0-alpha1/dist/js/bootstrap.bundle.min.js" integrity="sha384-w76AqPfDkMBDXo30jS1Sgez6pr3x5MlQ1ZAGC+nuZB+EYdgRZgiwxhTBTkF7CXvN" crossorigin="anonymous"></script>
	<script src="https://cdn.jsdelivr.net/npm/@popperjs/core@2.11.6/dist/umd/popper.min.js" integrity="sha384-oBqDVmMz9ATKxIep9tiCxS/Z9fNfEXiDAYTujMAeBAsjFuCZSmKbSSUnQlmh/jp3" crossorigin="anonymous"></script>
    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0-alpha1/dist/js/bootstrap.min.js" integrity="sha384-mQ93GR66B00ZXjt0YO5KlohRA5SY2XofN4zfuZxLkoj1gXtW8ANNCe9d5Y3eG5eD" crossorigin="anonymous"></script>
</body>
</html>