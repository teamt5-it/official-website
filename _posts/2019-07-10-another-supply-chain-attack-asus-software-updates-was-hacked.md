---
locale: en
date: 2019-03-28 12:10:30 +0800
title: 'Another Supply Chain Attack: ASUS Software Updates was Hacked!'
banner: "/assets/images/cover_another.png"
categories:
- resource
- newsroom
tags:
- case study
sticky: false

---
Asus, one of the world’s largest computer makers, was believed to be the newest victim of a supply chain attack. According to the up-to-date blog of Kaspersky \[1\], the live software update server of Asus was compromised and used for installing malicious backdoors on customers’ devices.

It was alleged that the malware had been delivered to millions of computers. Due to the design logic, however, the malware will only survive in only a small set of computers if the MAC address falls in a target list defined by the actors. This phenomenon has been observed in several Chinese originated supply Chain attacks, such as CCleaner and NetSarang supply chain attacks in 2017.

TeamT5 was able to find several samples of this serial attack and performed technical analysis on it. The C2 is [https://asushotfix\[.\]com](https://asushotfix\[.\]com/logo2.jpg), which was shut down while analyzing. Thus, we are not able to provide further information yet.

![Figure 1 Shellcode encoding routine in ASUS sample, which is the same as PlugX Fast version](/assets/images/02_01.png "Figure 1 Shellcode encoding routine in ASUS sample, which is the same as PlugX Fast version")
_Figure 1 Shellcode encoding routine in ASUS sample, which is the same as PlugX Fast version_
The result suggests China as the origin of this attack for using PlugX Crypt for the shellcode derived from the file. Besides, TeamT5 observed several similar techniques between the attack and the previous supply chain attacks, such as inserting malicious shellcode in the run-time initialization routine in C program. TeamT5 possess with high confidence that the ASUS case was China originated and linked to the CCleaner and NetSarang attacks.

From the C2 domain activation history, TeamT5 believes the initial campaign itself started from May 2018 and ended in around Oct. 2018. However, the computers in the target list will be implanted with other malware and keep being controlled by the threat actors. The only knowledge regarding the targets is a list of MAC address hashes and could not be mapped to organizations or individuals. We are to inform our clients to check the IDS/IPS or try to use TeamT5’s ThreatSonar to scan for further detect and defense.

### Reference

\[1\] [https://securelist.com/operation-shadowhammer/89992/](https://securelist.com/operation-shadowhammer/89992/ "https://securelist.com/operation-shadowhammer/89992/")

#### **Appendix**

l Indicator of Compromise (IoC)

**C2 Domains and IPs:**

* asushotfix\[.\]com
* simplexoj\[.\]com
* homeabcd\[.\]com
* 35.154.92\[.\]115
* 141.105.71\[.\]116

**Malicious download links:**

* hxxp://liveupdate01.asus\[.\]com/pub/ASUS/nb/Apps_for_Win8/LiveUpdate/Liveupdate_Test_VER365.zip
* hxxps://liveupdate01s.asus\[.\]com/pub/ASUS/nb/Apps_for_Win8/LiveUpdate/Liveupdate_Test_VER362.zip
* hxxps://liveupdate01s.asus\[.\]com/pub/ASUS/nb/Apps_for_Win8/LiveUpdate/Liveupdate_Test_VER360.zip
* hxxps://liveupdate01s.asus\[.\]com/pub/ASUS/nb/Apps_for_Win8/LiveUpdate/Liveupdate_Test_VER359.zip

Hashes（MD5）:

* 5855362028a58d8760c9ea2dcdf37af5
* 0db57cc899ae7385c60b16a62b748a18
* c0116d877d048b1ba87c0de6fd7c3fb2
* 7df9736f60a979eee5b90d6c53dc9374
* 56a046f11c84c691295267dcf1f00c4a
* fa83ffde24f149f9f6d1d8bc05c0e023
* 17a36ac3e31f3a18936552aff2c80249
* 2a95475af7a07ee95ab11caad9e99b0c
* 0f49621b06f2cdaac8850c6e9581a594
* f2f879989d967e03b9ea0938399464ab
* 06c19cd73471f0db027ab9eb85edc607
* 63f2fe96de336b6097806b22b5ab941a
* 9c74402572344aee9018587188fe441e
* bd809a2abb1eda0e28becc1661b96581
* 8baa46d0e0faa2c6a3f20aeda2556b18
* cdb0a09067877f30189811c7aea3f253
* aa15eb28292321b586c27d8401703494
* 8756bafa7f0a9764311d52bc792009f9
* 2ec9d0df80df005becbd37142811e43b
* 55a7aa5f0e52ba4d78c145811c830107
* 915086d90596eb5903bcd5b02fd97e3e
* 5220c683de5b01a70487dac2440e0ecb
* 5855ce7c4a3167f0e006310eb1c76313

**Thumbprint of abused certificate:**

* 626646d29c5b0e7c53aa84698a4a97be323cf17f

Yara rule:

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
    
    }

#### How to use IOC in ThreatSonar

A. You can import IOCs into ThreatSonar and launch “Retro Hunt” to see if there is any matches.

![Import IOC into ThreatSonar Intel.](/assets/images/02_02.png "Import IOC into ThreatSonar Intel.")
_Import IOC into ThreatSonar Intel._

B. The malware is using valid “ASUSTek” certificate, the thumbprint of the certificate can be searched in “Hunter” page.

![Details of abused certificate.](/assets/images/02_03.png "Details of abused certificate.")
_Details of abused certificate._
                      
                      
In “Hunter” page, you are able to search “thumbprint = 626646d29c5b0e7c53aa84698a4a97be323cf17f” by switching scope to “Certificate” (Please select “Engine Version” to All).

p.s. If you find any matched results, don’t be hesitate to contact with us.

![Thumbprint matched endpoints and programs.](/assets/images/02_04.png "Thumbprint matched endpoints and programs.")
_Thumbprint matched endpoints and programs._
![The related thumbprint was found.](/assets/images/02_05.png "The related thumbprint was found.")
_The related thumbprint was found._

C. To use the yara rule, just create yara ruleset, then copy and paste the yara rule listed above.

![Import the yara rule.](/assets/images/02_06.png "Import the yara rule.")
_Import the yara rule._