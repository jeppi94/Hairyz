<%@ page import="com.study.springboot.dto.QDto" %>
<%@ page import="java.net.URLEncoder" %>
<%@ page import="java.time.LocalDateTime" %>
<%@ page import="java.time.DayOfWeek" %>
<%@ page import="java.time.format.DateTimeFormatter" %>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>


<%
    // 현재 날짜와 시간 가져오기
    LocalDateTime now = LocalDateTime.now();
    // 오늘출발 가능 시간을 12:00로 설정
    LocalDateTime deadline = now.withHour(12).withMinute(0).withSecond(0).withNano(0);

    // 평일 체크: 월~금 (1~5)
    boolean isWeekday = (now.getDayOfWeek() != DayOfWeek.SATURDAY && now.getDayOfWeek() != DayOfWeek.SUNDAY);
    boolean isBeforeDeadline = now.isBefore(deadline);

    String message;
    if (isWeekday && isBeforeDeadline) {
        message = "오늘출발 주문가능합니다(평일 12:00시 까지)";
    } else {
        message = "오늘출발 마감되었습니다(평일 12:00시 까지)";
    }
%>


<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>상품 목록</title>
<script>
    document.addEventListener("DOMContentLoaded", function() {
    	$(document).ready(function() {
    	    let pricePerItem = ${product.pd_price} // 개별 상품 가격
    	    let quantity = parseInt($('#quantity-input').val()); // 초기 수량
    	
    	    function updateTotalPrice() {
    	        let totalPrice = pricePerItem * quantity;
    	        $('#total-price').text(totalPrice.toLocaleString() + '원');
    	    }
    	
    	    $('#increase').on('click', function() {
    	        quantity++;
    	        $('#quantity-input').val(quantity);
    	        updateTotalPrice();
    	    });
    	
    	    $('#decrease').on('click', function() {
    	        if (quantity > 1) {
    	            quantity--;
    	            $('#quantity-input').val(quantity);
    	            updateTotalPrice();
    	        }
    	    });
    	    
    	    $('#quantity-input').on('focus', function() {
    	    	$(this).val(''); // 입력란 클릭 시 모든 내용 선택
            });
    	
    	    $('#quantity-input').on('input', function() {
    	        // 사용자가 입력한 값을 받아오기
    	        let inputValue = $(this).val();
    	        // 입력된 값이 숫자인지 확인하고, 숫자가 아닌 경우 1로 설정
    	        if ($.isNumeric(inputValue) && parseInt(inputValue) > 0) {
    	            quantity = parseInt(inputValue); // 유효한 수량으로 업데이트
    	        } else {
    	            quantity = 1; // 기본값 1 설정
    	        }
    	        $(this).val(quantity); // 입력란의 값을 업데이트
    	        updateTotalPrice(); // 총 가격 업데이트
    	    });
    	
    	    // 초기 총 가격 업데이트
    	    updateTotalPrice();
    	});
    	
    	//구매버튼 클릭 이벤트
    	function goToPurchase() {
    	    let ProductNum = document.getElementById('productNum').value;
    	    let ProductName = document.getElementById('productName').innerText;
    	    let ProductImage = document.getElementById('productImg').src; // 이미지의 src 속성 값을 가져옵니다.
    	    let Productquantity = document.getElementById('quantity-input').value;
    	    let Productprice = document.getElementById('total-price').textContent.replace(/[^0-9]/g, ''); // 숫자만 가져오기
    	    
    		console.log(ProductNum)    
    	    console.log(ProductName)
    	    console.log(ProductImage)
    	    console.log(Productquantity)
    	    console.log(Productprice)
    	    
    	    let url = '/s_purchase?productNum=' + encodeURIComponent(ProductNum) +
                  '&productName=' + encodeURIComponent(ProductName) +
                  '&productImage=' + encodeURIComponent(ProductImage) +
                  '&productQuantity=' + encodeURIComponent(Productquantity) +
                  '&productPrice=' + encodeURIComponent(Productprice);
    	    
    	    console.log(url)
    	    
    	    window.location.href = url;
    	}

        // 장바구니에 담기 버튼 클릭 이벤트
        function goToCart() {
            alert('상품이 장바구니에 담겼습니다.'); // 실제 장바구니 로직으로 대체
        }
        
     	// 모달 열기
        var userId = "${sessionScope.userId != null ? sessionScope.userId : ''}";
        
        function getUserId() {
            return userId; 
        }
        
        function openModal() {
        	if (!getUserId()) { // 로그인 안된 상태
                alert("로그인이 필요한 서비스입니다.");
                window.location.href = "/login.do"; // 로그인 페이지로 이동
                return;
            } else{        	
	            $('#qnaModal').modal('show');
            }
        }


        function openModal() {
            

            // AJAX 요청으로 회원 정보 가져오기
            $.ajax({
            	url: `/getMemberInfo/${userId}`, // 회원 정보 가져올 URL (서버에 설정된 경로에 따라 수정)
                type: 'GET',
                success: function(memberInfo) {
                    console.log(memberInfo);
                    $('#qnaModal').modal('show');
                },
                error: function(error) {
                    // 오류 처리
                    alert('회원 정보를 가져오는 데 실패했습니다.');
                }
            });
        }

        // Q&A 제출
        function submitQnA() {
            const content = document.getElementById('qnaContent').value;
            const visibility = document.querySelector('input[name="visibility"]:checked').value;

            // 유효성 검사 (여기서 추가적인 검사를 할 수 있습니다)
            if (!content) {
                alert('문의 내용을 입력하세요.');
                return;
            }

            // 서버에 데이터를 전송 (예시: AJAX 사용)
            $.ajax({
                url: '/submitQnA', // Q&A를 제출할 URL
                type: 'POST',
                data: {
                    content: content,
                    visibility: visibility
                },
                success: function(response) {
                    // 성공적으로 등록된 후 처리 (예: 알림, 리스트 갱신 등)
                    alert('문의가 등록되었습니다.');
                    $('#qnaModal').modal('hide');
                    document.getElementById('qnaForm').reset(); // 폼 초기화
                    // 추가로 Q&A 리스트 갱신 코드를 작성할 수 있습니다
                },
                error: function(error) {
                    // 오류 처리
                    alert('문의 등록에 실패했습니다. 다시 시도해 주세요.');
                }
            });
        }
        
    	document.querySelectorAll('.tab-button').forEach(button => {
    	    button.addEventListener('click', function() {
    	        // 모든 버튼에서 'active' 클래스 제거
    	        document.querySelectorAll('.tab-button').forEach(btn => {
    	            btn.classList.remove('active');
    	        });
    	        
    	        // 클릭한 버튼에 'active' 클래스 추가
    	        this.classList.add('active');
    	        
    	     	// 해당 섹션으로 스크롤
                const targetId = this.id.replace('-tab', '-content'); // ID 변환
                const targetElement = document.getElementById(targetId);
                if (targetElement) {
                    targetElement.scrollIntoView({ behavior: 'smooth' }); // 부드럽게 스크롤
                }
    	    });
    	});
    });
