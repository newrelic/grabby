# Capture

Capture is an early prototype that automatically discovers postential custom attributes to be reported
into New Relic Insights.  You then specify which attributes you want to collect, and then Capture will report
them.

Capture is available only to a handful of adventurous New Relic customers as an early prototype.  It is unclear
whether this will ultimately become a shipping, supported feature.

Capture depends on a recent version of the New Relic Agent (3.9.1 or later) and any Rails application
v2 or later.

Install the gem. 
```
gem 'newrelic_grabby', git: 'git@github.com:newrelic/grabby.git'
```

In your rails app's <conde>config/newrelic.yml</code>, you will need to explicitly turn on 
grabby for your desired environment (development, prod, etc).

```yaml
  grabby:
    enabled: true
```

Run your app.  Look to stdout for [grabby] messages. I'll move this to the agent log when things
get a little more stable.

You will need to turn on a discovery session to have Capture report possible attributes for collection.
To do this, add <code>?grabby_start=true</code> to your url params.  This is a short term hack.  

Whichever process receives this http request will start discovering instance variables and their attributes.  

Now, you'll need an NR Admin to turn on server-side config for the application that is reporting. 

After exercising your app, go to insights: <code>/accounts/:account_id/auto_instrument</code> to see the 
attributes you can collect from your app's agents.  Select which ones you want to collect.

Restart your agent, look for grabby messages in the log, and then look for custom attributes in your
Transaction and PageView events.  Voila!

TERMS AND CONDITIONS BELOW -- PLEASE READ:

New Relic Capture Beta Test Agreement

This New Relic Inc. Beta Test agreement (the “Agreement”) for the New Relic Capture product and features is entered into by New Relic, Inc. (“New Relic”) and “you” or “your”, as identified below. If you are participating in this beta test (the “Beta Test”) or using the Beta Services (defined below) on behalf of an organization, you are binding that entity to this Agreement and stating that you have the authority to do so. In that case, “you” and “your” will refer to that entity. The “Effective Date” of this Agreement will be the date you select ‘I Agree’. You and New Relic agree as follows:

This Agreement is a legal agreement between you and New Relic and it sets forth restrictions and obligations governing your use of the Beta Services and other Confidential Information (defined below). This Agreement also includes a limited license for you to use the Beta Services and the Confidential Information, as well as warranty and liability disclaimers. Please read it carefully before accessing or otherwise using the Beta Services or Confidential Information.

By using the Beta Services or the Confidential Information you are:
1) accepting the terms of this Agreement;
2) confirming that you have the authority to enter into this Agreement; and
3) consenting to be bound by the terms and restrictions set forth in this Agreement.

If you do not agree to be bound by each of the terms and restrictions in this Agreement, then New Relic is unable to allow you to participate in this Beta Test.

1. Definitions.
1.1 “Beta Period” means the time from your receipt of access to the Beta Services until the first commercial release of the Beta Services.

1.2 “Beta Services” means the beta versions of the New Relic Capture analytics service and product features, and any related materials and information, including any development tools, documentation, support materials, corrections and/or updates, made accessible to you by New Relic (or by a third party host on New Relic’s behalf) through the Internet or another network connection for use as governed by this Agreement, including the Software.

1.3 “Confidential Information” means the Beta Services or any related information supplied to you by New Relic, and any Feedback (defined below). Confidential Information includes, without limitation, whether in written, verbal, graphic or electronic form, (a) the Beta Service’s and Software's features and functionality, user interface details (including screen shots), capabilities, specifications, architectural diagrams, APIs and related information, login identifiers, passwords, New Relic development schedules, New Relic email lists, bug databases, know how, trade secrets, and source code; (b) any Feedback regarding the same; (c) discussions of potential features, product changes and Feedback, including the existence of any business discussions, negotiations or agreements in progress between you and New Relic; (d) your opinions about the Beta Services; and (e) the terms and conditions of this Agreement.

1.4 “Data” means any data that you provide or transmit or otherwise makes available as part of your use of the Beta Services. For the avoidance of doubt, test results provided by you to New Relic regarding the Services is excluded from this definition and is subject to the Feedback provision in the Agreement.

1.5 “Feedback” means feedback on evaluation of the Beta Services, including without limitation, feedback on features or functionality, usability, specifications, architectural diagrams, APIs, pricing and related information, software or hardware compatibility, interoperability, performance, bug reports, test results and documentation requirements, and may also include suggestions or ideas for improvements or enhancements to the Beta Services.

1.6 “Software” means versions of any software and related materials and information as determined by New Relic in its sole discretion including any development tools, documentation, support materials, corrections and/or updates supplied by New Relic to you for use in connection with the Beta Test. Use of the Software to access other services provided by New Relic that are outside the scope of this Agreement, shall be governed by the agreement applicable to those services

2. Rights and Restrictions.
2.1 Evaluation License. Subject to the terms of this Agreement, New Relic hereby grants you a limited, nonexclusive, non-transferable and royalty-free license to install and/or use the Software and access the Beta Services during the Testing Period solely for the purpose of internal evaluation of the Beta Services and supplying Feedback to New Relic.

