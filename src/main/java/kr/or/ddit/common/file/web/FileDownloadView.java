package kr.or.ddit.common.file.web;

import java.io.File;
import java.io.OutputStream;
import java.net.URLEncoder;
import java.util.Map;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.apache.commons.io.FileUtils;
import org.apache.commons.lang3.StringUtils;
import org.springframework.web.servlet.view.AbstractView;

public class FileDownloadView extends AbstractView {

    @Override
    protected void renderMergedOutputModel(Map<String, Object> model, HttpServletRequest request,
            HttpServletResponse response) throws Exception {
        Map<String, Object> fileDetailMap = (Map<String, Object>) model.get("fileDetailMap");
        
        File saveFile = new File(fileDetailMap.get("fileSavePath").toString());
        String filename = fileDetailMap.get("fileName").toString();
        
        String agent = request.getHeader("User-Agent");
        if(StringUtils.containsIgnoreCase(agent, "msie") || StringUtils.containsIgnoreCase(agent, "trident")) {
            filename = URLEncoder.encode(filename, "UTF-8");
        } else {
            filename = new String(filename.getBytes(), "ISO-8859-1");
        }
        
        response.setHeader("Content-Disposition", "attachment; filename=\"" + filename + "\"");
        response.setHeader("Content-Length", fileDetailMap.get("fileSize").toString());
        
        try (OutputStream os = response.getOutputStream()) {
            FileUtils.copyFile(saveFile, os);
        }
    }
}