</script>
<!-- Bootstrap CSS -->
<link href="https://stackpath.bootstrapcdn.com/bootstrap/4.5.2/css/bootstrap.min.css" rel="stylesheet">
<script src="https://ajax.googleapis.com/ajax/libs/jquery/3.5.1/jquery.min.js"></script>
<link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/5.15.3/css/all.min.css">
<link rel="icon" href="${pageContext.request.contextPath}/favicon.ico" type="image/x-icon">
</head>
<body>
<style>
	
	/*상품 상세*/
	
	.product-container {
	    display: flex; /* 수평정렬 */
	    align-items: flex-start; /*상단정렬*/
	    margin-bottom: 10px;
	}
	.product-box {
            border: 1px solid #ddd;
            border-radius: 5px;
            margin-top: 80px;
            margin-left: 48px;
            margin-right: 50px;
            text-align: center;
            width: 550px;
            height: 600px;
    }
        .product-img {
            max-width: 100%;
            height: auto;
    }
    .product-text {
        margin-top:100px;
        flex-direction: column; /* 텍스트를 세로로 정렬 */
        justify-content: center;   
            
    }
    .product-name {
    	line-height: 2;
        font-size: 1.5em;
        overflow-wrap: break-word; /*텍스트 길이 줄바꿈*/
        font-weight: bold;
    }

    .product-price {
        font-size: 1.3em; 
        color: #ff9800;
    }
    
    hr.product-hr {
        border: 0.5px solid #ffc107 !important; 
        width: 100% !important;
        margin-top: 30px !important;
    }

    .highlight-box {
        background-color: #fff9c4; 
        padding: 10px; 
        border-radius: 2px; 
	    flex-direction: column; 
    }
    
    .quantity-container {
    margin-top: 20px; 
	}
	
	.quantity-button {
	    width: 30px;
	    height: 30px;
	    font-size: 1.2em;
	    cursor: pointer;
	}
	.star {
        font-size: 24px; /* 별의 크기 */
        color: gold; /* 채워진 별 색상 */
    }
    .star-empty {
        color: lightgray; /* 비어 있는 별 색상 */
    }	

        
