<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>Insert title here</title>
<style type="text/css">
.skeleton-item {
    height: 35px;
    background-color: #e0e0e0;
    margin: 5px 0;
    border-radius: 4px;
    animation: pulse 1.5s infinite;
}

@keyframes pulse {
    0% {
        opacity: 1;
    }
    50% {
        opacity: 0.5;
    }
    100% {
        opacity: 1;
    }
}
.table-responsive table {
        table-layout: fixed;
        width: 100%;
    }
</style>
</head>
<body>

<div class="d-flex flex-column w-100 ms-3">
    <div class="card p-2" id="allContactTable"  style="height: 100%;
        data-list='{"valueNames":["regDate","importYn","apprTitle","senderName","file","apprStatus"],"page":10,"pagination":true}'>
        <h4 class="p-3 m-0 align-middel" id="categoryName">
			
		</h4>
        <div class="card-body p-1">
            <div class="table-responsive scrollbar">
                <div class="search-container p-3">
                    <input type="text" id="searchInput" placeholder="제목, 기안자 검색..." />
                </div>
                
                <table class="table table-bordered table-striped fs-10 mb-0">
                    <thead class="bg-200">
                        <tr>
                            <th class="text-900 sort text-center" data-sort="regDate" >기안일</th>
                            <th class="text-900 sort text-center" data-sort="importYn" style="width: 5%;">긴급</th>
                            <th class="text-900 sort text-center" data-sort="apprTitle">제목</th>
                            <th class="text-900 sort text-center" data-sort="senderName">기안자</th>
                            <th class="text-900 sort text-center" data-sort="file" style="width: 5%;">첨부</th>
                            <th class="text-900 sort text-center" data-sort="apprStatus" style="width: 10%;">상태</th>
                        </tr>
                    </thead>
                    <tbody class="list" id="table-contact-body">
                        <tr><td colspan="6"><div class="skeleton-item"></div></td></tr>
                        <tr><td colspan="6"><div class="skeleton-item"></div></td></tr>
                        <tr><td colspan="6"><div class="skeleton-item"></div></td></tr>
                        <tr><td colspan="6"><div class="skeleton-item"></div></td></tr>
                        <tr><td colspan="6"><div class="skeleton-item"></div></td></tr>
                        <tr><td colspan="6"><div class="skeleton-item"></div></td></tr>
                        <tr><td colspan="6"><div class="skeleton-item"></div></td></tr>
                        <tr><td colspan="6"><div class="skeleton-item"></div></td></tr>
                        <tr><td colspan="6"><div class="skeleton-item"></div></td></tr>
                        <tr><td colspan="6"><div class="skeleton-item"></div></td></tr>
                    </tbody>
                </table>
            </div>
            <div class="d-flex justify-content-center mt-3">
            	
                <ul class="pagination mb-0"></ul>
                
            </div>
        </div>
    </div>
</div>


	<!-- ===============================================-->
	<!--    content 끝    -->
	<!-- ===============================================-->
	</div>
</body>
<script type="text/javascript">
let status = "${listType}";

$(document).ready(function() {
    loadApprovalList(); // 페이지 로드 시 전자결재 리스트 불러오기
    
    $('#searchInput').on('input', function() {
        const searchTerm = $(this).val().toLowerCase();
        filterApprovalList(searchTerm);
    });
});

function filterApprovalList(searchTerm) {
	const rows = $("#table-contact-body").find('tr'); // 모든 행 가져오기

    	rows.each(function() {
        const title = $(this).find('.apprTitle').text().toLowerCase(); // 제목
        const content = $(this).find('.apprContent').text().toLowerCase(); // 내용 (apprContent 클래스 추가 필요)
        const sender = $(this).find('.senderName').text().toLowerCase(); // 기안자

        // 검색어가 제목, 내용, 기안자 중 하나에 포함되어 있는지 확인
        if (title.includes(searchTerm) || content.includes(searchTerm) || sender.includes(searchTerm)) {
            $(this).show(); // 해당 행 표시
        } else {
            $(this).hide(); // 해당 행 숨김
        }
    });
}

function loadApprovalList() {
    $.ajax({
        url: "/approval/approvalList.do",  // 서버에서 리스트를 불러오는 URL
        type: "GET",
        success: function(response) {
            updateApprovalLists(response);  // 각 결재 리스트 업데이트
            
        },
        error: function(xhr, status, error) {
            console.error("전자결재 목록을 불러오는 중 오류 발생:", error);
        }
    });
}

