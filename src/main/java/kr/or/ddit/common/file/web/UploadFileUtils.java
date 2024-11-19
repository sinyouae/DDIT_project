package kr.or.ddit.common.file.web;

import java.awt.image.BufferedImage;
import java.io.File;
import java.text.DecimalFormat;
import java.util.Calendar;
import java.util.UUID;

import javax.imageio.ImageIO;

import org.imgscalr.Scalr;
import org.springframework.util.FileCopyUtils;


public class UploadFileUtils {

	// 파일 업로드를 위한 static method
	public static String uploadFile(String uploadPath, String orignalName, byte[] fileData) throws Exception {
		UUID uuid = UUID.randomUUID();
		
		// UUID_원본파일명
		String saveName = uuid.toString()+"_"+orignalName;
		
		// /2024/09/09 폴더 경로 만들고, /2024/09/09 폴더 경로를 리턴한다.
		String savedPath =calcPath(uploadPath);
		System.out.println("savedPath: "+savedPath);
		// 배포된 서버 업로드경로+ /2024/09/09/ + UUID_원본파일명으로 File target을 하나 만든다
		File target = new File(uploadPath+savedPath,saveName);
		FileCopyUtils.copy(fileData, target);	// 파일 복사(업로드 하기 위해 만들어진 최종 경로로 파일 복사가 일어남)
		
		String formatName = orignalName.substring(orignalName.lastIndexOf(".")+1);	//확장자 추출
		System.out.println("formatName: "+formatName);
		// \2024\09\09 경로를 / 경로로 변경후 원본파일 명을 붙인다
		String uploadedFileName = savedPath.replace(File.separatorChar, '/')+"/"+saveName;
		
		// 확장자가 이미지 파일이면 s_가 붙은 파일의 썸네일 이미지 파일을 생성한다.
		if(MediaUtils.getMediaType(formatName)!=null) {
			makThumbnail(uploadPath,savedPath,saveName);
		}
		System.out.println("uploadedFileName: "+uploadedFileName);
		return uploadedFileName;
		
	}
	
	// 썸네일 이미지 만들기
	private static void makThumbnail(String uploadPath, String savedPath, String saveName) throws Exception {
		// 썸네일 이미지를 만들기 위해 원본 이미지를 읽는다
		BufferedImage sourceImg = ImageIO.read(new File(uploadPath+savedPath,saveName));
		// 썸네일 이미지를 만들기 위한 설정을 진행
		// Method.AUTOMATIC : 최소 시간내에 가장 잘보이는 이미지를 얻기위한 사용 방식
		// Mode.FIT_TO_HEIGHT : 이미지 방향과 상관없이 주어진 높이 내에서 가장 잘 맞는 이미지로 계산
		// targetSize : 값 100, 정사각형 사이즈로 100X100
		BufferedImage destImg = Scalr.resize(sourceImg, Scalr.Method.AUTOMATIC, Scalr.Mode.FIT_TO_HEIGHT,100);
		
		// 업로드 한 원본 이미지를 가지고 's_'를 붙여서 임시 파일로 만들기 위해 썸네일 경로 + 파일명을 작성(파일 write를 위한 경로 만들기)
		String thumbnailName = uploadPath+savedPath+File.separator+"s_"+saveName;
		
		File newFile = new File(thumbnailName);
		String formatName= saveName.substring(saveName.lastIndexOf(".")+1);
		
		ImageIO.write(destImg, formatName.toUpperCase(), newFile);	// 's_'가 붙은 썸네일 이미지를 만든다
	}

	private static String calcPath(String uploadPath) {
		Calendar cal = Calendar.getInstance();
		String yearPath = File.separator+cal.get(Calendar.YEAR);	// /2024
		// DecimalFormat("00") : 두자리에서 빈자리는 0으로 채움
		// /2024/09
		String monthPath=yearPath+File.separator+new DecimalFormat("00").format(cal.get(Calendar.MONTH)+1);
		String datePath=monthPath+File.separator+new DecimalFormat("00").format(cal.get(Calendar.DATE));
		
		// 년월일 폴더 구조에의한 폴더 생성
		makeDir(uploadPath,yearPath,monthPath,datePath);
		return datePath;	// /2024/09/09 경로를 전달한다
	}
	
	// 가변인자
	// 키워드 '...' 을 사용한다
	// [사용법] 타입...변수명 형태로 사용할 수 있다
	// 순서대로 yearPath,monthPath,datePath가 배열로 들어와 처리된다.
	private static void makeDir(String uploadPath, String...paths) {
		// /2024/09/09 폴더 구조가 존재한다면 return
		// 만드려던 폴더구조가 이미 만들어져있으면 만들필요럾어서 return 아니면 만들어야함
		if(new File(paths[paths.length-1]).exists()) {
			return;
		}
		
		for (String path : paths) {
			File dirPath = new File(uploadPath+path);
			
			// /2024/09/09 와 같은 경로에 각 폴더가 없으면 각각 만들어준다
			if(!dirPath.exists()) {
				dirPath.mkdirs();
			}
		}
	}
	
}