</style>

	<div class="content">
		<%@ include file="header.jsp" %>
	</div>
	    
		<div class=container>
		    <div class="product-container">	
	              <div class="product-box">
	           		<img src="${pageContext.request.contextPath}/upload/${product.pd_chng_fname}" id="productImg" alt="${product.pdName}" 
	           			 style="width:100%; height:100%; margin-right:10px; object-fit:cover;">
	             
	              </div>
	              <div class="product-text">
	              	  <input type="hidden" id="productNum" name="productNum" value="${product.pdNum}" />
		              <span class="product-name" id='productName'>${product.pdName}</span><br>
		              <span class="product-price">
		              	<fmt:formatNumber value="${product.pd_price}" pattern="#,##0원" />
		              </span>
		              <hr class="product-hr">
		              
		              <p>배송방법&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;택배</p>
		              <p>배송비&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;무료</p>
		              <div class="highlight-box">
						    <div style="display: flex; align-items: center;">
						        <i class="fas fa-truck" style="margin: 10px 10px;"></i> <!-- 배달 아이콘 -->
						        <p style="margin: 0;">오늘출발 상품</p>
						    </div>
						    <p style="margin-left: 40px;"><%= message %></p>
					  </div>
					  
		              <hr class="product-hr">
			              <div style="display: flex; align-items: center;">
						     <span style="margin-right: 250px;">수량</span>
	                         <div class="btn-group" role="group" aria-label="Default button group">
	                             <button type="button" id="decrease" class="btn btn-outline-secondary">-</button>
	                             <input type="text" id="quantity-input" style="width: 40px; text-align: center;" value="1" />
	                             <button type="button" id="increase" class="btn btn-outline-secondary">+</button>
	                         </div>
						 </div>
					     
					     
					  <hr class="product-hr">
					  	<div style="display: flex; align-items: center;">
	                        <span style="margin-right: 240px;">총 상품 금액</span>
	                        <span id="total-price">${product.pd_price}원</span>
                    	</div>
	              	   <hr class="product-hr">
	              	   		<div>
    							<button onclick="goToPurchase()" id="buy-now" class="btn btn-warning" style="width: 200px; margin-left: 10px;">구매하기</button>
		              	   		<button onclick="goToCart()" id="add-to-cart" class="btn btn-outline-warning" style="width: 200px; color: black;">장바구니</button>
		              	   	</div>
	              </div>
              </div> 
		</div>