function updateApprovalLists(data) {
    // 결재 대기함, 처리함, 예정함, 완료함 데이터 분리
    let list;
    if (status === "전체 결재수신함") {
        list = data.filter(item => item.apprStatus != '임시' && item.memNo != memNo);
        $('#categoryName').text('전체 결재 수신함');
    } else if (status == "결재 대기함") {
        list = data.filter(item => item.apprStatus == '진행중' && item.myOrder == (item.apprOrder + 1) && item.memNo != memNo);
        $('#categoryName').text('결재 대기함');
    } else if (status == "결재 예정함") {
        list = data.filter(item => item.apprStatus == '진행중' && item.myOrder > (item.apprOrder + 1) && item.memNo != memNo);
        $('#categoryName').text('결재 예정함');
    } else if (status == "결재 처리함") {
        list = data.filter(item => item.apprStatus == '진행중' && item.myOrder < (item.apprOrder + 1) && item.memNo != memNo);
        $('#categoryName').text('결재 처리함');
    } else if (status == "결재 수신완료함") {
        list = data.filter(item => item.apprStatus == '완료' && item.memNo != memNo);
        $('#categoryName').text('결재 수신 완료함');
    } else if (status == "긴급") {
        list = data.filter(item => item.apprImport == 'Y' && item.memNo != memNo);
        $('#categoryName').text('긴급 결재함');
    } else if (status == "전체 결재발신함") {
        list = data.filter(item => item.apprStatus != '임시' && item.memNo == memNo);
        $('#categoryName').text('전체 결재 발신함');
    } else if (status == "결재 진행함") {
        list = data.filter(item => item.apprStatus == '진행중' && item.memNo == memNo);
        $('#categoryName').text('결재 진행함');
    } else if (status == "결재 반려함") {
        list = data.filter(item => item.apprStatus == '반려' && item.memNo == memNo);
        $('#categoryName').text('결재 반려함');
    } else if (status == "결재 발신완료함") {
        list = data.filter(item => item.apprStatus == '완료' && item.memNo == memNo);
        $('#categoryName').text('결재 발신 완료함');
    } else if (status == "임시 보관함") {
    	list = data.filter(item => item.apprStatus == '임시' && item.memNo == memNo);
    	$('#categoryName').text('임시 보관함');
    }
    
    // 필터링된 리스트를 화면에 출력
    appendApprovalRows(list);
}

function appendApprovalRows(list) {
    const tbody = $("#table-contact-body");
    tbody.empty(); // 기존 행 제거

    list.forEach(approval => {
        const importYn = approval.apprImport === 'Y' ? '<span class="badge rounded-pill bg-danger">긴급</span>' : '';
        const fileYn = approval.fileNo === 0 ? '' : '<span class="far fa-file-alt fs-7"></span>';
        var title= truncateText(`\${approval.apprTitle}`, 15)
        const row = `
            <tr>
                <td class="align-middle regDate white-space-nowrap pe-5 ps-2">
                    <div class="d-flex align-items-center gap-2 position-relative">
                        <h6 class="mb-0">\${approval.regDate}</h6>
                    </div>
                </td>
                <td class="align-middle importYn font-sans-serif white-space-nowrap text-center">
                    \${importYn}
                </td>
                <td class="align-middle apprTitle"><a href="/approval/detail.do?apprId=\${approval.apprId}">\${title}</a></td>
                <td class="align-middle senderName white-space-nowrap pe-5 ps-2">
                    <div class="d-flex align-items-center gap-2 position-relative">
                        <h6 class="mb-0">\${approval.senderName}</h6>
                    </div>
                </td>
                <td class="align-middle file text-center ps-4">
                    \${fileYn}
                </td>
                <td class="align-middle apprStatus fs-9 text-center">
                    <small class="badge rounded badge-subtle-success">\${approval.apprStatus}</small>
                </td>
            </tr>
        `;
        tbody.append(row);
    });

    let contactList = new List('allContactTable', {
        valueNames: ['regDate', 'importYn', 'apprTitle', 'senderName', 'file', 'apprStatus'],
        page: 10,
        pagination: {
            paginationClass: 'pagination',
            innerWindow: 2,
            outerWindow: 0,
            left: '<',
            right: '>',
        }
    });

    // 페이지네이션 번호 처리
    let paginationUl = $('.pagination');
    paginationUl.addClass('justify-content-center');
    let currentPage = 1;
    let totalPages = Math.ceil(contactList.matchingItems.length / 10); // 총 페이지 수
    let maxVisiblePages = 5; // 한번에 보일 페이지 번호 수

    
    loadPage(currentPage);
    
    function loadPage(page) {
        contactList.show(page, 10);
        updatePagination(page);
    }
    
    
    
    

    // 페이지네이션 업데이트 함수
    function updatePagination(currentPage) {
        paginationUl.empty(); // 기존 페이지네이션 제거
        let startPage = Math.max(1, currentPage - Math.floor(maxVisiblePages / 2));
        let endPage = Math.min(totalPages, startPage + maxVisiblePages - 1);

        
        paginationUl.append(`
        		<li class="page-item">
	            	<button class="btn btn-sm btn-falcon-default me-1" type="button" title="Previous" id="prevPage" data-list-pagination="prev"><span class="fas fa-chevron-left"></span></button>
	            </li>
            `);
        
        // 페이지 번호 추가
        for (let i = startPage; i <= endPage; i++) {
            let activeClass = (i === currentPage) ? 'active' : '';
            paginationUl.append('<li class="page-item ' + activeClass + '"><a class="page" href="#" data-page="10" data-i="' + i + '">' + i + '</a></li>');
        }
        
        paginationUl.append(`
        		<li class="page-item">
	            	<button class="btn btn-sm btn-falcon-default ms-1" type="button" title="Next" id="nextPage" data-list-pagination="next"><span class="fas fa-chevron-right"></span></button>
	        	</li>
            `);
    }


    // 페이지 번호 클릭 이벤트 처리
    paginationUl.on('click', 'a.page', function(e) {
        e.preventDefault();
        let selectedPage = parseInt($(this).attr('data-i'));
        loadPage(selectedPage);
    });
}

</script>
</html>
