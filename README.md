# Vibration Braille App

## 1. 아이템 선정 

점자 표시가 되어있지 않은 물건도 시각장애인이 알 수 있게 하는 앱.
저장되어있는 사진을 선택하면 해당 글자를 점자로 번역해 진동으로 표현한다.


## 2. 개요 

+ 프로젝트 명칭 : VibrationBrailleApp

+ 개발 인원 : 1명 

+ 개발 기간 : 2023.01.02 ~ 2023.01.30 

+ 주요 기능 : 
  
  + 갤러리 - 핸드폰에 저장되어있던 사진 가져오기
  
  + OCR – 촬영된 사진의 텍스트 추출

  + 점자번역 – 추출된 텍스트 분리, 글자에 맞는 점자리스트 찾기
  
  + 진동출력 – 점자리스트에 맞게 진동으로 점자 표현

+ 개발 언어 : Dart 2.18.5

+ 개발 환경 : Flutter 3.3.9

+ API : OCR Space Free API 

+ 앱 실행 절차 : 
     갤러리에서 이미지를 가져오기 위해 사용자에게 카메라에 대한 권한을 요청한다. 
    사용자가 권한 허락을 하였다면 장치 내 갤러리에서 선택된 이미지를 가져와 화면에 나타낸다.
     가져온 이미지에서 텍스트를 추출하기 위해 OCR Space의 Free API를 사용한다. 
    OCR Space API는 base64 이미지만을 취급하기 때문에 이미지를 변환시킨다. 
    변환된 이미지에서 글자가 추출되면 json형식으로 파일을 보내주는데, 그 파일에서 텍스트만 골라 변수 parsedtext에 대입한다. 
    그다음 글자를 점자로 번역해주는 Braile.dart 파일로 텍스트를 전달한다.
     전달된 텍스트가 한글인지 영어 혹은 기호인지 체크한 다음, 한글 텍스트를 초성, 중성, 종성으로 나누어 제작해둔 점자 리스트에서 점자값을 가져온다. 
    1과 0으로만 이루어진 점자리스트가 완성되었다면 이 리스트를 진동시간으로 변환하여 진동시간 리스트를 제작한다. 
    이때 진동시간은 점자 표시가 있을때는 0.5초의 진동, 점자 표시가 없을때는 0.2초의 진동으로 한다. 
    점자와 점자 사이를 나타내기 위해 0.1초의 대기 시간을 주고, 다른 글자로 넘어갈 때 사용자에게 알려주기 위해 0.8초의 대기 시간을 준다. 
    완성된 진동시간 리스트를 camera.dart로 반환해 기기에서 진동을 발생시킨다.
     이미지 선택만 하면 텍스트 추출부터 진동점자 표시까지 한번에 진행된다.


## 3. 요구사항 분석 

### 1. 갤러리 버튼 

+ 사진을 가져올수 있는 버튼

  + AndroidManifest 갤러리 권한 요청 추가하기 

### 2. 이미지 화면 

+ 사진이 선택되었을때

  + 선택된 사진 표시
  
+ 사진이 선택되지 않았을때 

  + "이미지를 선택해 주세요 :)" 표시

### 3. 텍스트 상자 

+ 사진이 선택되면 OCR API를 이용하여 텍스트 추출 

+ 추출된 텍스트를 텍스트 상자에 표현

### 4. 진동 

+ AndroidManifest 진동 권한 요청 추가하기 

+ 텍스트 상자에 글자가 표시되면 braille.dart 로 전달하여 글자를 쪼개고 쪼개진 글자에 맞는 점자리스트 확보 

+ 점자리스트에 맞춰 진동표시 


## 4. 앱 디자인

### 아이콘
![1](https://user-images.githubusercontent.com/85046063/215409464-e3a1d686-3831-401b-928c-139ac18d8ff2.jpg)

----------------------

### 메인 페이지

<img src="https://user-images.githubusercontent.com/85046063/215409498-394ce6bc-2126-4fcb-9b87-c8bc6ec86dcd.jpg" width="40%" height="40%"> <img src="https://user-images.githubusercontent.com/85046063/215409508-b6198e3a-e591-4a31-a8b5-3b658b8eb1bd.jpg" width="40%" height="40%"> 

---------------------- 

### 실행 영상

![4번](https://user-images.githubusercontent.com/85046063/215409590-2627d0a8-f756-49c4-8bf8-9426cf26660c.gif)
![5번](https://user-images.githubusercontent.com/85046063/215409605-e08ffe8f-969d-46dd-943b-832d894636d8.gif)
![6번](https://user-images.githubusercontent.com/85046063/215409607-d3fea876-61f5-46f7-a9d3-dbcca87829b3.gif)

---------------------- 

### 진동 규칙

![7](https://user-images.githubusercontent.com/85046063/215409678-c8c9750f-207e-4c66-b496-19c4dac98844.jpg)

---------------------- 

### 점자 리스트

![8](https://user-images.githubusercontent.com/85046063/215409776-0cebb055-bca5-41bd-b391-3a343f172cf7.jpg)
![9](https://user-images.githubusercontent.com/85046063/215409799-60817772-f245-4825-bcfc-e1ad6dbc152c.jpg)
![10](https://user-images.githubusercontent.com/85046063/215409800-8fe1e7ff-099b-466b-8799-2daa349b1149.jpg)
![11](https://user-images.githubusercontent.com/85046063/215409803-5eaef452-216d-44b8-9741-00eb6b4f7c0a.jpg)

---------------------- 

### 진동 점자 리스트 예시

![12](https://user-images.githubusercontent.com/85046063/215409832-b37aa8ae-8684-4e2f-b907-b79cbc95c391.jpg)
![13](https://user-images.githubusercontent.com/85046063/215409836-c5d2b16f-b8fe-4f4b-8d33-d7cc174930d9.jpg)

---------------------- 