2.2 Beta Services. You acknowledge that your use of the Beta Services requires the transmission of Data (e.g., data and user information) over the Internet or another network. You represent and warrant that you have the necessary rights to provide the Data to New Relic, and grant New Relic the right to use the Data in connection with your use of the Beta Services. You further acknowledge that New Relic may collect information on your usage of the Beta Services and may use such information to modify, improve, or enhance the Beta Services or your ability to access and use the Beta Services. New Relic provides you with the option to encrypt the transmission of your Data. You acknowledge that it is your responsibility to encrypt the transmission of your Data should you wish to protect it. In the event you decide not to utilize encryption and transmit your Data unencrypted over a network, you assume all related risks for doing so. New Relic will not be liable for any liabilities arising from your use of the Beta Services or Software (including your transmission of Data) over the internet or other network. You agree to have sole responsibility for any and all Personal Information provided by you in the course of your use of the Beta Services, and New Relic will have no responsibility with respect to such Personal Information. “Personal Information” is hereby defined as name, address, phone number, e-mail address, IP address, or any other personally identifying information that is provided via your use of the Beta Services.

2.3 New Relic’s Intellectual Property Rights. Except as expressly set forth in this Agreement, you do not acquire any other licenses under any of New Relic’s intellectual property or other proprietary rights. You agree not to reverse engineer, decompile, disassemble or otherwise attempt to discover the source code of the Software

2.4 Communication. You agree not to (a) solicit or otherwise email other Beta Services evaluators on any mail list used by New Relic to communicate information regarding the Beta Services or (b) disclose such list(s) to any party. Upon accessing the Beta Test, you will have access to New Relic's Community Forum (the “Forum”) where there are a number of topic areas including one specifically for beta users. By accessing the Forum, you acknowledge that you are solely liable and responsible for how you use the Forum, as well as your use of the Forum and any damages that may result from the disclosure of your content. You also acknowledge that it is possible that you will be exposed to materials from others that you may consider offensive, indecent, or otherwise objectionable. Views expressed on the Forum do not necessarily reflect New Relic’s views. New Relic does not endorse content posted by you or others. Certain content from others may be incorrectly labeled, rated, or categorized. Your use of the Forum is subject to these Terms and our Community Guidelines.

3. Feedback. In the event you choose to provide New Relic with Feedback, you grant New Relic a non-exclusive, irrevocable, worldwide, royalty-free, sub¬licensable and transferrable right and license to publicly use, copy, publicly display, distribute, modify, publicly perform, publish, reproduce, make, use, sell and export the Feedback. You agree that you have all rights necessary to provide the Feedback to New Relic and you acknowledge that New Relic is not obligated to incorporate, use or otherwise acknowledge any Feedback that you provide.

4. Using the Beta Services.
4.1 Your Use of the Beta Services. You agree that while New Relic may store Data, New Relic has no obligation to do so, except to the extent necessary for New Relic to provide the Beta Services and you further understand and agree that your Data may be transferred to the United States for storage, processing and use by New Relic in order to provide the Beta Services. In addition, New Relic has no responsibility or liability for the deletion or accuracy of the Beta Services, including the failure to store, transmit, or receive transmission of the Data (whether or not processed by the Beta Services), or the security, privacy, storage, or transmission of other communications originating with or involving use of the Beta Services. New Relic retains the right, in its sole discretion, to create reasonable limits on the storage of the Data.

4.2 Monitoring. New Relic, in its sole discretion, may (but has no obligation to) monitor or review the Beta Services or Data at any time. Without limiting the foregoing, New Relic shall have the right, in its sole discretion, to remove any of the Data if it violates the terms of this Agreement or any law. Although New Relic does not generally monitor your activity occurring in connection with the Beta Services, if New Relic becomes aware that you may have violated by any section of this Agreement, New Relic reserves the right to investigate such possible violations, and New Relic may, in its sole discretion, immediately terminate your license to access and use the Beta Services or remove the Data, in whole or in part, without prior notice to you. If New Relic believes that criminal activity has occurred, New Relic reserves the right to refer the matter to, and to cooperate with, any and all applicable law enforcement authorities. New Relic is entitled, except to the extent prohibited by applicable law, to disclose any information, including Data, in New Relic’s possession in connection with your use of the Beta Services to (a) comply with applicable law, legal process or governmental request, (b) enforce this Agreement, (c) respond to any claims that Data violates the rights of third parties, (d) respond to your requests for customer services, or (e) protect the rights, property or personal safety of New Relic, its users or the public, and law enforcement or other government officials, as New Relic in its sole discretion believes to be necessary or appropriate

5. Confidential Information. You agree to hold the Confidential Information in strict confidence and not disclose it to any other party; provided, however, that you may disclose Confidential Information to your employees (a) with a need to know such Confidential Information and (b) that have each signed a written agreement with you containing confidentiality obligations consistent with those set forth in this Agreement. You will treat Confidential Information with the same degree of care as it accords to its own confidential information, but in no event with less than reasonable care. Login identifiers and passwords issued to you (or your employees) are intended for use by the designated individual and shall not be shared with other individuals even if those individuals are your employees. You will treat the Confidential Information with the same degree of care as it accords its own confidential information, but in no event, with less than commercially reasonable care

