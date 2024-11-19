<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>



<style>
#sidebar-content {
	height: calc(100% - 240px);
}
#tableExample2{
	height: calc(100% - 120px);
}
.table > :not(caption) > * > * {
	padding: 5px;
}
.notice-row{
	backgroun-color: #f9f9f9;
	font-weight: bold;
}

.new-badge {
    background: linear-gradient(90deg, #ff416c, #ff4b2b); /* 그라디언트 색상 */
    color: white;
    padding: 1px 4px;
    border-radius: 2px;
    font-weight: bold;
    font-size: 0.9em;
}

</style>


<!-- ===============================================-->
<!--    content 시작    -->
<!-- ===============================================-->


	<div style="flex: 10 auto">
	
	<div class="d-flex justify-content-between align-items-center p-3">
	    <h4 class="mb-0">${postType}</h4> <!-- 아래쪽 여백을 제거 -->
	    <div class="search-box align-middle position-relative" data-bs-toggle="search" data-bs-display="static">
	        <input class="form-control search-input" type="search" placeholder="Search..." aria-label="Search" id="searchInput" name="searchWord"/>
	        <span class="fas fa-search search-box-icon"></span>
	        <div class="btn-close-falcon-container position-absolute end-0 top-50 translate-middle shadow-none" data-bs-dismiss="search">
	            <button class="btn btn-link btn-close-falcon p-0" aria-label="Close"></button>
	        </div>
	    </div>
	</div>
		
	<div class="d-flex flex-column py-2 px-3 position-relative" data-list='{"valueNames":["boardNo","boardTitle","memName","boardCreate","boardHit"]'>
		<div class="table-responsive scrollbar" style="flex: 1;">
		<table class="table table-bordered border-500 fs-9 mb-0" style="border-collapse: collapse;">
			<thead class="bg-200">
				<tr>
		          <th data-sort="postNo" style="width: 100px; text-align: center;">번호</th>
		          <th data-sort="boardTitle" style="width: 350px; text-align: center;">제목</th>
		          <th data-sort="memName" style="width: 130px; text-align: center;">작성자</th>
		          <th data-sort="boardCreate" style="width: 130px; text-align: center;">등록일</th>			
		          <th data-sort="boardHit" style="width: 100px; text-align: center;">조회수</th>			
				</tr>
			</thead>
	
			<tbody id="boardList" class="list">
			<!-- Ajax 통해 게시글 삽입할 구간 -->
			</tbody>
		</table>
		</div>	
		<input type="hidden" id="postType" value="${postType}"/>
		<!--  페이징 처리 -->
		<div class="d-flex flex-row justify-content-center card-footer clearfix h-25" id="pagingArea">
		</div>
	</div>



<!-- ===============================================-->
<!--    content 끝    -->
<!-- ===============================================-->


<script type="text/javascript">
$(function () {
	
	// 페이징 처리 시작
	let searchInput = $("#searchInput");
	let postType = $("#postType").val();
	
	getPage("page",1);
	
	$("#pagingArea").on("click", "a", function (e) {
	    e.preventDefault(); 
	    let page = $(this).data("page"); 
	    getPage("page", page); 
	});
	
	searchInput.on("keydown", function (event) {
		if (event.keyCode == 13) {
			let searchWord = searchInput.val();
			getPage("search", searchWord);
		}
	})
	
	function getPage(type, value) {
		
		if (type == "page") {
			data = {currentPage : value,
					postType : postType
					};	
		}
		if (type == "search") {
			data = {searchWord : value,
					currentPage : 1,
					postType : postType
					};	
		}
		$.ajax({
			url : "/board/paging.do",
			method : "post",
			data : JSON.stringify(data),
			contentType : "application/json; charset=utf-8",
			success : function (pagingVO) {
				let dataListHTML = "";
				if (pagingVO.dataList!=null) {
					pagingVO.dataList.forEach(function (board) {
						if(board.boardNotice === 'Y'){
							
						    // 게시글 생성 날짜를 Date 객체로 변환
						    const createDate = new Date(board.boardCreate);
						    const currentDate = new Date();
						    
						    // 현재 날짜와 생성 날짜의 차이를 계산 (밀리초 단위)
						    const timeDiff = currentDate - createDate;
						    const dayDiff = timeDiff / (1000 * 3600 * 24); // 밀리초를 일로 변환

						    // NEW 태그를 추가할지 여부 결정
						    const newTag = dayDiff <= 3 ? '<span class="new-badge">NEW</span> ' : '';
							
							dataListHTML += `
		                    <tr class="notice-row" style="background-color: lightgray;">
								<td class="postNo" style="text-align: center;"><i class="fa fa-bullhorn" style="color:red; margin-right:5px;"></i>공지</td>
								
								<td class="boardTitle">\${newTag}<a href='/board/detail/\${board.boardNo}'>\${board.boardTitle}</a>
								\${board.delYn == 'N' ? '<span class="fas fa-paperclip fs-10 ms-2"></span>' : ''}
								</td>
								
								<td class="memName" style="text-align: center;">\${board.memName}</td>
								<td class="boardCreate" style="text-align: center;">\${board.boardCreate}</td>
								<td class="boardHit" style="text-align: center;">\${board.boardHit}</td>
							</tr>`;
						}else{
		                    dataListHTML += `
		                    <tr>
								<td class="postNo" style="text-align: center;">\${board.postNo}</td>
								
								<td class="boardTitle"><a href='/board/detail/\${board.boardNo}'>\${board.boardTitle}</a>
								\${board.delYn == 'N' ? '<span class="fas fa-paperclip fs-10 ms-2"></span>' : ''}
								</td>
								
								<td class="memName" style="text-align: center;">\${board.memName}</td>
								<td class="boardCreate" style="text-align: center;">\${board.boardCreate}</td>
								<td class="boardHit" style="text-align: center;">\${board.boardHit}</td>
							</tr>`;
						}
					});
					$("#boardList").html(dataListHTML);
					$("#pagingArea").html(pagingVO.pagingHTML);
				}else{
					$("#boardList").html("<tr><td colspan='5'>게시글이 없습니다</td></tr>");
				}
				
			}
		});
	}


});

</script>