<style>
    .info-tabs {
        display: flex;
        justify-content: space-around;
        max-width: 1000px; /* 최대 너비 설정 */
    	margin: 20px auto;
    }
    
    .info-content {
	    max-width: 1000px; /* 최대 너비 설정 */
	    margin: 0 auto; /* 가운데 정렬 */
	}
    .tab-button {
        flex: 1;
        padding: 10px;
        background-color: #ffffff;
        border: 1px solid #ddd;
        cursor: pointer;
        text-align: center;
        outline: none;
        
        
    }
    
    .tab-button:focus {
    outline: none; /* 포커스 시 아웃라인 제거 */
	}
    
    .active {
     background-color: #fff9c4;
     border-color: #ffc107;
     outline: none;
     
    }
    
    .custom-width {
        width: 150px;
        color: #000000; 
    }
    
    .table {
      border-color: #ffc107; /* 테이블 테두리 색상 */
  }

  .table th{
  	  background-color: #fff9c4;
  }
  
  .table td {
      border-color: #ffc107; /* 테이블 헤더와 셀 테두리 색상 */
  }
  
	.table thead th {
	    border-bottom: 1px solid #ffcc00;
	}
	
	.table-white {
		background-color: #ffffff;
	}
	
	.table-bottom-border {
	    border-bottom: 1px solid #ffc107; /* 원하는 색상과 두께로 테두리 설정 */
	}
	
	.my-custom-table td, .my-custom-table th {
	    line-height: 2; /* 이 테이블에만 적용 */
	}
 
