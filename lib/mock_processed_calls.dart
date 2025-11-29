/// Mock processed call recordings for demo/hackathon purposes
/// This file represents fully processed call recordings as they would appear in ObjectBox
/// Each call has: transcript, summary, notes (extracted entities), and placeholder for embeddings
///
/// IMPORTANT: IDs start at 9000 to avoid conflicts with real data (which uses auto-increment starting from 1)
/// When inserting into ObjectBox, set id = 0 to let ObjectBox auto-assign IDs, or use a high range like 9000+
///
/// Usage: Load this data into ObjectBox on first app launch to demonstrate functionality

var mockProcessedCalls = [
  {
    "id": 0, // ObjectBox will auto-assign ID
    "fileName": "call_contractor_mike.m4a",
    "filePath": "/mock/audio/call_contractor_mike.m4a",
    "dateReceived": "2025-11-20T10:15:00.000",
    "size": 1234567,
    "callLogName": "Mike (Contractor)",
    "callLogNumber": "+1-555-019-2834",
    "callLogTimestamp": 1732097700000,
    "callLogDuration": 165,
    "callLogType": "incoming",
    "contactDisplayName": "Mike Henderson",
    "contactPhoneNumber": "+1-555-019-2834",
    "isSummarized": true,
    "isVectorized": true,
    "transcription": {
      "fullText":
          "Hey, it's Mike. Look, I'm standing here at the downtown renovation site, and we've hit a bit of a snag with the electrical. I know, I know, we said we'd be done with the wiring by yesterday, but when we opened up the wall in the main conference room, the old wiring... it's a mess. It's not up to code. Honestly, I'm surprised this place didn't burn down ten years ago. \n\nSo, here is the situation. To fix this properly and get it past the city inspector, we need to rip out the sub-panel. I ran the numbers this morning. It's going to cost an extra... let me check my notes here... yeah, roughly four thousand two hundred dollars. That's \$4,200 for parts and labor. I know that eats into the contingency budget, but we don't really have a choice if you want to keep the Certificate of Occupancy. \n\nAlso, regarding the flooring delivery, the supplier called. The oak planks are delayed. They are saying they won't be here until next Tuesday. That pushes our finish date back by about two days. If we want to speed that up, we could switch to the laminate option we discussed last week, but I remember you saying you really wanted the real wood look. \n\nAnyway, I need you to approve that electrical cost ASAP so I can order the breaker panel today. Can you email me a confirmation at mike@buildfast-solutions.com? Just put 'Change Order #992' in the subject line so my office manager sees it. Give me a call back when you get this. Thanks.",
    },
    "summary":
        "Mike reported electrical issues at the downtown renovation site requiring a \$4,200 fix to meet code compliance. Oak flooring delivery delayed to next Tuesday, pushing finish date back 2 days. Needs email approval for Change Order #992 sent to mike@buildfast-solutions.com.",
    "notes": {
      "phones": [],
      "emails": [
        {
          "value": "mike@buildfast-solutions.com",
          "context": "Send Change Order #992 approval"
        }
      ],
      "websites": [],
      "places": [
        {"value": "downtown renovation site", "context": "Electrical issues found"},
        {"value": "main conference room", "context": "Old wiring not up to code"}
      ],
      "dates": [
        {"value": "next Tuesday", "context": "Oak flooring delivery (delayed)"}
      ],
      "money": [
        {"value": "\$4,200", "context": "Electrical repair - parts and labor"}
      ],
      "non_english_words": [],
      "people": [
        {"value": "Mike", "context": "Contractor"},
        {"value": "city inspector", "context": "Must approve electrical work"},
        {"value": "office manager", "context": "Handles change orders"}
      ],
      "other_notes": [
        {
          "value": "Change Order #992",
          "context": "Subject line for email approval"
        },
        {
          "value": "Certificate of Occupancy",
          "context": "Required for completion"
        },
        {
          "value": "Oak planks vs laminate",
          "context": "Flooring decision pending"
        },
        {"value": "Finish date", "context": "Pushed back 2 days"}
      ],
    },
    "embeddings": null, // Will be generated later
  },
  {
    "id": 0,
    "fileName": "call_sister_lisa_dad_update.m4a",
    "filePath": "/mock/audio/call_sister_lisa_dad_update.m4a",
    "dateReceived": "2025-11-22T19:45:00.000",
    "size": 2134567,
    "callLogName": "Lisa",
    "callLogNumber": "+1-555-098-7654",
    "callLogTimestamp": 1732304700000,
    "callLogDuration": 195,
    "callLogType": "incoming",
    "contactDisplayName": "Lisa (Sister)",
    "contactPhoneNumber": "+1-555-098-7654",
    "isSummarized": true,
    "isVectorized": true,
    "transcription": {
      "fullText":
          "Hey... hey, pick up, pick up. Okay, you're not there. It's Lisa. I'm just calling to update you about Dad. We just got back from the City General Hospital. I know you were freaking out all day waiting for the test results, so I didn't want to make you wait. The doctor came in about an hour ago. He said the scans looked surprisingly clear. It's not what they thought it was. It's basically just a severe infection, which is why his fever was spiking so high last night. They started him on some heavy-duty antibiotics through the IV, and he's already looking a bit better. He's actually complaining about the hospital food, which is usually a good sign, right? \n\nSo, yeah, you can breathe now. He probably has to stay for observation for another two days, maybe three, just to make sure his white blood cell count goes down. But they said he should be home by the weekend. \n\nOh, also, while I have you... totally different topic. Did you end up booking the Airbnb for Sara's wedding in July? I saw the prices are going up like crazy. Mom keeps asking if we are all staying in the same house or if she needs to book a hotel room. I told her to wait until I talked to you. Can you check if that place near the lake is still available? The one with the big deck? Let me know tonight if you can, so I can tell Mom tomorrow. Okay? Call me back. Love you.",
    },
    "summary":
        "Lisa updated that Dad's test results from City General Hospital are clear - just a severe infection, not the feared diagnosis. He's on IV antibiotics and recovering well, expected home by the weekend. Also asked about booking the lake house Airbnb for Sara's wedding in July.",
    "notes": {
      "phones": [],
      "emails": [],
      "websites": [],
      "places": [
        {"value": "City General Hospital", "context": "Dad's location"},
        {
          "value": "lake house Airbnb",
          "context": "Check availability for Sara's wedding"
        }
      ],
      "dates": [
        {"value": "weekend", "context": "Dad's expected discharge date"},
        {"value": "July", "context": "Sara's wedding month"},
        {"value": "tonight", "context": "Check Airbnb availability deadline"},
        {"value": "tomorrow", "context": "Tell Mom about accommodation plans"}
      ],
      "money": [],
      "non_english_words": [],
      "people": [
        {"value": "Lisa", "context": "Sister - calling with Dad's update"},
        {"value": "Dad", "context": "Patient - severe infection, recovering"},
        {"value": "Sara", "context": "Wedding in July"},
        {"value": "Mom", "context": "Needs accommodation info"}
      ],
      "other_notes": [
        {"value": "Severe infection", "context": "Not the feared diagnosis"},
        {"value": "IV antibiotics", "context": "Treatment started"},
        {
          "value": "White blood cell count",
          "context": "Monitoring for improvement"
        },
        {
          "value": "Airbnb with big deck",
          "context": "Preferred accommodation option"
        }
      ],
    },
    "embeddings": null,
  },
  {
    "id": 0,
    "fileName": "call_dev_lead_outage.m4a",
    "filePath": "/mock/audio/call_dev_lead_outage.m4a",
    "dateReceived": "2025-11-21T11:00:00.000",
    "size": 1834567,
    "callLogName": "Alex",
    "callLogNumber": "+1-555-014-8822",
    "callLogTimestamp": 1732187400000,
    "callLogDuration": 210,
    "callLogType": "outgoing",
    "contactDisplayName": "Alex (Dev Lead)",
    "contactPhoneNumber": "+1-555-014-8822",
    "isSummarized": true,
    "isVectorized": true,
    "transcription": {
      "fullText":
          "Alex? Can you hear me? \n\nYeah, I can hear you. Is this about the outage? \n\nYes! The dashboard is lighting up red. Users are reporting 500 errors on the login screen. What is going on? We deployed v2.4 last night, right? \n\nCorrect. We pushed v2.4 to production at midnight. It looked stable in staging. But it looks like the new Auth Token service is timing out when the load gets above 1,000 requests. It's an AWS configuration issue, not the code itself. \n\nOkay, well, we can't wait for a fix. We have the investor demo in two hours. Alex, I need you to make a call. Do we patch it or do we rollback? \n\nHonestly? Patching might take an hour to propagate. It's too risky. \n\nAlright, let's rollback. \n\nOkay, I'm initiating the rollback to v2.3 now. Give me... maybe 15 minutes for the servers to restart. \n\nFine. 15 minutes. Text me the second it's green. And Alex? Let's not deploy on Thursdays anymore, okay? \n\nUnderstood. Rolling back now.",
    },
    "summary":
        "Urgent discussion about production outage causing 500 errors on login. v2.4 deployment caused Auth Token service timeouts at high load (1000+ requests). Decision made to rollback to v2.3 before investor demo. Rollback estimated 15 minutes. Agreed to avoid Thursday deployments.",
    "notes": {
      "phones": [],
      "emails": [],
      "websites": [],
      "places": [
        {"value": "AWS", "context": "Configuration issue location"},
        {"value": "production", "context": "Experiencing outage"},
        {"value": "staging", "context": "v2.4 looked stable here"}
      ],
      "dates": [
        {"value": "last night", "context": "v2.4 deployment time"},
        {"value": "midnight", "context": "Deployment to production"},
        {"value": "two hours", "context": "Time until investor demo"},
        {"value": "15 minutes", "context": "Rollback duration estimate"},
        {"value": "Thursdays", "context": "No more deployments on this day"}
      ],
      "money": [],
      "non_english_words": [],
      "people": [
        {"value": "Alex", "context": "Dev Lead - executing rollback"},
        {"value": "users", "context": "Reporting 500 errors"},
        {"value": "investors", "context": "Demo scheduled in 2 hours"}
      ],
      "other_notes": [
        {"value": "500 errors", "context": "Login screen failures"},
        {"value": "v2.4 deployment", "context": "Caused the outage"},
        {"value": "v2.3 rollback", "context": "Stable version to restore"},
        {
          "value": "Auth Token timeout",
          "context": "Root cause at 1000+ requests"
        },
        {"value": "Investor demo", "context": "Critical deadline"}
      ],
    },
    "embeddings": null,
  },
  {
    "id": 0,
    "fileName": "call_cloudhost_sales.m4a",
    "filePath": "/mock/audio/call_cloudhost_sales.m4a",
    "dateReceived": "2025-11-25T15:00:00.000",
    "size": 1434567,
    "callLogName": "CloudHost",
    "callLogNumber": "+1-800-555-0100",
    "callLogTimestamp": 1732546800000,
    "callLogDuration": 145,
    "callLogType": "incoming",
    "contactDisplayName": "Sam (CloudHost Sales)",
    "contactPhoneNumber": "+1-800-555-0100",
    "isSummarized": true,
    "isVectorized": true,
    "transcription": {
      "fullText":
          "Hi, is this the decision maker for the account? This is Sam from CloudHost. \n\nYes, speaking. What's this about? \n\nI'm calling because your team is hitting 90% of your storage limit on the Pro plan. I wanted to see if you'd be open to upgrading to the Enterprise Tier today. It comes with unlimited bandwidth and 24/7 support. \n\nLook, Sam, I saw the pricing page. It's ten thousand a year. We can't justify that jump right now. We just had a rollback incident yesterday, money is tight. \n\nI understand. But if you hit the limit, your users will see errors. Tell you what—since it's the end of the quarter, if you can sign by Friday, I can discount the Enterprise plan down to eight thousand flat. \n\nEight thousand is still high. Throw in the extended security package, and give me Net-60 payment terms instead of Net-30. Cash flow is tricky this month. \n\nNet-60... let me check with my manager. \n\n(Pause) \n\nOkay, he gave me the thumbs up. \$8,000 annual, Net-60 terms, includes Security Plus. Deal? \n\nDeal. Send the contract to my email. \n\nSending it now.",
    },
    "summary":
        "Negotiated CloudHost upgrade from Pro to Enterprise tier. Started at \$10k/year, negotiated down to \$8k/year with Security Plus addon and Net-60 payment terms (instead of Net-30). Deal closed, contract being sent via email. Reason: hitting 90% storage limit.",
    "notes": {
      "phones": [],
      "emails": [],
      "websites": [],
      "places": [],
      "dates": [
        {"value": "Friday", "context": "Contract signing deadline"},
        {"value": "end of the quarter", "context": "Reason for discount"},
        {"value": "this month", "context": "Cash flow constraints"}
      ],
      "money": [
        {"value": "\$10,000", "context": "Initial Enterprise price"},
        {"value": "\$8,000", "context": "Negotiated annual price"}
      ],
      "non_english_words": [],
      "people": [
        {"value": "Sam", "context": "CloudHost sales rep"},
        {"value": "manager", "context": "Approved Net-60 terms"}
      ],
      "other_notes": [
        {
          "value": "CloudHost Enterprise",
          "context": "Upgrade from Pro tier"
        },
        {"value": "90% storage limit", "context": "Reason for upgrade"},
        {"value": "Net-60 payment terms", "context": "Better cash flow"},
        {"value": "Security Plus", "context": "Addon included in deal"},
        {"value": "Unlimited bandwidth", "context": "Enterprise benefit"},
        {"value": "24/7 support", "context": "Enterprise benefit"}
      ],
    },
    "embeddings": null,
  },
  {
    "id": 0,
    "fileName": "call_scam_amazon.m4a",
    "filePath": "/mock/audio/call_scam_amazon.m4a",
    "dateReceived": "2025-11-28T09:10:00.000",
    "size": 934567,
    "callLogName": null,
    "callLogNumber": "+1-800-000-0000",
    "callLogTimestamp": 1732788600000,
    "callLogDuration": 95,
    "callLogType": "incoming",
    "contactDisplayName": null,
    "contactPhoneNumber": null,
    "isSummarized": true,
    "isVectorized": true,
    "transcription": {
      "fullText":
          "Hello? \n\nYes, hello sir. This is the Amazon Fraud Department. We are calling to verify a transaction of nine hundred and ninety-nine dollars for an iPhone 16 Pro Max. Did you make this purchase? \n\nWhat? No. I didn't buy an iPhone. \n\nOkay, that is what we suspected. It looks like your account has been compromised by hackers in... uh... Russia. We need to secure your refund immediately. Sir, are you near your computer? \n\nYeah, I'm at my desk. \n\nOkay, to stop the hackers, you need to download a support tool called 'AnyDesk'. Go to the website and read me the 9-digit code. We will connect to your bank to secure the funds. \n\nWait, why do you need to connect to my computer? Can't you just cancel the order? \n\nSir, listen to me. The hackers are draining your funds right now. If you don't do this, you lose the money. Do you want to lose the money? \n\nYou know what? I'm calling Amazon directly through the app. \n\nNo, sir! Do not hang up! If you hang up the refund is canc-- (Call Ended)",
    },
    "summary":
        "⚠️ SCAM DETECTED: Fake Amazon Fraud Department call attempting refund scam. Caller claimed fraudulent \$999 iPhone purchase and tried to coerce installation of 'AnyDesk' remote access software. Classic tech support scam pattern. Call terminated by user.",
    "notes": {
      "phones": [],
      "emails": [],
      "websites": [],
      "places": [
        {"value": "Russia", "context": "Claimed location of hackers"}
      ],
      "dates": [],
      "money": [
        {"value": "\$999", "context": "Fake iPhone 16 Pro Max charge"}
      ],
      "non_english_words": [],
      "people": [
        {"value": "hackers", "context": "Claimed to be draining funds"}
      ],
      "other_notes": [
        {
          "value": "⚠️ SCAM DETECTED",
          "context": "Amazon Fraud Department impersonation"
        },
        {
          "value": "AnyDesk",
          "context": "Remote access tool - RED FLAG"
        },
        {"value": "iPhone 16 Pro Max", "context": "Fake purchase claim"},
        {"value": "Refund scam", "context": "Social engineering tactic"},
        {"value": "THREAT LEVEL: CRITICAL", "context": "Do not engage"}
      ],
    },
    "embeddings": null,
  },
  {
    "id": 0,
    "fileName": "call_doctor_referral.m4a",
    "filePath": "/mock/audio/call_doctor_referral.m4a",
    "dateReceived": "2025-11-22T14:30:00.000",
    "size": 734567,
    "callLogName": "Dr. Martinez",
    "callLogNumber": "+1-555-033-7788",
    "callLogTimestamp": 1732289400000,
    "callLogDuration": 75,
    "callLogType": "incoming",
    "contactDisplayName": "Dr. Martinez",
    "contactPhoneNumber": "+1-555-033-7788",
    "isSummarized": true,
    "isVectorized": true,
    "transcription": {
      "fullText":
          "Hi, this is Dr. Martinez returning your call. I reviewed the X-rays your primary care sent over. I'd like to schedule you for a consultation next week. When you call my office to book, ask for Janet. Her direct line is... let me give you the number. It's area code 555, then 876-3401. Again, that's 555-876-3401. Make sure you mention that I referred you, otherwise they'll put you on the general waitlist which is backed up for three weeks. Oh, and bring your insurance card and a photo ID. See you soon.",
    },
    "summary":
        "Dr. Martinez reviewed X-rays and wants to schedule a consultation next week. Provided Janet's direct office line (555-876-3401) to book appointment. Important to mention referral to skip 3-week general waitlist. Need to bring insurance card and photo ID.",
    "notes": {
      "phones": [
        {
          "value": "555-876-3401",
          "context": "Janet's direct line - mention Dr. Martinez referral"
        }
      ],
      "emails": [],
      "websites": [],
      "places": [
        {"value": "doctor's office", "context": "Consultation location"}
      ],
      "dates": [
        {"value": "next week", "context": "Consultation timeframe"}
      ],
      "money": [],
      "non_english_words": [],
      "people": [
        {"value": "Dr. Martinez", "context": "Referring doctor"},
        {"value": "Janet", "context": "Office scheduler"},
        {"value": "primary care doctor", "context": "Sent X-rays"}
      ],
      "other_notes": [
        {"value": "X-ray review", "context": "Completed by Dr. Martinez"},
        {"value": "Mention referral", "context": "Skip 3-week waitlist"},
        {"value": "Insurance card", "context": "Required for appointment"},
        {"value": "Photo ID", "context": "Required for appointment"}
      ],
    },
    "embeddings": null,
  },
  {
    "id": 0,
    "fileName": "call_real_estate_rachel.m4a",
    "filePath": "/mock/audio/call_real_estate_rachel.m4a",
    "dateReceived": "2025-11-23T16:45:00.000",
    "size": 934567,
    "callLogName": "Rachel",
    "callLogNumber": "+1-555-091-2233",
    "callLogTimestamp": 1732384500000,
    "callLogDuration": 95,
    "callLogType": "incoming",
    "contactDisplayName": "Rachel (Skyline Realty)",
    "contactPhoneNumber": "+1-555-091-2233",
    "isSummarized": true,
    "isVectorized": true,
    "transcription": {
      "fullText":
          "Hey! Rachel here from Skyline Realty. Great news—I found three properties that match your criteria. I'm sending you the listing links via email, but I really think you should see the condo on Pine Street ASAP. It's listed at four hundred and twenty-five thousand, but the seller is motivated. Here's what I need you to do. Call the building manager directly to schedule a private showing before the open house this weekend. His name is Robert Chen. Write this down: 415-298-7654. That's 415-298-7654. Tell him Rachel sent you. He owes me a favor, so he'll prioritize you. Can you call him today? The property won't last.",
    },
    "summary":
        "Rachel found 3 matching properties, highlighting Pine Street condo at \$425k with motivated seller. Provided building manager Robert Chen's direct number (415-298-7654) to schedule private showing before weekend open house. Urgent - property likely to sell quickly.",
    "notes": {
      "phones": [
        {
          "value": "415-298-7654",
          "context": "Robert Chen (building manager) - say Rachel sent you"
        }
      ],
      "emails": [],
      "websites": [],
      "places": [
        {"value": "Pine Street condo", "context": "Top property recommendation"}
      ],
      "dates": [
        {"value": "this weekend", "context": "Open house scheduled"},
        {"value": "today", "context": "Call Robert for private showing"}
      ],
      "money": [
        {"value": "\$425,000", "context": "List price - seller motivated"}
      ],
      "non_english_words": [],
      "people": [
        {"value": "Rachel", "context": "Skyline Realty agent"},
        {"value": "Robert Chen", "context": "Building manager - owes Rachel favor"},
        {"value": "seller", "context": "Motivated to close"}
      ],
      "other_notes": [
        {"value": "3 properties found", "context": "Matching search criteria"},
        {
          "value": "Private showing",
          "context": "Before open house - priority access"
        },
        {"value": "Motivated seller", "context": "Potential for negotiation"}
      ],
    },
    "embeddings": null,
  },
  {
    "id": 0,
    "fileName": "call_legal_contact_tom.m4a",
    "filePath": "/mock/audio/call_legal_contact_tom.m4a",
    "dateReceived": "2025-11-25T11:20:00.000",
    "size": 1134567,
    "callLogName": "Tom",
    "callLogNumber": "+1-555-044-9988",
    "callLogTimestamp": 1732533600000,
    "callLogDuration": 120,
    "callLogType": "outgoing",
    "contactDisplayName": "Tom (Client)",
    "contactPhoneNumber": "+1-555-044-9988",
    "isSummarized": true,
    "isVectorized": true,
    "transcription": {
      "fullText":
          "Tom, hey, it's John. Listen, I know you've been trying to get ahold of the legal team about the contract amendments. They've been swamped, but I got you a shortcut. My contact there is Elizabeth Warner. She handles commercial agreements. \n\nOkay, what's her number? \n\nAlright, she's got two lines. Her office landline is 202-555-1823. But honestly, she never picks that up. If you want to actually reach her, text her mobile. It's 202-779-4456. Let me repeat that. 202-779-4456. \n\nGot it. 202-779-4456. \n\nYeah. And when you text her, start with 'John from Project Alpha referred me' so she knows you're legit. She gets bombarded with spam, so otherwise she'll ignore it. \n\nPerfect. I'll text her this afternoon. Thanks for the connect, man. \n\nNo problem. Let me know how it goes.",
    },
    "summary":
        "John connected Tom with legal team contact Elizabeth Warner for contract amendments. Office line: 202-555-1823 (rarely answered). Preferred contact: text mobile at 202-779-4456 with introduction 'John from Project Alpha referred me' to avoid being ignored as spam.",
    "notes": {
      "phones": [
        {"value": "202-555-1823", "context": "Elizabeth Warner office - rarely picks up"},
        {
          "value": "202-779-4456",
          "context": "Elizabeth mobile - TEXT 'John from Project Alpha referred me'"
        }
      ],
      "emails": [],
      "websites": [],
      "places": [],
      "dates": [
        {"value": "this afternoon", "context": "When to text Elizabeth"}
      ],
      "money": [],
      "non_english_words": [],
      "people": [
        {"value": "Tom", "context": "Needs legal contact"},
        {"value": "John", "context": "Making the introduction"},
        {
          "value": "Elizabeth Warner",
          "context": "Legal - handles commercial agreements"
        }
      ],
      "other_notes": [
        {"value": "Contract amendments", "context": "Purpose of contact"},
        {"value": "Project Alpha", "context": "Include in text introduction"},
        {"value": "Text preferred", "context": "Gets too much spam on mobile"}
      ],
    },
    "embeddings": null,
  },
  {
    "id": 0,
    "fileName": "call_conference_followup.m4a",
    "filePath": "/mock/audio/call_conference_followup.m4a",
    "dateReceived": "2025-11-26T10:00:00.000",
    "size": 834567,
    "callLogName": null,
    "callLogNumber": "+1-555-077-3322",
    "callLogTimestamp": 1732615200000,
    "callLogDuration": 85,
    "callLogType": "incoming",
    "contactDisplayName": null,
    "contactPhoneNumber": null,
    "isSummarized": true,
    "isVectorized": true,
    "transcription": {
      "fullText":
          "Hey, sorry I missed you at the conference yesterday. I wanted to follow up on the API integration we discussed. I think our platforms could work really well together. \n\nYeah, definitely interested. What's the next step? \n\nLet's set up a technical deep-dive call next week. I'll have my CTO join. Can you send me an email with your availability? My work email is james.patterson@techflow.io. That's J-A-M-E-S dot P-A-T-T-E-R-S-O-N at techflow dot I-O. \n\nGot it. \n\nOh, and if you want to reach me directly, my cell is 650-443-8821. I'm on Pacific Time, so avoid calling before 9 AM. Text is fine anytime though. \n\nPerfect. I'll send that email today. \n\nAwesome. Looking forward to it.",
    },
    "summary":
        "Follow-up from conference about API integration partnership. James Patterson requested email with availability for technical deep-dive call with CTO next week. Contact: james.patterson@techflow.io (email preferred) or 650-443-8821 (mobile, Pacific Time, no calls before 9 AM).",
    "notes": {
      "phones": [
        {
          "value": "650-443-8821",
          "context": "James mobile - Pacific Time, NO calls before 9 AM, text OK"
        }
      ],
      "emails": [
        {
          "value": "james.patterson@techflow.io",
          "context": "Send availability for tech call - PREFERRED contact"
        }
      ],
      "websites": [
        {"value": "techflow.io", "context": "James's company"}
      ],
      "places": [],
      "dates": [
        {"value": "yesterday", "context": "Met at conference"},
        {"value": "next week", "context": "Schedule tech deep-dive call"},
        {"value": "today", "context": "Send availability email"},
        {"value": "9 AM", "context": "Don't call before (Pacific Time)"}
      ],
      "money": [],
      "non_english_words": [],
      "people": [
        {"value": "James Patterson", "context": "API integration contact"},
        {"value": "CTO", "context": "Will join technical call"}
      ],
      "other_notes": [
        {"value": "API integration", "context": "Platform partnership discussion"},
        {"value": "Technical deep-dive", "context": "Next step with CTO"},
        {"value": "Pacific Time", "context": "James's timezone"}
      ],
    },
    "embeddings": null,
  },
  {
    "id": 0,
    "fileName": "call_keynote_speaker_alice.m4a",
    "filePath": "/mock/audio/call_keynote_speaker_alice.m4a",
    "dateReceived": "2025-11-23T10:00:00.000",
    "size": 534567,
    "callLogName": "Alice",
    "callLogNumber": "+1-555-099-8877",
    "callLogTimestamp": 1732356000000,
    "callLogDuration": 55,
    "callLogType": "incoming",
    "contactDisplayName": "Alice (Keynote)",
    "contactPhoneNumber": "+1-555-099-8877",
    "isSummarized": true,
    "isVectorized": true,
    "transcription": {
      "fullText":
          "Hey! It's Alice. I finally got the invite link you sent, thanks. I just booked my travel for the TechMeet. I'm flying in on Delta flight DL-492. It lands next Thursday at 2:15 PM at Terminal 4. I'll just Uber to the venue, so don't worry about picking me up. \n\nOne quick thing for the dinner—I actually switched to a Vegan diet recently, so please make sure there's a meal option for me. Also, for my presentation, I'm bringing my MacBook. Does the stage have a USB-C adapter, or should I bring my own HDMI dongle? Let me know. See you soon!",
    },
    "summary":
        "Alice confirmed TechMeet attendance. Arriving on Delta DL-492 next Thursday at 2:15 PM (Terminal 4), will Uber to venue. Dietary requirement: Vegan meal needed for dinner. Tech question: Does stage have USB-C adapter or should she bring HDMI dongle?",
    "notes": {
      "phones": [],
      "emails": [],
      "websites": [],
      "places": [
        {"value": "Terminal 4", "context": "Flight arrival terminal"},
        {"value": "venue", "context": "Taking Uber - no pickup needed"}
      ],
      "dates": [
        {"value": "next Thursday", "context": "Arrival day"},
        {"value": "2:15 PM", "context": "Flight landing time"}
      ],
      "money": [],
      "non_english_words": [],
      "people": [
        {"value": "Alice", "context": "Keynote speaker"}
      ],
      "other_notes": [
        {"value": "Delta DL-492", "context": "Flight number"},
        {"value": "Vegan meal", "context": "Required for dinner event"},
        {
          "value": "USB-C adapter",
          "context": "Does stage have one? MacBook presentation"
        },
        {"value": "HDMI dongle", "context": "Backup if no USB-C"},
        {"value": "No pickup needed", "context": "Taking Uber"}
      ],
    },
    "embeddings": null,
  },
  {
    "id": 0,
    "fileName": "call_landlord_lease.m4a",
    "filePath": "/mock/audio/call_landlord_lease.m4a",
    "dateReceived": "2025-11-20T17:45:00.000",
    "size": 1334567,
    "callLogName": "Mark",
    "callLogNumber": "+1-555-022-3344",
    "callLogTimestamp": 1732124100000,
    "callLogDuration": 135,
    "callLogType": "incoming",
    "contactDisplayName": "Mark (Landlord)",
    "contactPhoneNumber": "+1-555-022-3344",
    "isSummarized": true,
    "isVectorized": true,
    "transcription": {
      "fullText":
          "Hi, it's Mark. Do you have a minute? \n\nYeah, hi Mark. What's up? \n\nI'm calling about the lease renewal for next year. I sent the docusign over email, but I haven't seen it signed yet. Just wanted to let you know that the rent is going to go up slightly starting February 1st. It'll be two thousand one hundred a month. \n\nTwo thousand one hundred? That's a hundred dollar jump. Mark, honestly, I'm hesitant to sign because the A/C unit in the master bedroom has been making that rattling noise for three months. You said you'd fix it in October. \n\nI know, I know. It's been hard to get a contractor out there. Tell you what—if you sign the renewal by this weekend, I will have the HVAC guy there this Thursday. \n\nThis Thursday? What time? I have work. \n\nHe has a slot at 2:00 PM. Can you be home? \n\nI can make 2:00 PM work if it's guaranteed fixed. \n\nIt's guaranteed. I'll text you his name. So we are good on the \$2,100? \n\nFine. I'll sign it tonight.",
    },
    "summary":
        "Lease renewal discussion with landlord Mark. Rent increasing from \$2,000 to \$2,100/month starting February 1st. Negotiated A/C repair (rattling noise issue for 3 months) as condition for signing. HVAC maintenance scheduled for Thursday at 2:00 PM. Agreed to sign lease tonight.",
    "notes": {
      "phones": [],
      "emails": [],
      "websites": [],
      "places": [
        {"value": "master bedroom", "context": "A/C unit location - rattling"}
      ],
      "dates": [
        {"value": "February 1st", "context": "New rent starts"},
        {"value": "this weekend", "context": "Sign renewal deadline"},
        {"value": "this Thursday", "context": "HVAC repair scheduled"},
        {"value": "2:00 PM", "context": "HVAC appointment time"},
        {"value": "tonight", "context": "Sign DocuSign"},
        {"value": "October", "context": "When Mark promised to fix A/C"}
      ],
      "money": [
        {"value": "\$2,100", "context": "New monthly rent"},
        {"value": "\$100", "context": "Rent increase amount"}
      ],
      "non_english_words": [],
      "people": [
        {"value": "Mark", "context": "Landlord"},
        {"value": "HVAC guy", "context": "Coming Thursday at 2 PM"},
        {"value": "contractor", "context": "Hard to schedule"}
      ],
      "other_notes": [
        {"value": "A/C rattling", "context": "3 months unresolved - fixed Thu"},
        {"value": "DocuSign", "context": "Sign tonight after confirmation"},
        {"value": "Repair guaranteed", "context": "Condition for signing lease"}
      ],
    },
    "embeddings": null,
  },
  {
    "id": 0,
    "fileName": "call_hiring_david.m4a",
    "filePath": "/mock/audio/call_hiring_david.m4a",
    "dateReceived": "2025-11-26T14:00:00.000",
    "size": 2034567,
    "callLogName": "David",
    "callLogNumber": "+1-415-555-0921",
    "callLogTimestamp": 1732629600000,
    "callLogDuration": 210,
    "callLogType": "outgoing",
    "contactDisplayName": "David (Candidate)",
    "contactPhoneNumber": "+1-415-555-0921",
    "isSummarized": true,
    "isVectorized": true,
    "transcription": {
      "fullText":
          "Hi David, thanks for picking up. I know this is last minute, but I saw your resume and wanted to do a quick phone screen before we schedule the technical panel. Do you have ten minutes? \n\nYeah, absolutely. Thanks for reaching out. \n\nGreat. So, I see here you spent three years at FinTechCorp. What was your main focus there? \n\nMostly backend architecture. I migrated our legacy monolith to microservices using Go and Kubernetes. We were handling about 50,000 requests per second. \n\nInteresting. We actually just had an issue with our Auth service timing out on AWS. Do you have experience with high-load scaling on AWS? \n\nYeah, definitely. At my last job, we used Redis caching layers to prevent exactly that kind of timeout. I'm AWS certified, actually. \n\nOkay, that is exactly what we need right now. We are a startup, so things move fast. Are you comfortable with that? \n\nI prefer it. Big corps move too slow. \n\nCool. And just to respect everyone's time—what are you looking for regarding compensation? \n\nI'm targeting around one-fifty base, plus equity. \n\n\$150k is within our band for a Senior role. Okay, David, I like your background. I'm going to pass you to Alex, my Lead Dev, for a code test. Look out for an invite tomorrow. \n\nSounds great, thanks John.",
    },
    "summary":
        "Strong phone screen with backend engineer candidate David. 3 years at FinTechCorp, migrated monolith to microservices (Go/Kubernetes), handled 50k RPS. Highly relevant: AWS certified with Redis caching experience for Auth timeout issues. Prefers startup pace. Salary expectation: \$150k + equity (within budget for Senior role). Moving to code test with Alex.",
    "notes": {
      "phones": [],
      "emails": [],
      "websites": [],
      "places": [
        {"value": "FinTechCorp", "context": "Previous employer - 3 years"},
        {"value": "AWS", "context": "Certified - Redis caching expert"}
      ],
      "dates": [
        {"value": "tomorrow", "context": "Code test invite from Alex"},
        {"value": "three years", "context": "Experience at FinTechCorp"}
      ],
      "money": [
        {"value": "\$150k", "context": "Base salary + equity - within budget"}
      ],
      "non_english_words": [],
      "people": [
        {"value": "David", "context": "Strong candidate - Senior Backend"},
        {"value": "Alex", "context": "Lead Dev - sending code test"},
        {"value": "John", "context": "Conducting phone screen"}
      ],
      "other_notes": [
        {"value": "Go and Kubernetes", "context": "Microservices migration"},
        {"value": "50,000 RPS", "context": "High-load scaling experience"},
        {
          "value": "Redis caching",
          "context": "Solves our Auth timeout issue"
        },
        {"value": "AWS certified", "context": "Perfect for our stack"},
        {"value": "Prefers startups", "context": "Good culture fit"},
        {"value": "Code test", "context": "Next step with Alex"}
      ],
    },
    "embeddings": null,
  },
];
