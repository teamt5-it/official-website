---
date: 2019-03-28 12:14:02 +0800
locale: zh
title: ASUS Live Update事件
banner: "/assets/images/cover_another.png"
categories:
- resource
- newsroom
tags:
- case study
resource_sticky: true
newsroom_sticky: false

---
photo courtesy of: pixabay.com

### ASUS Live Update事件

### （a.k.a. Operation ShadowHammer）

關於近日（3/25）國外媒體報導華碩Live Update伺服器遭駭，駭客進行供應鏈攻擊（Supply Chain Attack），趁使用者更新產品時，鎖定600組MAC地址用戶，植入惡意程式。
                                  
                                  
TeamT5分析樣本後，發現更新包裡面的Setup.exe，是被插入後門程式的安裝檔，在程式的runtime初始化階段植入shellcode，會先檢查MAC Address是不是在設定好的清單中，如果是的話才會連線到C2: http://www.asushotfix\[.\]com/logo2\[.\]jpg，下載並執行shellcode。本事件與2017年發生之CCleaner和NetSarang供應鏈攻擊事件手法相似，可以關聯到Winnti攻擊族群。

![](/assets/images/02_01.png)
*i惡意程式shellcode中包含了PlugX decoder*
                                
                                
我們從中繼站Domain活動的紀錄分析，攻擊起始於2018年5月，於2018年10月中止。雖然報導之攻擊行為目前停止活動，然而被鎖定的主機很可能已遭安裝其他惡意程式，並且被攻擊者控制中，我們建議客戶透過ThreatSonar進一步確認是否有受害主機。
                            
                            
ThreatSonar具有獨特行為模型引擎以及威脅狩獵（Hunter）功能，可藉由IoC資訊如數位簽章指紋，獵尋惡意程式是否存在內網端點，以下提供本次事件相關IoC資訊與透過ThreatSonar檢測內部環境狀況操作步驟。
                      
                      
#### IoC資訊
* 中繼站Domain以及IP:
  * asushotfix\[.\]com
  * simplexoj\[.\]com
  * homeabcd\[.\]com
  * 35.154.92\[.\]115
  * 141.105.71\[.\]116
* 惡意更新檔下載位置:

o hxxp://liveupdate01.asus\[.\]com/pub/ASUS/nb/Apps_for_Win8/LiveUpdate/Liveupdate_Test_VER365.zip

o hxxps://liveupdate01s.asus\[.\]com/pub/ASUS/nb/Apps_for_Win8/LiveUpdate/Liveupdate_Test_VER362.zip

o hxxps://liveupdate01s.asus\[.\]com/pub/ASUS/nb/Apps_for_Win8/LiveUpdate/Liveupdate_Test_VER360.zip

o hxxps://liveupdate01s.asus\[.\]com/pub/ASUS/nb/Apps_for_Win8/LiveUpdate/Liveupdate_Test_VER359.zip

* 檔案Hash（MD5）:

o 5855362028a58d8760c9ea2dcdf37af5

o 0db57cc899ae7385c60b16a62b748a18

o c0116d877d048b1ba87c0de6fd7c3fb2

o 7df9736f60a979eee5b90d6c53dc9374

o 56a046f11c84c691295267dcf1f00c4a

o fa83ffde24f149f9f6d1d8bc05c0e023

o 17a36ac3e31f3a18936552aff2c80249

o 2a95475af7a07ee95ab11caad9e99b0c

o 0f49621b06f2cdaac8850c6e9581a594

o f2f879989d967e03b9ea0938399464ab

o 06c19cd73471f0db027ab9eb85edc607

o 63f2fe96de336b6097806b22b5ab941a

o 9c74402572344aee9018587188fe441e

o bd809a2abb1eda0e28becc1661b96581

o 8baa46d0e0faa2c6a3f20aeda2556b18

o cdb0a09067877f30189811c7aea3f253

o aa15eb28292321b586c27d8401703494

o 8756bafa7f0a9764311d52bc792009f9

o 2ec9d0df80df005becbd37142811e43b

o 55a7aa5f0e52ba4d78c145811c830107

o 915086d90596eb5903bcd5b02fd97e3e

o 5220c683de5b01a70487dac2440e0ecb

o 5855ce7c4a3167f0e006310eb1c76313

* 遭濫用之憑證Thumbprint：626646d29c5b0e7c53aa84698a4a97be323cf17f

* Yara rule：如附錄。

#### 操作步驟

1. 請將以上IP、Domain、Hash資訊匯入ThreatSonar進行Retro Hunt偵測，或檢查防火牆過往連線紀錄。
                        
                        
   ![](/assets/images/02_02.png)
   *匯入IoC至ThreatSonar Intel設定*
                        
                        
