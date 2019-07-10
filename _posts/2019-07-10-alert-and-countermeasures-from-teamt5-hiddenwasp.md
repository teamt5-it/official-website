---
locale: en
date: 2019-07-10T03:13:37.000+00:00
title: Alert and Countermeasures from TeamT5 – “HiddenWasp”
banner: "/assets/images/technical01.jpg"
categories:
- resource
- newsroom
tags:
- technical
sticky: false

---
### **Threat Overview**

(Reference: www.intezer.com )

An American Cybersecurity company, Intezer, discovered a new malware on Linux operating system on May19th, 2019. Key takeaways are as below:

* A new and sophisticated malware named “HiddenWasp” is targeting Linux systems.
* The malware is still active and has a zero-detection rate in all major anti-virus systems. (on May19th, 2019)
* Rather than focusing on crypto-mining or DDoS activity as common Linux malware, “HiddenWasp” is purely used for targeted remote control.
* Evidence shows in high probability that the malware is applied in targeted attacks for victims who are already under the attacker’s control, or have gone through a heavy reconnaissance.
* Possible adversary: Winnti

Further information, please check the following link: [https://www.intezer.com/blog-hiddenwasp-malware-targeting-linux-systems/](https://www.intezer.com/blog-hiddenwasp-malware-targeting-linux-systems/ "https://www.intezer.com/blog-hiddenwasp-malware-targeting-linux-systems/")

![(Zero detection on Virustotal on 19th May)](/assets/images/img1.png "(Zero detection on Virustotal on 19th May)")
*Zero detection on Virustotal on 19th May*
### **ThreatSonar Linux scanner**

ThreatSonar scanner (ver. 20190413) supports Linux operating system such as CentOS, RHEL, Debian, Ubuntu and OpenSUSE.

Our analyst discovered “HiddenWasp” contains rootkit that is able to hide itself from detection. However, ThreatSonar is capable of identifying related shell script and listing them as the highest threat level.

![(ThreatSonar detects related shell script of HiddenWasp)](/assets/images/img2.png "(ThreatSonar detects related shell script of HiddenWasp)")
*ThreatSonar detects related shell script of HiddenWasp*
You can find our demo video from the link below: [https://drive.google.com/open?id=13EybLqxAPeO1-E2OzjHKVvdCzHfK6FVL](https://drive.google.com/open?id=13EybLqxAPeO1-E2OzjHKVvdCzHfK6FVL "https://drive.google.com/open?id=13EybLqxAPeO1-E2OzjHKVvdCzHfK6FVL")

### **Bring Your Own Intelligence**

TeamT5 optimized the Intezer’s yara rule for “HiddenWasp” \[1\]. We suggest importing it to ThreatSonar as the steps below:

1. Go to “Custom Yara”.
2. Click “Add Ruleset” and paste the yara rule to the editor.
3. Set “Ruleset Threat Level” and enable it.
4. Click “Create Ruleset” to finish.

![(Built-in yara rule editor)](/assets/images/img3.png "(Built-in yara rule editor)")
*Built-in yara rule editor*
IoC of “HiddenWasp” \[2\] can be imported to ThreatSonar for direct match as well.


Should you have any questions, please contact support@teamt5.tw


\[1\] [https://drive.google.com/open?id=1zDArnZxvj2ClyJIV2NwdZv7VMAhA5bJg](https://drive.google.com/open?id=1zDArnZxvj2ClyJIV2NwdZv7VMAhA5bJg "https://drive.google.com/open?id=1zDArnZxvj2ClyJIV2NwdZv7VMAhA5bJg")

\[2\] [https://exchange.xforce.ibmcloud.com/collection/d1900ab023aa857e116f9c55fabda2fc](https://exchange.xforce.ibmcloud.com/collection/d1900ab023aa857e116f9c55fabda2fc "https://exchange.xforce.ibmcloud.com/collection/d1900ab023aa857e116f9c55fabda2fc")