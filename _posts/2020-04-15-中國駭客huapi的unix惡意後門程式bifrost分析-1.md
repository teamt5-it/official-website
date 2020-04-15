---
date: 2020-04-15T02:00:00.000+00:00
locale: en
title: 中國駭客HUAPI的惡意後門程式BiFrost分析
banner: "/assets/images/123123.jpg"
categories:
- newsroom
tags:
- blog
- technical
resource_sticky: false
newsroom_sticky: true
blog_sticky: true

---
**關鍵字: HUAPI、PLEAD、GhostCat、CVE-2020-1938、Linux、BiFrost、RC4、RAT**

### 前言

TeamT5近期接獲情資，於台灣某學術網路的圖書館網站上發現存有惡意程式。經過TeamT5研究員分析調查發現，該網站系統使用Tomcat 7.0.73作為網頁伺服器且開啟8009通訊埠，TeamT5研究員驗證網站具有Ghostcat(CVE-2020-1938)漏洞，詳見下圖。

![](/assets/images/upload_138de179b305a67f8ac53a04e7a7b76f.png)
_圖一、Nmap掃描結果_

駭客利用Tomcat網頁伺服器預設開啟的AJP服務(預設為8009通訊埠)，可達到遠端指令執行(Romote Code Execution, RCE)之目的並上傳檔案。於該案例中，駭客疑似透過Ghostcat漏洞上傳BiFrost惡意程式，使該圖書館系統成為惡意程式下載站(Download Site)。

### 惡意程式分析

該惡意程式(8fd3925dadf37bebcc8844214f2bcd18)於2020/01/31被上傳至Virustotal平台，當時的各家防毒軟體的偵測率並不佳，僅有6家防毒軟體能夠有效識別，詳見下圖。

![](/assets/images/upload_182fbfe213a00905cb7703968c5b4303.png)
_圖二、惡意程式於一月底上傳至VirusTotal且一開始防毒軟體的偵測率並不佳_

TeamT5取得該惡意後門程式並進行分析，該惡意後門程式檔名為md.png，但檔案格式為UNIX ELF執行檔，推測是利用PNG副檔名偽裝在Tomcat網站伺服器上，詳見下圖。

![](/assets/images/upload_252083b0a86403a0de983e7c0c23f7ea.png)
_圖三、偽裝為PNG的ELF執行檔_

使用TeamT5的ThreatSonar惡意威脅鑑識系統可有效辨識出該惡意程式並可以偵測到中繼站IP位址(107.191.61.247)，詳見下圖。

![](/assets/images/upload_319bf4e404f1d40461cc42acb5b7cf67.png)
_圖四、ThreatSonar偵測畫面_

經過逆向分析，該惡意後門程式具有上傳/下載/列舉/刪除/搬移檔案(File)、執行/結束程序(Process)、開啟/關閉遠端命令列介面程式(Remote Shell)等功能，其中惡意後門程式與中繼站的連線內容會使用修改過的RC4演算法進行加密，此專屬特徵可用來辯認出此惡意程式，詳見下圖。

![](/assets/images/upload_510cf4aa9e8eb340173d57162e662d1a-1.png)
_圖五、惡意後門程式使用修改後的RC4加密演算法_

### 攻擊族群分析

該惡意程式為Linux版本的BiFrost後門程式，其版本號為5.0.0.0。根據TeamT5長期研究的情資顯示，該惡意程式為中國駭客組織HUAPI (又名為PLEAD) 慣用的後門程式。HUAPI駭客組織自2007年開始活躍至今，攻擊台灣超過10年的時間。TeamT5觀察到HUAPI所開發的惡意程式有時會使用加殼來阻擋研究人員分析，且通常會使用修改後的RC4演算法來加密傳輸。HUAPI長期攻擊政府、高科技、電信或研究智庫單位，根據TeamT5的統計結果，超過5成的受害單位為政府機關，受害國家包含台灣、美國、日本及南韓，其中針對台灣政府機關進行入侵攻擊的為多。

### 影響與建議

若用戶有使用Tomcat服務作為網頁伺服器，且版本為以下之一者：

* Apache Tomcat 9.x < 9.0.31
* Apache Tomcat 8.x < 8.5.51
* Apache Tomcat 7.x < 7.0.100
* Apache Tomcat 6.x

TeamT5建議需要立即進行版本更新，避免遭到駭客利用Ghostcat漏洞進行遠端控制，甚至上傳惡意檔案。

另外，若用戶若遭遇針對性進階持續威脅(Advanced Persistent Threat, APT)時，則需要使用如TeamT5的ThreatSonar惡意威脅鑑識系統，IT管理者可以在最短時間內偵測並回應這類的惡意威脅。TeamT5建議可將下方威脅指標(Indicator of Compromise, IOC)匯入到各式資安設備中偵測與識別威脅。

* 107.191.61.247
* 8fd3925dadf37bebcc8844214f2bcd18
* Yara Rule

      rule RAT_BiFrost_UNIX
      {
          meta:
          description= "HUAPI UNIX BiFrost RAT"
          author = "TeamT5"
          date = "2020-04-15"
          
          strings:
          $hex1 = "25 ?? 00 00 00 85 C0 75 37 8B 45 F0 89 C1 03 4D 08 8B 45 F0 03 45 08 0F B6 10 8B 45 F8 01 C2 B8 FF FF FF FF 21 D0 88 01 8B 45 F0 89 C2 03 55 08 8B 45 F0 03 45 08 0F B6 00 32 45 FD 88 02"
          $hex2 = "8B 45 F0 03 45 08 0F B6 00 30 45 FD 8B 45 F0 89 C1 03 4D 08 8B 45 F8 89 C2 02 55 FD B8 FF FF FF FF 21 D0 88 01"
           
          condition:
          all of them
      }

### 外部參考資料

1. https://cve.mitre.org/cgi-bin/cvename.cgi?name=CVE-2020-1938