2. 此事件惡意程式使用合法的ASUSTek數位簽章，可透過ThreatSonar Hunter功能搜尋憑證指紋(Thumbprint)。
                      
                      
   ![](/assets/images/02_03.png)
   *遭植入惡意程式之憑證詳細內容*
                            
                            
在威脅狩獵（Hunter）功能中，切換Scope至憑證（Certificate），搜尋"thumbprint = 626646d29c5b0e7c53aa84698a4a97be323cf17f"（請選擇Engine Version為全選），可依憑證指紋內容搜尋環境內符合條件的憑證及其對應的端點與程式清單。
                   
                   
   **註：如有發現憑證指紋相同之程式，請通知我們協助處理。**
                              
                              
   ![](/assets/images/02_04.png)
   *以Thumbprint查詢符合條件的憑證及對應端點*
                          
                          
   ![](/assets/images/02_05.png)
   *確實符合憑證指紋(Thumbprint)*
                             
                             
3. 匯入Yara rule，偵測符合規則之相關惡意程式。在「Custom Yara」頁面中，新增規則集，貼上附錄之Yara rule即可。
                          
                          
   ![](/assets/images/02_06.png)
                            
                            
   若有任何相關問題，歡迎與我們聯繫（support@teamt5.tw）。
                        
                        
**TeamT5 杜浦數位安全**

**附錄**

**Yara rule**
```
rule apt_trojan_AsusSetup_encoder
{
strings:
$plugx_crypt = { 55 8BEC 81EC 08010000 53 56 57 8DBD F8FEFFFF B9 42000000 B8 CCCCCCCC F3 AB C745 F8 00000000 C745 EC 00000000 8B45 08 8B08 894D E0 8B45 08 8B08 894D D4 8B45 08 8B08 894D C8 8B45 08 8B08 894D BC 8B45 E0 C1E8 03 8B4D E0 8D9401 EFEEEEEE 8955 E0 8B45 D4 C1E8 05 8B4D D4 8D9401 DEDDDDDD 8955 D4 8B45 C8 C1E0 07 B9 33333333 2BC8 034D C8 894D C8 8B45 BC C1E0 09 B9 44444444 2BC8 034D BC 894D EC 8B45 EC 8945 BC 8B45 08 0345 F8 0FB608 8B55 E0 81E2 FF000000 0FB6C2 8B55 D4 81E2 FF000000 0FB6D2 03C2 8B55 C8 81E2 FF000000 0FB6D2 03C2 8B55 EC 81E2 FF000000 0FB6D2 03C2 33C8 8B45 10 0345 F8 8808 8B45 F8 83C0 01 8945 F8 8B45 F8 3B45 0C 0F8C 50FFFFFF 5F 5E 5B 8BE5 5D C2 0C00 }

condition:
all of them
}

rule apt_trojan_AsusSetup_memory
{
strings:
$plugx_crypt = { 55 8BEC 81EC 08010000 53 56 57 8DBD F8FEFFFF B9 42000000 B8 CCCCCCCC F3 AB C745 F8 00000000 C745 EC 00000000 8B45 08 8B08 894D E0 8B45 08 8B08 894D D4 8B45 08 8B08 894D C8 8B45 08 8B08 894D BC 8B45 E0 C1E8 03 8B4D E0 8D9401 EFEEEEEE 8955 E0 8B45 D4 C1E8 05 8B4D D4 8D9401 DEDDDDDD 8955 D4 8B45 C8 C1E0 07 B9 33333333 2BC8 034D C8 894D C8 8B45 BC C1E0 09 B9 44444444 2BC8 034D BC 894D EC 8B45 EC 8945 BC 8B45 08 0345 F8 0FB608 8B55 E0 81E2 FF000000 0FB6C2 8B55 D4 81E2 FF000000 0FB6D2 03C2 8B55 C8 81E2 FF000000 0FB6D2 03C2 8B55 EC 81E2 FF000000 0FB6D2 03C2 33C8 8B45 10 0345 F8 8808 8B45 F8 83C0 01 8945 F8 8B45 F8 3B45 0C 0F8C 50FFFFFF 5F 5E 5B 8BE5 5D C2 0C00 }

condition:
all of them

```
#### 參考資料

\[1\] https://www.ithome.com.tw/news/129588

\[2\] https://twitter.com/360TIC/status/1110797967621914625

\[3\] https://www.kaspersky.com/about/press-releases/2019_operation-shadowhammer-new-supply-chain-attack