</style>
		
       	<div class=container>
       		<div class="info-tabs">
			    <button class="tab-button active" id="details-tab">상세정보</button>
			    <button class="tab-button" id="reviews-tab">구매평</button>
			    <button class="tab-button" id="qna-tab">Q&A</button>
			</div>
			
			<div class="info-content">
			    <div id="details-content">
			        <img src="${pageContext.request.contextPath}/upload/${product.pd_chng_fname2}" alt="${product.pdName}" style="width:100%; height:100%; margin-right:10px;" object-fit:cover;>
			        <!-- 데이터베이스에서 불러온 내용 표시 -->
			    </div>
			<hr class="product-hr">
			<div id="reviews-content">
			    <h3><strong>구매평</strong></h3>
			    <p>상품을 구매하신 분들이 작성한 리뷰입니다.</p>
			</div>
			<table class="mb-2 my-custom-table" style="width: 100%;">
			    <tbody>
			        <c:forEach var="item" items="${reviews}">
			            <tr class="table-white text-left">
			                <td colspan="4">
			                	<span style="font-weight: bold;">
				                    <c:forEach var="i" begin="1" end="5">
				                        <span class="star ${i <= item.pr_rating ? '' : 'star-empty'}">&#9733;</span> <!-- ★ -->
				                    </c:forEach>
			                		${item.pr_rating}
				                </span>
			                </td>
			             </tr>
			             <tr>
			                <td colspan="4">
			                    <span style="font-weight:bold; margin-right:15px;">${item.pr_MbNnme}</span>
			                    <span>${item.pr_reviewDate}</span>
			                </td>
			             </tr>
			             <td colspan="3" class="table-bottom-border">${item.pr_reviewText}</td>
			             <c:if test="${not empty item.pr_modName}">
				                <td colspan="1"></td>
				                <td class="table-bottom-border" style="width:300px;">
				                    <img src="${pageContext.request.contextPath}/upload/${item.pr_modName}" alt="상품 이미지" style="width:100px; height:auto;"> <!-- item.productImage로 이미지 URL을 가져옵니다. --> 	
				                </td>
			             </c:if>
			             <c:if test="${!not empty item.pr_modName}">
				                <td colspan="1"></td>
				                <td class="table-bottom-border"></td>
			             </c:if>
			        </c:forEach>
			    </tbody>
			</table>
						 
			    
			<hr class="product-hr">
			    <div id="qna-content" class="">
			        <h3><strong>Q&A</strong></h3>
			        <p>구매하시려는 상품에 대해 궁금한 점이 있으면 문의 주세요.</p>
										<div class="container d-flex justify-content-end">
				        <input type="button" class="btn btn-warning custom-width mb-3" value="Q&A 작성"  onclick="openModal()"/>
			       	</div>
			       	<!-- 모달 -->
					<div class="modal fade" id="qnaModal" tabindex="-1" role="dialog" aria-labelledby="qnaModalLabel" aria-hidden="true">
					    <div class="modal-dialog" role="document">
					        <div class="modal-content">
					            <div class="modal-header">
					                <h5 class="modal-title text-center" id="qnaModalLabel">Q&A 작성하기</h5>
					                <button type="button" class="close" data-dismiss="modal" aria-label="Close">
					                    <span aria-hidden="true">&times;</span>
					                </button>
					            </div>
					            <div class="modal-body">
					                <form id="qnaForm">
					                    <div class="form-group">
					                        <textarea class="form-control" id="qnaContent" rows="7" required placeholder="문의하실 내용을 입력하세요."></textarea>
					                    </div>
					                    <div class="form-group">
					                        <div class="form-check form-check-inline">
					                            <input class="form-check-input" type="radio" name="visibility" id="public" value="공개" checked>
					                            <label class="form-check-label" for="public">
					                                공개
					                            </label>
					                        </div>
					                        <div class="form-check form-check-inline">
					                            <input class="form-check-input" type="radio" name="visibility" id="private" value="비공개">
					                            <label class="form-check-label" for="private">
					                                비공개
					                            </label>
					                        </div>
					                    </div>
					                </form>
					            </div>
					            <div class="modal-footer">
					                <button type="button" class="btn btn-secondary" data-dismiss="modal">취소</button>
					                <button type="button" class="btn btn-warning" onclick="submitQnA()">등록</button>
					            </div>
					        </div>
					    </div>
					</div>
			       	<table class="table table-bordered mb-2">
					  <thead>
					    <tr class="table-warning text-center">
					      <th scope="col">답변상태</th>
					      <th scope="col">제목</th>
					      <th scope="col">작성자</th>
					      <th scope="col">작성일</th>
					    </tr>
					  </thead>
				      <tbody>
				      	<c:if test="${not empty qnaList}">
					        <c:forEach var="qDTO" items="${qnaList}">
					            <tr>
					                <td class="text-center align-middle">
						                <c:choose>
									        <c:when test="${qDTO.qna_rstate == 'N'}">
									            미답변
									        </c:when>
									        <c:when test="${qDTO.qna_rstate == 'Y'}">
									            답변 완료
									        </c:when>
									    </c:choose>
									</td>        
					                <td onclick="handleClick('${qDTO.qna_qstate}', '${qDTO.qna_content}', '${qDTO.qna_no}')" style="cursor: pointer;">
			                            <div class="product-container">    
			                                <c:choose>
			                                    <c:when test="${qDTO.qna_qstate == '비공개'}">
			                                        비밀글입니다
			                                    </c:when>
			                                    <c:when test="${qDTO.qna_qstate == '공개'}">
			                                        ${qDTO.qna_content}
			                                    </c:when>
			                                </c:choose>&nbsp;&nbsp;
			                                <div style="margin-top: 1px;">
			                                    <c:if test="${qDTO.qna_qstate == '비공개'}">
			                                        <i class="fas fa-lock"></i>&nbsp;&nbsp;
			                                    </c:if>
			                                    <c:if test="${qDTO.qna_qstate == '공개'}">
			                                    </c:if>
			                                    <c:if test="${qDTO.isNew()}">
			                                        <span class="badge badge-secondary">New</span>
			                                    </c:if>
			                                </div>
			                            </div>     
			                        </td>
			                        <td class="text-center align-middle">${qDTO.qna_name}</td>
			                        <td class="text-center align-middle">
			                            <fmt:formatDate value="${qDTO.qna_date}" pattern="yyyy-MM-dd" />        
			                        </td>
			                    </tr>
			                    <!-- 각 문의의 상세 내용 행의 id 속성을 고유하게 설정 -->
			                    <c:choose>
								    <c:when test="${qDTO.qna_qstate == '공개' && qDTO.qna_rstate == 'Y'}">
								        <tr id="content-${qDTO.qna_no}" class="toggle-content" style="display: none; background-color: #fff9c4;">
								            <td colspan="1" class="text-center align-middle" style="border-bottom: none !important;"></td>
								            <td colspan="3">${qDTO.qna_content}</td>    
								        </tr>
								        <c:if test="${currentQnaRep != null && currentQnaRep.qnaNo == qDTO.qna_no}">
									        <tr id="details-${qDTO.qna_no}" class="details-content" style="display: none; background-color: #fff9c4;">
									            <td colspan="1" class="text-center align-middle"></td>
									            <td colspan="1" style="font-size: 14px;">
									            	<i class="fas fa-angle-right" style="margin-right: 5px;"></i>
									            		${currentQnaRep.qrContent}
									           	</td>
									            <td colspan="1">
									            	<c:choose>
												        <c:when test="${currentQnaRep.qrId == 'admin'}">
												            관리자
												        </c:when>
												        <c:otherwise>
												            ${currentQnaRep.qrId}  <!-- 다른 경우, 원래의 ID를 출력 -->
												        </c:otherwise>
												    </c:choose>
									            </td>									            
								            	<td class="text-center align-middle">
						                            <fmt:formatDate value="${currentQnaRep.qrDate}" pattern="yyyy-MM-dd" />        
						                        </td>
								            									                
									        </tr>
								        </c:if>		
								    </c:when>
								    <c:when test="${qDTO.qna_qstate == '공개'}">
								        <tr id="content-${qDTO.qna_no}" class="toggle-content" style="display: none; background-color: #fff9c4;">
								            <td colspan="1" class="text-center align-middle"></td>
								            <td colspan="3">${qDTO.qna_content}</td>    
								        </tr>
								    </c:when>
								</c:choose>
			                </c:forEach>
			            </c:if>

						<c:if test="${empty qnaList}">
						    <tr>
						        <td colspan="4" class="text-center align-middle">등록된 문의 내용이 없습니다.</td>
						    </tr>
						</c:if>
						
				      </tbody>
					</table> 		       
			    </div>
			</div>
       	</div>

       	<!-- 페이지네이션 -->
		<div class="director">
	    <!-- 첫 페이지 -->
	    <c:choose>
	        <c:when test="${currentPage == 1}">
	            <button type="button" class="btn page-button" style="color:gray;" disabled>&lt;&lt;</button>
	        </c:when>
	        <c:otherwise>
	            <button type="button" class="btn page-button" style="color:gray;" 
	            		onclick="location.href='p_details?page=1&pdNum=${pdNum}&qna_no=${qna_no}'">&lt;&lt;</button>
	        </c:otherwise>
	    </c:choose>
	
	    <!-- 이전 페이지 -->
	    <c:choose>
	        <c:when test="${currentPage == 1}">
	            <button type="button" class="btn page-button" style="color:gray;" disabled>&lt;</button>
	        </c:when>
	        <c:otherwise>
	            <button type="button" class="btn page-button" style="color:gray;" 
	            		onclick="location.href='p_details?page=${currentPage - 1}&pdNum=${pdNum}&qna_no=${qna_no}'">&lt;</button>
	        </c:otherwise>
	    </c:choose>
	
	    <!-- 개별 페이지 -->
	    <c:forEach var="i" begin="${startPage}" end="${endPage}" step="1">
	        <c:choose>
	            <c:when test="${currentPage == i}">
	                <button type="button" class="btn page-button" style="color:gray;" disabled>${i}</button>
	            </c:when>
	            <c:otherwise>
	                <button type="button" class="btn page-button" style="color:gray;" 
	                		onclick="location.href='p_details?page=${i}&pdNum=${pdNum}&qna_no=${qna_no}'">${i}</button>
	            </c:otherwise>
	        </c:choose>
	    </c:forEach>
	
	    <!-- 다음 페이지 -->
	    <c:choose>
	        <c:when test="${currentPage == totalPages}">
	            <button type="button" class="btn page-button" style="color:gray;" disabled>&gt;</button>
	        </c:when>
	        <c:otherwise>
	            <button type="button" class="btn page-button" style="color:gray;" 
	                    onclick="location.href='p_details?page=${currentPage + 1}&pdNum=${pdNum}&qna_no=${qna_no}'">&gt;</button>
	        </c:otherwise>
	    </c:choose>
	
	    <!-- 끝 페이지 -->
	    <c:choose>
	        <c:when test="${currentPage == totalPages}">
	            <button type="button" class="btn page-button" style="color:gray;" disabled>&gt;&gt;</button>
	        </c:when>
	        <c:otherwise>
	            <button type="button" class="btn page-button" style="color:gray;" 
	            		onclick="location.href='p_details?page=${totalPages}&pdNum=${pdNum}&qna_no=${qna_no}'">&gt;&gt;</button>
	        </c:otherwise>
	    </c:choose>
		</div>
		<!-- 페이지네이션 -->
		
