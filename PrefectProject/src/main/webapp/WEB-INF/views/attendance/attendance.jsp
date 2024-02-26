<%@page import="com.pcwk.ehr.cmn.StringUtil"%>
<%@page import="com.pcwk.ehr.board.domain.BoardVO"%>
<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>  
<%@ taglib prefix="c"   uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<%@ taglib prefix="fn"  uri="http://java.sun.com/jsp/jstl/functions"%>
<c:set var="CP" value="${pageContext.request.contextPath}" scope="page" />     
<!DOCTYPE html>
<html> 
<head>
<link href="${CP}/resources/css/layout.css" rel="stylesheet" type="text/css">
<jsp:include page="/WEB-INF/cmn/header.jsp"></jsp:include>
<script>

document.addEventListener("DOMContentLoaded",function(){
	console.log("DOMContentLoaded");

	
});//--DOMContentLoaded

	function doSave() {
	    // 모든 훈련생의 출석 상태를 저장하기 위해 테이블 내의 모든 select 요소를 찾습니다.
	    
	    var count = 0; // 무결성 제약 조건이 발생한 횟수를 저장하는 변수
	    
	    //hidden input session 요소의 값을 가져옵니다.
		var sessionEmail = document.getElementById('sessionEmail').value;
		console.log("Session Email:", sessionEmail);
		
		// 입력된 날짜를 Date 객체로 변환합니다.
		var selectedDate = new Date(document.getElementById('calID').value);
		// 날짜를 숫자로 변환합니다.
		var calID = selectedDate.getFullYear() * 10000 +
		            (selectedDate.getMonth() + 1) * 100 +
		            selectedDate.getDate();
		
		console.log(calID);


		var saveButton = document.getElementById('doSave');
	    var selectElements = document.querySelectorAll('#attendanceTable select#attendStatus');
	    var traineeEmails = document.querySelectorAll('#attendanceTable input[id="traineeEmail"]');
        
        //confirm
		if (confirm("저장 하시겠습니까?") == false)
			return;
	    
	    // 각 select 요소의 값을 가져와서 서버로 전송할 데이터로 만듭니다.
	    var attendData = [];
	    selectElements.forEach(function(selectElement, index) {
	        var traineeEmail = traineeEmails[index].value;
	        var attendStatus = selectElement.value;
	        var data = {
	            trainee: traineeEmail,
	            professor: sessionEmail, // 교수님의 이름은 세션에서 가져옵니다.
	            attendStatus: attendStatus,
	            calID: calID
	        };
	        attendData.push(data);
	        
	        $.ajax({
		        type: "POST",
		        url: "/ehr/attendance/doSave.do",
		        dataType: "json",
		        data: {
		        	trainee: traineeEmail,
		            professor: sessionEmail, // 교수님의 이름은 세션에서 가져옵니다.
		            attendStatus: attendStatus,
		            calID: calID
		        },
		        success: function(data) { // 통신 성공
		            console.log("success data:", data);
		            if ("1" === data.msgId) {
		                console.log(data.msgContents);
		                // 성공 시 필요한 작업 수행
		            } else if ("2" === data.msgId) {
		            	console.log(data.msgContents); // 실패 시 메시지 출력
		                count++;
		                // 실패 시 필요한 작업 수행
		            } else {
		                console.log(data.msgContents);
		               
		                // 실패 시 필요한 작업 수행
		            }
		        },
		        error: function(xhr, status, error) { // 실패시 처리
		            console.error("error:", error);
		        },
		        complete: function(xhr, status) { // 성공/실패와 관계없이 수행!
		            console.log("complete:", status);
		            // Spinner를 숨깁니다.
		            document.getElementById('spinner').classList.remove('show');
		            
		         	// 모든 AJAX 요청이 완료되었을 때 count와 loop의 길이를 비교하여 alert 표시
		            if (count === selectElements.length) {
		                alert("이미 저장한 내용입니다.");
		            }
		        }
		    });
	    });
	   	
	    console.log(attendData);
	}
	
	/* function doUpdate(button) {
		// 각 행의 수정 버튼을 클릭할 때 해당 행의 정보를 가져옵니다.
	    var row = $(this).closest('tr'); // 클릭된 버튼이 속한 행을 가져옵니다.
	    var traineeEmail = row.find('#traineeEmail').val(); // 이메일 가져오기
	    var attendStatus = row.find('#attendStatus').val(); // 출석 상태 가져오기
	    
	   // 입력된 날짜를 Date 객체로 변환합니다.
		var selectedDate = new Date(document.getElementById('calID').value);
		// 날짜를 숫자로 변환합니다.
		var calID = selectedDate.getFullYear() * 10000 +
		            (selectedDate.getMonth() + 1) * 100 +
		            selectedDate.getDate();
		
		console.log(calID);

	    // 수정할 정보를 확인합니다.
	    console.log("Trainee Email:", traineeEmail);
	    console.log("Attendance Status:", attendStatus);
	    console.log("row:", row);

	    // 여기에 수정 로직을 추가하세요.
	    // AJAX 요청을 통해 서버에 수정 요청을 보낼 수 있습니다.
	    
	   //confirm
		if (confirm("수정 하시겠습니까?") == false)
			return;

		$.ajax({
			type : "POST",
			url : "/ehr/attendance/doUpdate.do",
			asyn : "true",
			dataType : "html",
			data : {
				trainee : traineeEmail,
				calID : calID,
				attendStatus: attendStatus
			},
			success : function(data) {//통신 성공     
				console.log("success data:" + data);

			},
			error : function(data) {//실패시 처리
				console.log("error:" + data);
			},
			complete : function(data) {//성공/실패와 관계없이 수행!
				console.log("complete:" + data);
			}
		});
	} */
	
	function doUpdate(button) {
		// 클릭한 버튼의 부모 요소를 통해 해당 행(tr)을 찾습니다.
	    var row = button.parentNode.parentNode;
	    
	    // 해당 행에서 이름과 출석 여부를 찾아 값을 가져옵니다.
	    var traineeEmail = row.querySelector("#traineeEmail").value;
	    var attendStatus = row.querySelector("#attendStatus").value;
	    
	    // 가져온 값 확인
	    console.log("traineeEmail:", traineeEmail);
	    console.log("출석 여부:", attendStatus);
	    
	    // 입력된 날짜를 Date 객체로 변환합니다.
	    var selectedDate = new Date(document.getElementById('calID').value);
	    // 날짜를 숫자로 변환합니다.
	    var calID = selectedDate.getFullYear() * 10000 +
	                (selectedDate.getMonth() + 1) * 100 +
	                selectedDate.getDate();
	    
	    console.log(calID);

	    // 여기에 수정 로직을 추가하세요.
	    // AJAX 요청을 통해 서버에 수정 요청을 보낼 수 있습니다.
	    
	   //confirm
	    if (confirm("수정 하시겠습니까?") == false)
	        return;

	    $.ajax({
	        type : "POST",
	        url : "/ehr/attendance/doUpdate.do",
	        asyn : "true",
	        dataType : "html",
	        data : {
	            trainee : traineeEmail,
	            calID : calID,
	            attendStatus: attendStatus
	        },
	        success : function(data) {//통신 성공     
	            console.log("success data:" + data);

	        },
	        error : function(data) {//실패시 처리
	            console.log("error:" + data);
	        },
	        complete : function(data) {//성공/실패와 관계없이 수행!
	            console.log("complete:" + data);
	        }
	    });
	}
	
	function reloadPage(input) {
		// 변경된 날짜 값을 가져옵니다.
        var selectedDate = input.value;
		
       // 입력된 날짜를 '-'로 분리하여 배열로 만듭니다.
        var parts = selectedDate.split("-");
        // 분리된 배열의 각 요소를 합쳐서 'yyyyMMdd' 형식의 문자열로 만듭니다.
        var yyyyMMdd = parts[0] + parts[1] + parts[2];
        // 문자열을 정수로 변환하여 반환합니다.

        // URL에 변경된 날짜를 쿼리 매개변수로 추가하여 새로고침합니다.
        var url = window.location.href.split('?')[0] + '?calID=' + yyyyMMdd;
        window.location.href = url;
    }
	
	// 페이지가 로드될 때 URL에서 날짜를 가져와 input 요소에 설정합니다.
    window.onload = function() {
        var urlParams = new URLSearchParams(window.location.search);
        var selectedDate = urlParams.get('calID');
        var formattedDate = selectedDate.substring(0, 4) + "-" + selectedDate.substring(4, 6) + "-" + selectedDate.substring(6);
        console.log(formattedDate);
        if (selectedDate) {
            document.getElementById('calID').value = formattedDate;
        }
    };
