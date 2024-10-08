<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>상품 등록</title>
<!-- Bootstrap CSS -->
<link href="https://stackpath.bootstrapcdn.com/bootstrap/4.5.2/css/bootstrap.min.css" rel="stylesheet">
<script src="https://ajax.googleapis.com/ajax/libs/jquery/3.5.1/jquery.min.js"></script>
<style>
        /* 기본 레이아웃 설정 */
        body {
            display: flex;
            flex-direction: column;
            min-height: 100vh;
            margin: 0;
        }

        /* 내용물이 차지할 공간을 유지 */
        .content {
            flex: 1;
        }

        /* footer를 페이지 하단에 고정 */
        footer {
            background-color: #ffffff;
            padding: 20px;
            text-align: center;
            width: 100%;
        }

        /* hr 두께 설정 */
        hr {
            border: 1px solid #d8d8d8;
            width: 100%;
            margin-top: 100px
        }

        .custom-container {
            max-width: 1000px;
            margin: 0 auto;
        }

        .logo-container {
            text-align: center;
        }

        .logo-container img {
            max-width: 100px;
            margin-left: 250px; 
        }

    </style>
</head>
<body>
	<!-- 로그 및 로그인 -->
    <div class="content">
        <div class="custom-container">
            <div class="row align-items-center py-3">
                <div class="col-9 logo-container">
                    <a href="main_view.do">
                        <img src="images/logo.png" alt="로고">
                    </a>
                </div>
				
				<div class="col-3 text-right">
					<%
					//아이디 취득 후 id가 Null인지 확인
					String id = (String)session.getAttribute("id");
					if (id == null)
					{
					%>
                    	<a href="#" class="btn btn-outline-warning">로그인</a>
                    <%}else{%>
                    	<a href="#" class="btn btn-outline-warning">마이페이지</a>
                    	<a href="#" class="btn btn-outline-warning">장바구니</a>
                    <%} %>
                </div>
            </div>
        </div>

        <!-- Navigation Bar -->
        <nav class="navbar navbar-expand-lg navbar-light">
            <div class="custom-container">
                <ul class="navbar-nav mr-auto">
                    <li class="nav-item">
                        <a class="nav-link" href="#">커뮤니티</a>
                    </li>
                    <li class="nav-item">
                        <a class="nav-link" href="#">쇼핑</a>
                    </li>
                    <li class="nav-item">
                        <a class="nav-link" href="#">동물병원</a>
                    </li>
                    <li class="nav-item">
                        <a class="nav-link" href="#">멍카페</a>
                    </li>
                    <li class="nav-item">
                        <a class="nav-link" href="#">캠페인</a>
                    </li>
                </ul>
            </div>
        </nav>
        
<style>
    
    /* 등록& 취소 버튼 넓이 */
    .custom-width {
        width: 200px; /* 원하는 너비로 설정 */
    }
    
    /* text 버튼 넓이 */
    .custom-input-width {
        width: 300px; /* 원하는 너비로 설정 */
        margin: 0 auto; /* 가운데 정렬 */
    }
    
    .image-preview {
    margin-bottom: 5px; /* 원하는 간격 설정 */
	}
	
	.custom-hr {
		    border: 1px solid #d8d8d8; 
		    width: 100%;
		    margin-top: 30px !important; 
	}
    
    
</style>     

	   	 <h4 class="text-center mt-4">상품 등록</h4>
			<div class="d-flex justify-content-center align-items-center">
			    <form action="p_registration" method="post" enctype="multipart/form-data" class="text-center">
			        <!-- 첫 번째 파일 선택 -->
			        <div style="text-align: center;">
				        <img id="productImagePreview1" src="images/add_photo.png" alt="상품 이미지 1" 
	    					 class="image-preview" style="width: 150px; height: 150px; cursor: pointer; object-fit: cover; border-radius: 15px;" />
			            <input type="file" name="file" id="fileInput" class="form-control-file" required 
			            	   onchange="previewImage(event, 'productImagePreview1', 'fileName')" style="display: none;"/><br>
			        	<label for="fileInput" class="btn btn-outline-warning">파일 선택</label><br>
    					<span id="fileName" class="ml-2">선택된 파일이 없습니다.</span>
			        </div>
			
			        
			            <input type="text" name="pdName" class="form-control custom-input-width mt-2" placeholder="상품명" required /><br>
			        
			
			        <div class="d-flex justify-content-center">
			            <select name="pd_animal" class="form-control mr-2" required>
			                <option value="all">전체</option>
			                <option value="dog">강아지</option>
			                <option value="cat">고양이</option>
			            </select>
			        
			
			            <select name="pd_category" class="form-control mb-4" required>
			                <option value="food">사료</option>
			                <option value="refreshment">간식</option>
			                <option value="product">용품</option>
			                <option value="etc">리빙</option>
			            </select><br>
			        </div>
			        
			            <input type="text" name="pd_price" class="form-control custom-input-width" placeholder="가격" required /><br>
			        
			
			            <input type="text" name="pd_amount" class="form-control custom-input-width" placeholder="수량" required /><br>
			       
			
			        <div style="text-align: center;">
			            <img id="productImagePreview2" src="images/add_photo.png" alt="상품 상세 이미지 2" 
     						 class="image-preview" style="width: 150px; height: 150px; cursor: pointer; object-fit: cover; border-radius: 15px;" /><br>
			            
			            <input type="file" name="file2" id="fileInput2" class="form-control-file" required 
					           onchange="previewImage(event, 'productImagePreview2', 'fileName2')" style="display: none;"/>
					    <label for="fileInput2" class="btn btn-outline-warning file-input-label">파일 선택</label><br>
					    <span id="fileName2" class="ml-2">선택된 파일이 없습니다.</span>
			        </div>
			        
			        <hr class="custom-hr">
			        
				        <input type="submit" class="btn btn-outline-warning mb-2 custom-width" value="등록하기" /></br>
				        <input type="button" class="btn btn-outline-warning custom-width" value="취소하기" />
			    </form>
			</div>
			
<!-- 이미지 미리보기 -->
<script>
function previewImage(event, previewId, fileNameId) {
    const reader = new FileReader();
    const imagePreview = document.getElementById(previewId);
    const fileNameSpan = document.getElementById(fileNameId);
    
    reader.onload = function() {
        if (reader.readyState === 2) {
            imagePreview.src = reader.result; // 선택한 이미지 미리보기
        }
    }

    reader.readAsDataURL(event.target.files[0]); // 파일을 읽어 미리보기 설정
    
 	// 선택한 파일의 이름을 표시
    const fileName = event.target.files[0] ? event.target.files[0].name : "선택된 파일이 없습니다.";
    fileNameSpan.textContent = fileName; // 파일 이름 표시
}

</script>
       
		<!-- Divider -->
        <div class="custom-container">
            <hr>
        </div>
    </div>
    
    <!-- FOOTER -->
    <footer class="container">
        <p class="float-end"><strong>털뭉치즈</strong></p>
        <p>COMPANY : 털뭉치즈</p>
    </footer>
    
    
<!-- Bootstrap JS, Popper.js, and jQuery -->
    <script src="https://code.jquery.com/jquery-3.5.1.slim.min.js"></script>
    <script src="https://cdn.jsdelivr.net/npm/@popperjs/core@2.9.2/dist/umd/popper.min.js"></script>
    <script src="https://stackpath.bootstrapcdn.com/bootstrap/4.5.2/js/bootstrap.min.js"></script>
</body>
</html>