6. No Warranty. You are aware that the Beta Services are a prerelease version and may be prone to bugs and/or stability issues. New Relic provides the Beta Services, Software and the Confidential Information to you “AS IS,” and New Relic disclaims any warranty or liability obligations to you of any kind. NEW RELIC MAKES NO EXPRESS, IMPLIED, OR STATUTORY WARRANTY OF ANY KIND WITH RESPECT TO THE BETA SERVICES, SOFTWARE AND THE CONFIDENTIAL INFORMATION INCLUDING, BUT NOT LIMITED TO, ANY WARRANTY WITH REGARD TO PERFORMANCE, MERCHANTABILITY, SATISFACTORY QUALITY, SECURITY OR PRIVACY OF INFORMATION TRANSMITTED TO AND FROM THE BETA SERVICES, AVAILABILITY OF THE BETA SERVICES, NONINFRINGEMENT OR FITNESS FOR ANY PARTICULAR PURPOSE. IN NO EVENT WILL NEW RELIC BE LIABLE TO YOU OR ANY OTHER PARTY FOR ANY DAMAGES, INCLUDING ANY LOST PROFITS, LOST SAVINGS OR OTHER INCIDENTAL OR CONSEQUENTIAL DAMAGES EVEN IF NEW RELIC OR ANY COMPANY REPRESENTATIVE HAS BEEN ADVISED OF THE POSSIBILITY OF SUCH DAMAGES. YOU BEAR THE ENTIRE RISK AS TO THE QUALITY AND PERFORMANCE OF THE BETA SERVICES, SOFTWARE AND THE CONFIDENTIAL INFORMATION. New Relic makes no warranty that the Beta Services, the Software or Confidential Information will meet your requirements or be uninterrupted, timely, secure or error-free. New Relic makes no warranty that results obtained from your use of the Beta Services, the Software or the Confidential Information will be accurate or reliable or that any errors in the Beta Services, the Software or the Confidential Information will be corrected. New Relic will have no responsibility for any harm to your computer system, loss or corruption of data, or other harm that results from your access to or use of the Beta Services, the Software or the Confidential Information. No advice or information, whether oral or written, obtained by you in connection with your use of the Beta Services, the Software or the Confidential Information shall create any warranty not expressly stated in these Terms. The foregoing exclusions and limitations shall apply to the maximum extent permitted by applicable law, even if any remedy fails its essential purpose

7. Your Obligation to Return Information. New Relic shall retain all right, title and interest in the Beta Services (including the Software) and any associated documents and Confidential Information. You shall return the Confidential Information, the Software and any additional materials to New Relic promptly at New Relic’s request, together with any copies. You agree to destroy all versions of the Confidential Information no later than thirty (30) days after New Relic’s first commercial release of the service that is referred to herein as the Beta Services or at New Relic’s written request. You agree to destroy all Confidential Information immediately upon termination of this Agreement for any reason.

8. Export Restrictions. You acknowledge that the Software licensed hereunder is subject to the export control laws and regulations of the U.S.A. and other countries. You agree that you will not export or re-export the Software, any part thereof, or any process or service that is the direct product of the Software to any country, person or entity subject to U.S. export restrictions

9. Term and Termination. This Agreement shall commence upon the Effective Date and continue during the Testing Period, unless terminated as set forth in this Section. Either Party may terminate this Agreement without cause upon fifteen (15) days prior written notice to the other Party. Finally, New Relic may terminate this Agreement immediately upon written notice if you fail to comply with any term of this Agreement.

10. General. This Agreement will be governed by and construed in accordance with the substantive laws in force in the State of California. The respective state or federal courts located in San Francisco County, California shall have non-exclusive jurisdiction over all disputes relating to this Agreement. You also agree that the Beta Services, Software and Confidential Information will not be rented, leased, sold, sublicensed, assigned or otherwise transferred. You will not assign or transfer any rights or obligations under this Agreement without the prior written consent of New Relic and any such attempted assignment or transfer will be null and void. Sections 1, 2.3, 3, 5, 6, 7 and 10 shall survive any termination or expiration of this Agreement. This Agreement may only be modified by a writing signed by both you and New Relic . This Agreement (along with accompanying exhibits, if any) is the entire agreement between the Parties concerning the Beta Services, Software and related Confidential Information. It supersedes, and its terms govern, all prior proposals, agreements, or other communications between the parties, oral or written, regarding such subject matter. All notices or reports permitted or required under this Agreement shall be in writing and shall be by personal delivery, facsimile transmission or by certified or registered mail, return receipt requested, and shall be deemed given upon personal delivery to the appropriate address, upon acknowledgment of receipt of electronic transmission, or if sent by certified or registered mail, three (3) days after the date of mailing. If notice is sent to New Relic, it shall be sent to New Relic Inc., 188 Spear Street, Suite 1200, ATTN: General Counsel, San Francisco, CA 95105, USA

If you need additional help, get support at support.newrelic.com  .