</script>

<style>
    /* 테이블과 관련된 스타일 */
    .table th, .table td {
        padding: 0.5rem; /* 셀 내부의 padding을 조절합니다 */
    }

    /* 선택적으로 테이블의 너비를 조절합니다 */
    .table-responsive {
        margin: 0 auto; /* 상하 마진은 0, 좌우 마진은 자동으로 설정 */
    }

    /* 선택적으로 테이블 행의 높이를 조절합니다 */
    .table tr {
        height: auto; /* 필요에 따라 조절 */
    }
</style>
</head>
<body> 

	<input type="hidden" id="sessionEmail" value="${sessionScope.user.email}"/>
	
    <!-- Spinner Start -->
    <div id="spinner"
        class="show w-100 vh-100 bg-white position-fixed translate-middle top-50 start-50  d-flex align-items-center justify-content-center">
        <div class="spinner-grow text-primary" role="status"></div>
    </div>
    <!-- Spinner End -->
    
    <br><br><br><br><br>
    <div class="text-center">
	    <label for="calID">날짜 선택:</label>
	    <input type="date" id="calID" name="calID" value="<%=java.time.LocalDate.now()%>" onchange="reloadPage(this)">
	</div>

	 <div class="container-fluid testimonial py-2">
	    <!-- table -->
	    <table id="attendanceTable"  class="table table-responsive">    
	        <thead>
	        <tr>
	        	<th scope="col" class="text-center col-lg-2  col-sm-2">순번</th>
	            <th scope="col" class="text-center col-lg-2  col-sm-2">이름</th>
	            <th scope="col" class="text-center col-lg-2  col-sm-2" >출석여부</th>
	            <th scope="col" class="text-center col-lg-2  col-sm-2" ></th>
	        </tr>
	        </thead>
	        <tbody>
	        <c:choose>
	            <%-- 조회데이터가 있는 경우:jsp comment(html에 노출 안됨) --%>
	            <c:when test="${not empty trainees }">
			        <c:forEach var="vo" items="${trainees}" varStatus="loop">
				        <tr>
				        	<td class="text-center">${loop.index + 1}</td>
				            <td class="text-center" id="traineeName">
					            ${vo.name}
					            <input type="hidden" id="traineeEmail" value="${vo.email }">
				            </td>
				            <td class="text-center">
			                    <div class="col-auto">
			                        <select id="attendStatus" name="attendStatus">
			                            <!-- 검색 조건 옵션을 동적으로 생성 -->
			                            <c:forEach items="${attendStatusList}" var="status">
			                                <c:set var="found" value="false"/> <%-- 일치하는 데이터를 찾았는지 여부를 저장하는 변수 --%>
			                                <c:forEach var="attendance" items="${attendances}">
			                                    <c:if test="${attendance.trainee eq vo.email}">
			                                        <option value="${status.detCode}" <c:if test="${attendance.attendStatus eq status.detCode}">selected</c:if>>${status.detName}</option>
			                                        <c:set var="found" value="true"/>
			                                    </c:if>
			                                </c:forEach>
			                                <c:if test="${found eq false}">
			                                    <option value="${status.detCode}">${status.detName}</option>
			                                </c:if>
			                            </c:forEach>
			                        </select>
			                    </div>
			                </td>
			                <td class="text-center">
			                	<input type="button" value="수정" class="button"  id="doUpdate" onclick="doUpdate(this);">
			                </td>
				        </tr>
			        </c:forEach>
		        </c:when>
		        <%-- 조회데이터가 없는 경우:jsp comment(html에 노출 않됨) --%>
		        <c:otherwise>
		           <tr>
		               <td colspan="99" class="text-center">No data found.</td>
		           </tr>
		        </c:otherwise>
	        </c:choose>
	        </tbody>
	    </table>
	    <!--// table -------------------------------------------------------------->
	    <br><br>
	    <!-- button --------------------------------------------------------------->
	    <c:choose>
		    <c:when test="${empty attendances }">
		        <div class="row g-1 justify-content-end">
		            <div class="col-auto"> <!-- 열의 너비를 내용에 따라 자동으로 설정 -->
		                <input type="button" value="전체 저장" class="button"  id="doSave" onclick="window.doSave();">
		            </div>  
		        </div>
		    </c:when>
		</c:choose>
    </div>
<jsp:include page="/WEB-INF/cmn/footer.jsp"></jsp:include>

</body>
</html>