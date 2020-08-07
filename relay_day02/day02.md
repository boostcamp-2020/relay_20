# week2 - 🍔Yummy 자연어 처리

### **기능 A (자연어처리)**

1. 사용자의 북마크 모음에 있는 URL들에 접속한다.
2. 접속한 웹페이지의 텍스트 내용으로부터 주제와 내용을 분석하여 주요 키워드 추출한다.
    - 주제와 내용을 분석하는 방법론은 다양하다.
        - 자주 나오는 단어 분석
        - html에서 heading1, 2 정도 중요도를 가지는 문장 분석
        - 해당 웹사이트의 title 분석
        - 단락(paragraph) 단위 분석

<img src="https://user-images.githubusercontent.com/23303023/89626851-f8f9ac80-d8d4-11ea-83b4-55254cd8f529.png" width="50%" />



즐거운 프로젝트 ~

---

# 1. 기능 구현 - 자연어 처리

> **동작 과정**

1. textField에 URL을 입력 한다.
2. 추출 버튼을 터치한다.
3. IBM Cloud의 Watson .. 한테 URL을 전송한다. 
4. 해당 URL에서 자주 등장하는 단어의 카테고리를 전달받는다. 
5. 카테고리를 tableView 형태로 출력한다. 

# 사용 API

- - [[IBM Doc]](https://cloud.ibm.com/apidocs/natural-language-understanding?code=swift#introduction), [github](https://github.com/watson-developer-cloud/swift-sdk#before-you-begin)

    IBM Cloud Watson의  `Natural Language Understanding` 기능 사용 

    URL을 입력하면, 해당 URL의 텍스트 중 등장 빈도가 높은 단어들을 뽑아서 이 단어들과 관련된 주제를 반환해준다.

    - 🥁  ***다음 릴레이 팀께 드리는 팁***
        - Watson에 자연어 처리 말고도 다양한 기능이 있으니 참고하셔도 좋을 것 같아요 ~~!
        - 저희는 카테고리 데이터에서 `label`만 출력해 사용했지만, `score` 프로퍼티 사용하시면 등장 빈도를 수치로 받을 수 있어서, C 기능 구현할 때 유용할 것 같아요 ~~!

## API 사용 방법 참고 자료

[[IBM cloud 사용법]](https://choidongkyu96.github.io/NaturalLanguageUnderstanding/) << 꼭 읽어주세요 !!

**회원가입을 해서 자신의 key와 url을 받아와야 합니다. ‼️** 

## Pod install

- Project 폴더로 가서 pod 을 설치해준다.

```swift
pod init
vi Podfile

// Podfile 안에 추가
pod 'IBMWatsonAssistantV1', '~> 3.5.1'
pod 'IBMWatsonAssistantV2', '~> 3.5.1'
pod 'IBMWatsonNaturalLanguageUnderstandingV1', '~> 3.5.1'

pod install
pod update
```

- Project 에 import

```swift
import Assistant
import NaturalLanguageUnderstanding
```

<img src="https://user-images.githubusercontent.com/23303023/89626860-fdbe6080-d8d4-11ea-8eda-a6f8f4723910.png" width="50%" />


>적용이 안될 때는 껐다 켜보기 ! 



## request 요청

IBM 회원가입 후 본인의 `api-key` 와 `url`을 입력한다.

- myKey
- url

```swift
// MARK: 사용자 키, url 입력
  let **myKey** = ""
  let **ibmUrl** = ""

// 검색할 urlString 요청, limit -> 가져올 카테고리 개수
func requestCategories(urlString: String, limit: Int) {
	// myKey -> 인증된 apiKey 로 교체
  let authenticator = WatsonIAMAuthenticator(apiKey: **myKey**)
  
  let naturalLanguageUnderstanding = NaturalLanguageUnderstanding(version: "2019-07-12", authenticator: authenticator)
	// ibmUrl -> 본인 url로 교체
  naturalLanguageUnderstanding.serviceURL = **ibmUrl**

  let categories = CategoriesOptions(limit: limit)
  let features = Features(categories: categories)

	// 검색할 사이트 url 주소 입력
  naturalLanguageUnderstanding.analyze(features: features, url: urlString) {
    response, error in

    guard let analysis = response?.result else {
      print(error?.localizedDescription ?? "unknown error")
      return
    }

		// analysis 로 결과가 나옴.
		// 그 중에서 categories 만 추출
    for result in analysis.categories! {
        print(result.label!)
    }
  }
}
```

## 실행결과

<img src="https://user-images.githubusercontent.com/23303023/89626876-03b44180-d8d5-11ea-9fb0-ed8168473074.png" width="50%" />

[**알고리즘** 관련 글](https://choidongkyu96.github.io/3차-자동완성/) 검색 결과

<img src="https://user-images.githubusercontent.com/23303023/89626886-0747c880-d8d5-11ea-8957-68c170a4f133.png" width="100%" />

[**도커** 관련 글](https://choidongkyu96.github.io/Docker의-기초/) 검색 결과

<img src="https://user-images.githubusercontent.com/23303023/89626918-0fa00380-d8d5-11ea-85c7-32d9664c755d.png" width="100%" />

---

**참여자** 

- [S027_신병기](https://github.com/EthanShin)
- [S004_고세림](https://github.com/koserim)
- [S060_최동규](https://github.com/ChoiDongKyu96)
- [S061_최철웅](https://github.com/chelwoong)
- [S039_이승진](https://github.com/devilzCough)
- [S017_박성민](https://github.com/rnfxl92)
- [S016_문성주](https://github.com/A-by-alimelon)
- [S028_신은지](https://github.com/devejs)
- [S049_정승범](https://github.com/back99)
- [S050_정재명](https://github.com/jjm159)
- [S003_강병영](https://gist.github.com/RoKang)
- [S038_이상윤](https://gist.github.com/SANGYOONLEE)