<style>
/* 페이지네이션 */
	.director {
	    display: flex; /* Flexbox 레이아웃 사용 */
	    justify-content: center; /* 수평 가운데 정렬 */
	    align-items: center; /* 수직 가운데 정렬 */
	    height: 10vh; /* 뷰포트 전체 높이를 기준으로 가운데 정렬 */
	}

.page-button {
		background-color: #ffe082;
		border: 1px solid #ffc107;
		color: gray;
		justify-content: center;
		cursor: pointer;
	}
	
.page-button:hover {
        background-color: #ffc107; /* 호버 시 색상 변화 */
    }
</style>

	<%@ include file="footer.jsp" %>

<!-- Optional JavaScript -->
<!-- jQuery first, then Popper.js, then Bootstrap JS -->
<script src="https://cdn.jsdelivr.net/npm/popper.js@1.14.3/dist/umd/popper.min.js" integrity="sha384-ZMP7rVo3mIykV+2+9J3UJ46jBk0WLaUAdn689aCwoqbBJiSnjAK/l8WvCWPIPm49" crossorigin="anonymous"></script>
<script src="https://cdn.jsdelivr.net/npm/bootstrap@4.1.3/dist/js/bootstrap.min.js" integrity="sha384-ChfqqxuZUCnJSK3+MXmPNIyE6ZbWh2IMqE241rYiqJxyMiZ6OW/JmZQ5stwEULTy" crossorigin="anonymous"></script>
<script>
	function handleClick(qnaQState, qnaContent, qnaNo) {
	    if (qnaQState === '비공개') {
	        alert("비밀글입니다");
	    } else {
	        toggleContent(qnaNo); // 공개글의 경우 toggleContent 호출
	    }
	}
	
	function toggleContent(qnaNo) {
	    var contentDiv = document.getElementById("content-" + qnaNo);
	    var detailsRow = document.getElementById("details-" + qnaNo);
	    
	    console.log(contentDiv)
	    console.log(detailsRow)
	    
	    if (contentDiv.style.display === "none" || contentDiv.style.display === "") {
	        contentDiv.style.display = "table-row"; // 내용을 보이게 함
	        detailsRow.style.display = "table-row"; // 문의 답변을 보이게 함
	    } else {
	        contentDiv.style.display = "none"; // 내용을 숨김
	        detailsRow.style.display = "none";
	    }
	}
</script>
</body>
</html>
