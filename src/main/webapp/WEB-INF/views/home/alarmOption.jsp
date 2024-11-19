<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<div class="card p-3" style="height: 100%">
    <h2>알림 설정</h2>
    <form id="notificationSettingsForm">
        <div class="form-group">
            <div class="form-check form-switch">
            	<label for="flexSwitchCheckChecked">전자결재 알림</label>
			  	<input class="form-check-input" id="flexSwitchCheckChecked" type="checkbox" checked="" />
			</div>
        </div>
        <div class="form-group">
            <div class="form-check form-switch">
              	<label for="smsNotifications">메일 알림</label>
			 	<input class="form-check-input"  id="flexSwitchCheckChecked" type="checkbox" checked="" />
			</div>
		</div>
        <div class="form-group">
            <div class="form-check form-switch">
	            <label for="pushNotifications">프로젝트 알림</label>
				<input class="form-check-input" id="flexSwitchCheckChecked" type="checkbox" checked="" />
			</div>
        </div>
        <button type="button" class="btn btn-primary" id="saveSettings">저장</button>
    </form>
</div>
