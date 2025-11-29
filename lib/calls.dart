/// This is the Mock calls data to show for demo purpose. Since this app is for a Hackathon, to show the apps's functionality in one go.
/// Get relevant data for us, don't take every fields. No audio for demo.
/// One important feature we are going to have, which is not implemented yet is, "Notes" feature, we should that next to summary tab.
/// Notes feature is just how humans takes notes while they are in a call.
/// We initially focus on just 10 fields

var callsData = [
  {
    "id": "call_2025_01",
    "timestamp": "2025-11-20T10:15:00.000",
    "duration_seconds": 165,
    "contact_name": "Mike (Contractor)",
    "phone_number": "+1-555-019-2834",
    "audio_file_path": null,
    "is_snippet": false,
    "transcript":
        "Hey, it's Mike. Look, I'm standing here at the downtown renovation site, and we've hit a bit of a snag with the electrical. I know, I know, we said we'd be done with the wiring by yesterday, but when we opened up the wall in the main conference room, the old wiring... it's a mess. It's not up to code. Honestly, I'm surprised this place didn't burn down ten years ago. \n\nSo, here is the situation. To fix this properly and get it past the city inspector, we need to rip out the sub-panel. I ran the numbers this morning. It's going to cost an extra... let me check my notes here... yeah, roughly four thousand two hundred dollars. That's \$4,200 for parts and labor. I know that eats into the contingency budget, but we don't really have a choice if you want to keep the Certificate of Occupancy. \n\nAlso, regarding the flooring delivery, the supplier called. The oak planks are delayed. They are saying they won't be here until next Tuesday. That pushes our finish date back by about two days. If we want to speed that up, we could switch to the laminate option we discussed last week, but I remember you saying you really wanted the real wood look. \n\nAnyway, I need you to approve that electrical cost ASAP so I can order the breaker panel today. Can you email me a confirmation at mike@buildfast-solutions.com? Just put 'Change Order #992' in the subject line so my office manager sees it. Give me a call back when you get this. Thanks.",
    "ai_metadata": {
      "summary":
          "Mike reported electrical issues at the downtown site requiring a \$4,200 fix. Flooring is delayed to next Tuesday. Needs email approval for Change Order #992.",
      "sentiment": "Urgent / Concerned",
      "entities": [
        {"label": "Money", "value": "\$4,200"},
        {"label": "Deadline", "value": "Next Tuesday"},
        {"label": "Email", "value": "mike@buildfast-solutions.com"},
        {"label": "Reference", "value": "Change Order #992"},
      ],
    },
  },
  {
    "id": "call_2025_02",
    "timestamp": "2025-11-22T19:45:00.000",
    "duration_seconds": 195,
    "contact_name": "Lisa (Sister)",
    "phone_number": "+1-555-098-7654",
    "audio_file_path": null,
    "is_snippet": false,
    "transcript":
        "Hey... hey, pick up, pick up. Okay, you're not there. It's Lisa. I'm just calling to update you about Dad. We just got back from the City General Hospital. I know you were freaking out all day waiting for the test results, so I didn't want to make you wait. The doctor came in about an hour ago. He said the scans looked surprisingly clear. It's not what they thought it was. It's basically just a severe infection, which is why his fever was spiking so high last night. They started him on some heavy-duty antibiotics through the IV, and he's already looking a bit better. He's actually complaining about the hospital food, which is usually a good sign, right? \n\nSo, yeah, you can breathe now. He probably has to stay for observation for another two days, maybe three, just to make sure his white blood cell count goes down. But they said he should be home by the weekend. \n\nOh, also, while I have you... totally different topic. Did you end up booking the Airbnb for Sara's wedding in July? I saw the prices are going up like crazy. Mom keeps asking if we are all staying in the same house or if she needs to book a hotel room. I told her to wait until I talked to you. Can you check if that place near the lake is still available? The one with the big deck? Let me know tonight if you can, so I can tell Mom tomorrow. Okay? Call me back. Love you.",
    "ai_metadata": {
      "summary":
          "Lisa updated that Dad's test results are clear; it's just an infection and he's recovering at City General. He should be discharged by the weekend. Also asked if you booked the lake house Airbnb for Sara's wedding.",
      "sentiment": "Relieved / Hopeful",
      "entities": [
        {"label": "Health Status", "value": "Clear scans / Infection"},
        {"label": "Location", "value": "City General Hospital"},
        {"label": "Event", "value": "Sara's Wedding (July)"},
        {"label": "Task", "value": "Check Airbnb availability"},
      ],
    },
  },
  {
    "id": "call_2025_03",
    "timestamp": "2025-11-21T11:00:00.000",
    "duration_seconds": 210,
    "contact_name": "Alex (Dev Lead)",
    "phone_number": "+1-555-014-8822",
    "audio_file_path": null,
    "is_snippet": false,
    "transcript":
        "Alex? Can you hear me? \n\nYeah, I can hear you. Is this about the outage? \n\nYes! The dashboard is lighting up red. Users are reporting 500 errors on the login screen. What is going on? We deployed v2.4 last night, right? \n\nCorrect. We pushed v2.4 to production at midnight. It looked stable in staging. But it looks like the new Auth Token service is timing out when the load gets above 1,000 requests. It's an AWS configuration issue, not the code itself. \n\nOkay, well, we can't wait for a fix. We have the investor demo in two hours. Alex, I need you to make a call. Do we patch it or do we rollback? \n\nHonestly? Patching might take an hour to propagate. It's too risky. \n\nAlright, let's rollback. \n\nOkay, I'm initiating the rollback to v2.3 now. Give me... maybe 15 minutes for the servers to restart. \n\nFine. 15 minutes. Text me the second it's green. And Alex? Let's not deploy on Thursdays anymore, okay? \n\nUnderstood. Rolling back now.",
    "ai_metadata": {
      "summary":
          "Urgent discussion regarding 500 errors on Login after v2.4 deployment. Alex identified an AWS timeout issue. Decision made to immediately rollback to v2.3 to restore service before the investor demo. Agreed to stop Thursday deployments.",
      "sentiment": "Critical / High Stress",
      "entities": [
        {"label": "Issue", "value": "Error 500 / Auth Timeout"},
        {"label": "Version", "value": "v2.4 (Bad) -> v2.3 (Stable)"},
        {"label": "Platform", "value": "AWS"},
        {"label": "Action", "value": "Rollback in 15 mins"},
      ],
    },
  },
  {
    "id": "call_2025_04",
    "timestamp": "2025-11-25T15:00:00.000",
    "duration_seconds": 145,
    "contact_name": "Sam (CloudHost Sales)",
    "phone_number": "+1-800-555-0100",
    "audio_file_path": null,
    "is_snippet": false,
    "transcript":
        "Hi, is this the decision maker for the account? This is Sam from CloudHost. \n\nYes, speaking. What's this about? \n\nI'm calling because your team is hitting 90% of your storage limit on the Pro plan. I wanted to see if you'd be open to upgrading to the Enterprise Tier today. It comes with unlimited bandwidth and 24/7 support. \n\nLook, Sam, I saw the pricing page. It's ten thousand a year. We can't justify that jump right now. We just had a rollback incident yesterday, money is tight. \n\nI understand. But if you hit the limit, your users will see errors. Tell you what—since it's the end of the quarter, if you can sign by Friday, I can discount the Enterprise plan down to eight thousand flat. \n\nEight thousand is still high. Throw in the extended security package, and give me Net-60 payment terms instead of Net-30. Cash flow is tricky this month. \n\nNet-60... let me check with my manager. \n\n(Pause) \n\nOkay, he gave me the thumbs up. \$8,000 annual, Net-60 terms, includes Security Plus. Deal? \n\nDeal. Send the contract to my email. \n\nSending it now.",
    "ai_metadata": {
      "summary":
          "Negotiated CloudHost upgrade from Pro to Enterprise tier. Sam initially offered \$10k, but agreed to \$8,000/year after pushback. Secured 'Security Plus' addon and Net-60 payment terms. Contract will be sent via email.",
      "sentiment": "Transactional / Professional",
      "entities": [
        {"label": "Product", "value": "CloudHost Enterprise"},
        {"label": "Price", "value": "\$8,000/year (Discounted)"},
        {"label": "Terms", "value": "Net-60"},
        {"label": "Status", "value": "Deal Closed"},
      ],
    },
  },
  {
    "id": "call_2025_05",
    "timestamp": "2025-11-28T09:10:00.000",
    "duration_seconds": 95,
    "contact_name": null,
    "phone_number": "+1-800-000-0000",
    "audio_file_path": null,
    "is_snippet": false,
    "transcript":
        "Hello? \n\nYes, hello sir. This is the Amazon Fraud Department. We are calling to verify a transaction of nine hundred and ninety-nine dollars for an iPhone 16 Pro Max. Did you make this purchase? \n\nWhat? No. I didn't buy an iPhone. \n\nOkay, that is what we suspected. It looks like your account has been compromised by hackers in... uh... Russia. We need to secure your refund immediately. Sir, are you near your computer? \n\nYeah, I'm at my desk. \n\nOkay, to stop the hackers, you need to download a support tool called 'AnyDesk'. Go to the website and read me the 9-digit code. We will connect to your bank to secure the funds. \n\nWait, why do you need to connect to my computer? Can't you just cancel the order? \n\nSir, listen to me. The hackers are draining your funds right now. If you don't do this, you lose the money. Do you want to lose the money? \n\nYou know what? I'm calling Amazon directly through the app. \n\nNo, sir! Do not hang up! If you hang up the refund is canc-- (Call Ended)",
    "ai_metadata": {
      "summary":
          "Detected malicious pattern: 'Refund Scam'. Caller claimed to be Amazon Fraud Dept regarding a fake \$999 iPhone charge. Attempted to coerce user into installing 'AnyDesk' remote access software. User hung up.",
      "sentiment": "Malicious / High Threat",
      "entities": [
        {"label": "Scam Type", "value": "Tech Support / Refund Fraud"},
        {"label": "Trigger Word", "value": "AnyDesk"},
        {"label": "Threat Level", "value": "CRITICAL"},
      ],
      "is_spam": true,
    },
  },
  {
    "id": "call_2025_06",
    "timestamp": "2025-11-24T10:00:00.000",
    "duration_seconds": 12,
    "contact_name": null,
    "phone_number": "+1-202-555-0188",
    "audio_file_path": null,
    "is_snippet": false,
    "transcript":
        "This is the IRS. We are filing a lawsuit against you. To stop the arrest warrant, press 1 now to speak to a federal agent. Press 1 now.",
    "ai_metadata": {
      "summary": "Robocall claiming to be IRS threatening legal action.",
      "sentiment": "Spam",
      "entities": [
        {"label": "Scam Type", "value": "IRS Impersonation"},
      ],
      "is_spam": true,
    },
  },
  {
    "id": "call_2025_07",
    "timestamp": "2025-11-27T10:00:00.000",
    "duration_seconds": 120,
    "contact_name": null,
    "phone_number": "+1-555-099-1122",
    "audio_file_path": null,
    "is_snippet": false,
    "transcript":
        "Hi, this is Sarah returning your call from Threads & Co. We got your artwork. For 500 units, we recommend our premium Bamboo-Cotton blend. It is super soft. The price per unit is higher, sitting at \$7.20 per shirt, but that includes free 2-day shipping. We can definitely hit your deadline next week. If you want the cheaper standard cotton, we are out of stock until next month. Let me know if you want to proceed with the premium option.",
    "group_ids": ["project_alpha", "vendors"],
    "ai_metadata": {
      "summary":
          "Quote from Threads & Co. Premium Bamboo-Cotton blend available for \$7.20/unit. Includes free 2-day shipping. Standard cotton out of stock.",
      "entities": [
        {"label": "Vendor", "value": "Threads & Co"},
        {"label": "Price", "value": "\$7.20/unit"},
        {"label": "Material", "value": "Bamboo-Cotton"},
        {"label": "Shipping", "value": "Free (2-day)"},
      ],
    },
  },
  {
    "id": "call_2025_08",
    "timestamp": "2025-11-27T11:45:00.000",
    "duration_seconds": 95,
    "contact_name": null,
    "phone_number": "+1-888-555-9999",
    "audio_file_path": null,
    "is_snippet": false,
    "transcript":
        "Yeah, hello? This is Dave from BulkMaster Warehouse. Looking at your request for 500 tees. I can get you a rock-bottom price of \$3.80 a shirt. It's a 50/50 polyester blend, not 100% cotton, but it's cheap. The only thing is, shipping is coming from our west coast warehouse, so it takes about 7 to 10 business days. Shipping cost is extra, probably around \$150 flat fee. If you need it sooner, I can't help you.",
    "group_ids": ["project_alpha", "vendors"],
    "ai_metadata": {
      "summary":
          "Quote from BulkMaster. Lowest price at \$3.80/unit (Polyester blend). Shipping takes 7-10 days and costs extra (\$150). High risk of missing deadline.",
      "entities": [
        {"label": "Vendor", "value": "BulkMaster"},
        {"label": "Price", "value": "\$3.80/unit"},
        {"label": "Material", "value": "50/50 Poly Blend"},
        {"label": "Shipping", "value": "7-10 Days (+\$150)"},
      ],
    },
  },
  {
    "id": "call_2025_09",
    "timestamp": "2025-11-27T13:15:00.000",
    "duration_seconds": 60,
    "contact_name": null,
    "phone_number": "+1-555-562-2501",
    "audio_file_path": null,
    "is_snippet": false,
    "transcript":
        "Hey neighbor, it's City Graphics down on Main Street. We can do the 500 shirts for you. We charge \$6.00 flat per shirt. No shipping fees because you can just drive your truck around back and pick them up on Tuesday. We use the standard Gildan Heavy Cotton tees. Payment is due on pickup. Let us know.",
    "group_ids": ["project_alpha", "vendors"],
    "ai_metadata": {
      "summary":
          "Quote from City Graphics (Local). Price is \$6.00/unit. Standard Cotton. No shipping cost (Local Pickup). Available Tuesday.",
      "entities": [
        {"label": "Vendor", "value": "City Graphics"},
        {"label": "Price", "value": "\$6.00/unit"},
        {"label": "Material", "value": "Standard Cotton"},
        {"label": "Shipping", "value": "Local Pickup (Free)"},
      ],
    },
  },
  {
    "id": "call_2025_10",
    "timestamp": "2025-11-23T10:00:00.000",
    "duration_seconds": 55,
    "contact_name": "Alice (Keynote)",
    "phone_number": "+1-555-099-8877",
    "audio_file_path": null,
    "is_snippet": false,
    "transcript":
        "Hey! It's Alice. I finally got the invite link you sent, thanks. I just booked my travel for the TechMeet. I'm flying in on Delta flight DL-492. It lands next Thursday at 2:15 PM at Terminal 4. I'll just Uber to the venue, so don't worry about picking me up. \n\nOne quick thing for the dinner—I actually switched to a Vegan diet recently, so please make sure there's a meal option for me. Also, for my presentation, I'm bringing my MacBook. Does the stage have a USB-C adapter, or should I bring my own HDMI dongle? Let me know. See you soon!",
    "group_ids": ["project_alpha", "speakers"],
    "ai_metadata": {
      "summary":
          "Alice confirmed attendance for TechMeet Keynote. Flying in on Delta DL-492 (Lands Thu 2:15 PM). Noted Vegan dietary restriction. Asked about USB-C/HDMI availability for the stage.",
      "sentiment": "Positive / Logistical",
      "entities": [
        {"label": "Flight", "value": "Delta DL-492"},
        {"label": "Arrival", "value": "Thursday @ 2:15 PM"},
        {"label": "Requirement", "value": "Vegan Meal"},
        {"label": "Tech Question", "value": "USB-C vs HDMI"},
      ],
    },
  },
  {
    "id": "call_2025_11",
    "timestamp": "2025-11-25T15:30:00.000",
    "duration_seconds": 85,
    "contact_name": "Chase Bank (Fraud Prot)",
    "phone_number": "+1-800-935-9935",
    "audio_file_path": null,
    "is_snippet": false,
    "transcript":
        "Hello, this is the automated fraud protection services from Chase Bank. We detected an unusual transaction on your Business Platinum Visa ending in 4099. \n\nThe transaction was attempted today at 3:15 PM for the amount of eight thousand dollars and zero cents to 'CloudHost Enterprise'. \n\nIf you recognize this transaction, please say 'Yes'. \n\nYes. \n\nThank you. To authorize this payment, please state the last 4 digits of your Tax ID number for security. \n\nIt is 9-9-2-1. \n\nThank you. Verification successful. The hold on your card has been lifted and the transaction to CloudHost has been approved. You may need to ask the merchant to run the card again. Have a nice day.",
    "group_ids": ["finance", "project_alpha"],
    "ai_metadata": {
      "summary":
          "Chase Bank fraud verification for the \$8,000 transaction to CloudHost. User confirmed the charge and provided Tax ID verification (9921). Card hold lifted.",
      "sentiment": "Neutral / Automated",
      "entities": [
        {"label": "Card", "value": "Visa ...4099"},
        {"label": "Merchant", "value": "CloudHost"},
        {"label": "Amount", "value": "\$8,000.00"},
        {"label": "Status", "value": "Approved / Unblocked"},
      ],
    },
  },
  {
    "id": "call_2025_12",
    "timestamp": "2025-11-20T17:45:00.000",
    "duration_seconds": 135,
    "contact_name": "Mark (Landlord)",
    "phone_number": "+1-555-022-3344",
    "audio_file_path": null,
    "is_snippet": false,
    "transcript":
        "Hi, it's Mark. Do you have a minute? \n\nYeah, hi Mark. What's up? \n\nI'm calling about the lease renewal for next year. I sent the docusign over email, but I haven't seen it signed yet. Just wanted to let you know that the rent is going to go up slightly starting February 1st. It'll be two thousand one hundred a month. \n\nTwo thousand one hundred? That's a hundred dollar jump. Mark, honestly, I'm hesitant to sign because the A/C unit in the master bedroom has been making that rattling noise for three months. You said you'd fix it in October. \n\nI know, I know. It's been hard to get a contractor out there. Tell you what—if you sign the renewal by this weekend, I will have the HVAC guy there this Thursday. \n\nThis Thursday? What time? I have work. \n\nHe has a slot at 2:00 PM. Can you be home? \n\nI can make 2:00 PM work if it's guaranteed fixed. \n\nIt's guaranteed. I'll text you his name. So we are good on the \$2,100? \n\nFine. I'll sign it tonight.",
    "group_ids": ["personal_admin", "housing"],
    "ai_metadata": {
      "summary":
          "Discussed lease renewal with Landlord Mark. Rent increasing to \$2,100/month starting Feb 1st. User agreed to sign lease tonight on condition that the A/C is fixed. Maintenance scheduled for Thursday at 2:00 PM.",
      "sentiment": "Negotiation / Agreement",
      "entities": [
        {"label": "New Rent", "value": "\$2,100/month"},
        {"label": "Start Date", "value": "Feb 1st"},
        {"label": "Maintenance", "value": "A/C Repair"},
        {"label": "Appointment", "value": "Thursday @ 2:00 PM"},
      ],
    },
  },
  {
    "id": "call_2025_13",
    "timestamp": "2025-11-26T09:15:00.000",
    "duration_seconds": 95,
    "contact_name": "Dr. Chen's Office",
    "phone_number": "+1-555-010-5522",
    "audio_file_path": null,
    "is_snippet": false,
    "transcript":
        "Good morning, is this Alex? \n\nYes, speaking. \n\nHi Alex, this is Jessica calling from Dr. Chen's office. We realized it's been over a year since your last physical, so we wanted to get you on the schedule before the end of the year rush. Do you have any availability next week? \n\nUh, maybe. What do you have open? \n\nWe have a slot this coming Tuesday at 10:00 AM. \n\nNo, I can't do Tuesday, I have a team meeting. Do you have anything later in the week? Maybe Thursday afternoon? \n\nLet me look... Thursday... okay, Dr. Chen is fully booked until 3:00 PM. I have a 3:30 PM opening. Does that work? \n\n3:30 PM on Thursday? Yeah, I can make that work. \n\nGreat. I have you down for Thursday, December 4th at 3:30 PM. Please remember to bring your new insurance card since I see your policy changed on file. \n\nOkay, will do. Thanks, Jessica.",
    "group_ids": ["health", "personal_admin"],
    "ai_metadata": {
      "summary":
          "Scheduled annual physical with Dr. Chen's office. Initially offered Tuesday, but rescheduled due to work conflict. Final appointment confirmed for Thursday, Dec 4th at 3:30 PM. User needs to bring new insurance card.",
      "sentiment": "Neutral / Scheduling",
      "entities": [
        {"label": "Appointment", "value": "Thu, Dec 4 @ 3:30 PM"},
        {"label": "Doctor", "value": "Dr. Chen"},
        {"label": "Requirement", "value": "Bring Insurance Card"},
        {"label": "Action", "value": "Add to Calendar"},
      ],
    },
  },
  {
    "id": "call_2025_14",
    "timestamp": "2025-11-26T14:00:00.000",
    "duration_seconds": 210,
    "contact_name": "David (Candidate)",
    "phone_number": "+1-415-555-0921",
    "audio_file_path": null,
    "is_snippet": false,
    "transcript":
        "Hi David, thanks for picking up. I know this is last minute, but I saw your resume and wanted to do a quick phone screen before we schedule the technical panel. Do you have ten minutes? \n\nYeah, absolutely. Thanks for reaching out. \n\nGreat. So, I see here you spent three years at FinTechCorp. What was your main focus there? \n\nMostly backend architecture. I migrated our legacy monolith to microservices using Go and Kubernetes. We were handling about 50,000 requests per second. \n\nInteresting. We actually just had an issue with our Auth service timing out on AWS. Do you have experience with high-load scaling on AWS? \n\nYeah, definitely. At my last job, we used Redis caching layers to prevent exactly that kind of timeout. I'm AWS certified, actually. \n\nOkay, that is exactly what we need right now. We are a startup, so things move fast. Are you comfortable with that? \n\nI prefer it. Big corps move too slow. \n\nCool. And just to respect everyone's time—what are you looking for regarding compensation? \n\nI'm targeting around one-fifty base, plus equity. \n\n\$150k is within our band for a Senior role. Okay, David, I like your background. I'm going to pass you to Alex, my Lead Dev, for a code test. Look out for an invite tomorrow. \n\nSounds great, thanks John.",
    "group_ids": ["project_alpha", "hiring"],
    "ai_metadata": {
      "summary":
          "Phone screen with candidate David. Strong background in Backend Architecture (Go, Kubernetes). Experience handling 50k RPS and fixing AWS timeouts using Redis (Relevant to recent crash). Salary expectation is \$150k + Equity. Moving to next round with Alex.",
      "sentiment": "Positive / Impressed",
      "entities": [
        {"label": "Role", "value": "Senior Backend Eng"},
        {"label": "Skills", "value": "Go, Kubernetes, AWS, Redis"},
        {"label": "Salary", "value": "\$150k Base"},
        {"label": "Action", "value": "Schedule Code Test (Alex)"},
      ],
    },
  },
  {
    "id": "call_2025_15",
    "timestamp": "2025-11-27T09:30:00.000",
    "duration_seconds": 190,
    "contact_name": "Karen (StateSafe Agent)",
    "phone_number": "+1-555-088-4411",
    "audio_file_path": null,
    "is_snippet": false,
    "transcript":
        "Hi Karen, it's John from Project Alpha. I'm in a bit of a bind. \n\nHi John. What's going on? \n\nSo, I'm trying to renew the lease for our office space, but the landlord, Mark, is holding it up. He says our current Certificate of Insurance is invalid because we are doing construction work—the electrical stuff I told you about. He needs a new COI by tomorrow or he won't countersign the lease. \n\nAh, I see. Let me pull up your file. Policy number P-99-42-X... okay, here it is. Yeah, your current General Liability policy is for 'Software Development Office'. It doesn't cover 'Active Renovation'. \n\nOkay, well, what do we need to do? \n\nWe need to add a 'Builder's Risk' rider to the policy until the construction is finished. And we need to bump your aggregate coverage from one million to two million dollars. \n\nFine. How much is that going to cost? \n\nIt'll add a prorated premium of about \$450 for the year. \n\nThat's fine. Just do it. \n\nOkay. I also need to list the landlord as an 'Additional Insured' on the certificate. What is the legal entity name? \n\nIt's 'Downtown Properties LLC'. \n\nGot it. I'm processing the change now. I'll email the PDF certificate to you and Mark within the hour. \n\nThanks, Karen. You're a lifesaver.",
    "group_ids": ["personal_admin", "housing", "finance"],
    "ai_metadata": {
      "summary":
          "Urgent call with Insurance Agent Karen. Landlord requires updated Certificate of Insurance (COI) due to office renovations. Action taken: Added 'Builder's Risk' rider and increased General Liability coverage to \$2M. Added 'Downtown Properties LLC' as Additional Insured. Cost: \$450 prorated. PDF arriving in 1 hour.",
      "sentiment": "Urgent / Compliance",
      "entities": [
        {"label": "Policy", "value": "P-99-42-X"},
        {"label": "Coverage", "value": "\$2M General Liability"},
        {"label": "Add-on", "value": "Builder's Risk Rider"},
        {"label": "Cost", "value": "\$450.00"},
        {"label": "Entity", "value": "Downtown Properties LLC"},
      ],
    },
  },
  {
    "id": "call_2025_16",
    "timestamp": "2025-11-27T16:00:00.000",
    "duration_seconds": 130,
    "contact_name": null,
    "phone_number": "+1-555-099-3261",
    "audio_file_path": null,
    "is_snippet": false,
    "transcript":
        "Hi, thanks for holding. This is Lisa from CustomBrand. I have your inquiry here for the TechMeet event. \n\nHi Lisa. Yeah, I'm collecting final quotes today. What can you do for 500 units? \n\nWell, we do things differently. We don't use standard cotton. We use 100% recycled rPET fabric or organic hemp. It fits your 'Tech' vibe better. \n\nThat sounds cool, but what's the damage? \n\nFor 500 units, the price is \$8.50 per shirt. \n\n\$8.50? That is way above my budget. I have quotes for five bucks. \n\nI understand, but those are throw-away shirts. Ours last for years. Plus, for that price, we include free vector artwork cleanup and we plant a tree for every shirt sold. \n\nOkay, the tree thing is a nice marketing angle. What about speed? \n\nWe print locally. We can have them at your office by Monday morning. \n\nMonday is fast. Okay, send me the official PDF. I need to compare it with the other four vendors tonight. \n\nWill do. Sending now.",
    "group_ids": ["project_alpha", "vendors"],
    "ai_metadata": {
      "summary":
          "Quote from CustomBrand (Vendor #5). Offer is \$8.50/unit (Highest price). Material is Recycled rPET/Hemp (Eco-friendly). Includes vector cleanup and tree planting. Delivery by Monday morning.",
      "sentiment": "Sales / Informational",
      "entities": [
        {"label": "Vendor", "value": "CustomBrand"},
        {"label": "Price", "value": "\$8.50/unit"},
        {"label": "Material", "value": "Recycled/Hemp"},
        {"label": "Perk", "value": "Fast Delivery (Mon)"},
      ],
    },
  },
  {
    "id": "call_2025_17",
    "timestamp": "2025-11-25T18:00:00.000",
    "duration_seconds": 110,
    "contact_name": "Diego (Tulum Host)",
    "phone_number": "+52-984-555-0199",
    "audio_file_path": null,
    "is_snippet": false,
    "transcript":
        "Hola? Diego speaking. \n\nHi Diego, this is John. I'm the guest arriving tonight. My flight was delayed, so I won't get there until midnight. Is that okay? \n\nAh, Si, no problem Mr. John. I will leave the keys for you. But listen, the gate will be locked. You need to use the lockbox. \n\nOkay, what is the code? \n\nOkay, listen carefully. La llave está en la caja de seguridad. El código es cuatro-cinco-nueve-cero. Repito, cuatro-cinco-nueve-cero. \n\nWait, sorry, my Spanish is bad. Four, five... what was the rest? \n\nNine. Zero. 4-5-9-0. \n\nGot it. And the Wifi? \n\nThe Wifi password is written on the fridge. But careful, el agua caliente tarda un poco. You must wait five minutes for hot water. \n\nOkay, wait 5 mins for hot water. Understood. \n\nSi. Buen viaje amigo. See you tomorrow.",
    "group_ids": ["mexico_trip", "travel"],
    "ai_metadata": {
      "summary":
          "Late check-in coordination with Diego (Tulum). Keys are in the lockbox. Host provided gate code and hot water instructions in mixed Spanish/English.",
      "sentiment": "Helpful / Instructional",
      "entities": [
        {
          "label": "Lockbox Code",
          "value": "4-5-9-0",
          "context": "Translation: 'cuatro-cinco-nueve-cero'",
        },
        {
          "label": "Instruction",
          "value": "Hot water takes 5 mins",
          "context": "Translation: 'el agua caliente tarda un poco'",
        },
        {"label": "Key Location", "value": "Lockbox (Caja de seguridad)"},
      ],
    },
  },
  {
    "id": "call_2025_18",
    "timestamp": "2025-11-21T08:15:00.000",
    "duration_seconds": 90,
    "contact_name": null,
    "phone_number": "+52-984-555-8878",
    "audio_file_path": null,
    "is_snippet": false,
    "transcript":
        "Cenote Tours, this is Pedro. \n\nHi Pedro, this is John. The guy from the Airbnb mentioned you guys do the turtle snorkeling boats? \n\nYes, amigo. We have the best boats. The water is perfect today. Do you want to go this morning? \n\nYeah, we are looking for a slot around 10 AM. We have four people. \n\n10 AM... let me check... Yes, I can fit you on the 'Estrella'. But you need to hurry. \n\nOkay, we'll take it. Can I pay with Amex when I get there? \n\nNo, no, no. Sorry sir. On the beach, the machine never works. It is Cash Only. Pesos or US Dollars is fine, but no cards. \n\nOkay, good to know. Cash only. How much? \n\nIt is \$40 per person. So \$160 total. Meet me by the big white lighthouse in 45 minutes. \n\nGot it. Lighthouse. Cash. See you soon.",
    "group_ids": ["mexico_trip", "travel"],
    "ai_metadata": {
      "summary":
          "Booked turtle snorkeling tour with Pedro. Slot confirmed for today at 10:00 AM for 4 people on boat 'Estrella'. Meeting point: The white lighthouse.",
      "sentiment": "Excited / Urgent",
      "entities": [
        {"label": "Activity", "value": "Turtle Snorkeling"},
        {"label": "Cost", "value": "\$160 Total (\$40/pp)"},
        {"label": "Requirement", "value": "CASH ONLY (No Cards)"},
        {"label": "Location", "value": "White Lighthouse"},
      ],
    },
  },
  {
    "id": "call_2025_19",
    "timestamp": "2025-11-26T16:30:00.000",
    "duration_seconds": 180,
    "contact_name": "Kevin (Candidate)",
    "phone_number": "+1-206-555-0844",
    "audio_file_path": null,
    "is_snippet": false,
    "transcript":
        "Hi Kevin, thanks for joining. I wanted to chat about the Backend Lead role. \n\nSure. I saw your job post. To be honest, I'm just browsing. I'm currently at Googolplex, so it would take a lot to move me. \n\nI understand. Well, let me tell you about our stack. We are running Go microservices on AWS. We just hit a scaling bottleneck and... \n\nWait, you're using Go? That's your first mistake. If I come in, I'm going to want to rewrite the entire core in Rust. Go is garbage collection heavy. You'll never scale. \n\nWell, a full rewrite isn't really on the roadmap. We need to ship features. \n\nIf you want top-tier talent, you need top-tier tech. I don't touch legacy codebases. Also, what is your on-call policy? \n\nWe rotate weekly among the 4 engineers. \n\nYeah, no. I don't do on-call. I write the code; I don't wake up at 3 AM to fix it. That's for junior ops people. \n\nOkay... noted. And salary expectations? \n\nMy current package is \$220k base plus heavy stock. I'd need a sign-on bonus to even consider a startup. \n\nOkay Kevin, I think we are looking for different things. Thanks for your time. \n\nRight. Good luck with the Go spaghetti.",
    "group_ids": ["project_alpha", "hiring"],
    "ai_metadata": {
      "summary":
          "Screening with Kevin. Candidate was dismissive of current stack (Go) and insisted on a full rewrite in Rust. Refused to participate in on-call rotation. Salary expectation is \$220k+ with sign-on bonus. Poor culture fit.",
      "sentiment": "Negative / Arrogant",
      "entities": [
        {"label": "Role", "value": "Backend Lead"},
        {"label": "Demand", "value": "Rewrite in Rust"},
        {"label": "Red Flag", "value": "Refused On-Call"},
        {"label": "Salary", "value": "\$220k Base"},
      ],
    },
  },
  {
    "id": "call_2025_20",
    "timestamp": "2025-11-27T10:00:00.000",
    "duration_seconds": 105,
    "contact_name": "Alex (Dev Lead)",
    "phone_number": "+1-555-014-8822",
    "audio_file_path": null,
    "is_snippet": false,
    "transcript":
        "Hey Alex, do you have a sec? I want to wrap up the backend hiring search. Did you review the code tests? \n\nYeah, I looked at them this morning. \n\nWhat's the verdict? \n\nWell, Kevin's code was... clever. But honestly? It was unreadable. He tried to force Rust patterns into Go. Plus, I heard he was pretty arrogant on your screening call. \n\nArrogant is an understatement. He refused on-call and demanded a full rewrite. I'm a hard no on Kevin. \n\nAgreed. What about David? \n\nDavid was solid. His code test wasn't flashy, but it passed all edge cases and was super clean. Plus, he already knows how to fix our AWS timeout issue. And he fits the budget at \$150k. \n\nThat sounds like a winner to me. We need someone who can hit the ground running, not someone who wants to reinvent the wheel. \n\nOkay, decision made. I'm going to extend the offer to David today. I'll put the start date for next Monday. \n\nAwesome. I'll get his laptop setup ready.",
    "group_ids": ["project_alpha", "hiring"],
    "ai_metadata": {
      "summary":
          "Hiring debrief with Alex. Reviewed code tests for Kevin vs David. Kevin rejected due to poor culture fit and over-engineering. David selected for the role based on clean code, AWS skills, and budget fit. Action: Send offer letter to David for Monday start.",
      "sentiment": "Decisive / Positive",
      "entities": [
        {"label": "Decision", "value": "HIRE DAVID"},
        {"label": "Rejected", "value": "Kevin"},
        {"label": "Start Date", "value": "Next Monday"},
        {"label": "Action", "value": "Send Offer Letter"},
      ],
    },
  },
  {
    "id": "call_2025_21",
    "timestamp": "2025-11-22T14:30:00.000",
    "duration_seconds": 75,
    "contact_name": "Dr. Martinez (Referral)",
    "phone_number": "+1-555-033-7788",
    "audio_file_path": null,
    "is_snippet": false,
    "transcript":
        "Hi, this is Dr. Martinez returning your call. I reviewed the X-rays your primary care sent over. I'd like to schedule you for a consultation next week. When you call my office to book, ask for Janet. Her direct line is... let me give you the number. It's area code 555, then 876-3401. Again, that's 555-876-3401. Make sure you mention that I referred you, otherwise they'll put you on the general waitlist which is backed up for three weeks. Oh, and bring your insurance card and a photo ID. See you soon.",
    "ai_metadata": {
      "summary":
          "Dr. Martinez reviewed X-rays and wants to schedule a consultation. Provided direct office number (555-876-3401) and instructed to ask for Janet with referral mention to avoid waitlist.",
      "sentiment": "Professional / Informative",
      "entities": [
        {"label": "Phone", "value": "555-876-3401"},
        {"label": "Contact", "value": "Janet (Office Scheduler)"},
        {"label": "Requirement", "value": "Insurance Card + Photo ID"},
        {"label": "Action", "value": "Call to Schedule Consultation"},
      ],
    },
  },
  {
    "id": "call_2025_22",
    "timestamp": "2025-11-23T16:45:00.000",
    "duration_seconds": 95,
    "contact_name": "Rachel (Real Estate)",
    "phone_number": "+1-555-091-2233",
    "audio_file_path": null,
    "is_snippet": false,
    "transcript":
        "Hey! Rachel here from Skyline Realty. Great news—I found three properties that match your criteria. I'm sending you the listing links via email, but I really think you should see the condo on Pine Street ASAP. It's listed at four hundred and twenty-five thousand, but the seller is motivated. Here's what I need you to do. Call the building manager directly to schedule a private showing before the open house this weekend. His name is Robert Chen. Write this down: 415-298-7654. That's 415-298-7654. Tell him Rachel sent you. He owes me a favor, so he'll prioritize you. Can you call him today? The property won't last.",
    "ai_metadata": {
      "summary":
          "Rachel found a condo match on Pine Street listed at \$425k. Provided building manager's direct number (415-298-7654) to schedule private showing before open house. Urgent action needed.",
      "sentiment": "Excited / Urgent",
      "entities": [
        {"label": "Phone", "value": "415-298-7654"},
        {"label": "Contact", "value": "Robert Chen (Building Manager)"},
        {"label": "Property", "value": "Pine Street Condo"},
        {"label": "Price", "value": "\$425,000"},
        {"label": "Action", "value": "Call Today for Showing"},
      ],
    },
  },
  {
    "id": "call_2025_23",
    "timestamp": "2025-11-25T11:20:00.000",
    "duration_seconds": 120,
    "contact_name": "Tom (Client)",
    "phone_number": "+1-555-044-9988",
    "audio_file_path": null,
    "is_snippet": false,
    "transcript":
        "Tom, hey, it's John. Listen, I know you've been trying to get ahold of the legal team about the contract amendments. They've been swamped, but I got you a shortcut. My contact there is Elizabeth Warner. She handles commercial agreements. \n\nOkay, what's her number? \n\nAlright, she's got two lines. Her office landline is 202-555-1823. But honestly, she never picks that up. If you want to actually reach her, text her mobile. It's 202-779-4456. Let me repeat that. 202-779-4456. \n\nGot it. 202-779-4456. \n\nYeah. And when you text her, start with 'John from Project Alpha referred me' so she knows you're legit. She gets bombarded with spam, so otherwise she'll ignore it. \n\nPerfect. I'll text her this afternoon. Thanks for the connect, man. \n\nNo problem. Let me know how it goes.",
    "ai_metadata": {
      "summary":
          "John provided contact info for legal team member Elizabeth Warner. Office line: 202-555-1823 (rarely answered). Preferred mobile: 202-779-4456 (text recommended with referral mention).",
      "sentiment": "Helpful / Networking",
      "entities": [
        {"label": "Phone", "value": "202-555-1823 (Office)"},
        {"label": "Phone", "value": "202-779-4456 (Mobile - Preferred)"},
        {"label": "Contact", "value": "Elizabeth Warner (Legal)"},
        {"label": "Action", "value": "Text with Referral Introduction"},
      ],
    },
  },
  {
    "id": "call_2025_24",
    "timestamp": "2025-11-26T10:00:00.000",
    "duration_seconds": 85,
    "contact_name": "Unknown Caller",
    "phone_number": "+1-555-077-3322",
    "audio_file_path": null,
    "is_snippet": false,
    "transcript":
        "Hey, sorry I missed you at the conference yesterday. I wanted to follow up on the API integration we discussed. I think our platforms could work really well together. \n\nYeah, definitely interested. What's the next step? \n\nLet's set up a technical deep-dive call next week. I'll have my CTO join. Can you send me an email with your availability? My work email is james.patterson@techflow.io. That's J-A-M-E-S dot P-A-T-T-E-R-S-O-N at techflow dot I-O. \n\nGot it. \n\nOh, and if you want to reach me directly, my cell is 650-443-8821. I'm on Pacific Time, so avoid calling before 9 AM. Text is fine anytime though. \n\nPerfect. I'll send that email today. \n\nAwesome. Looking forward to it.",
    "ai_metadata": {
      "summary":
          "Follow-up from conference regarding API integration partnership. Contact provided email (james.patterson@techflow.io) and mobile (650-443-8821, Pacific Time). Next step: Send availability for technical call.",
      "sentiment": "Professional / Collaborative",
      "entities": [
        {"label": "Phone", "value": "650-443-8821"},
        {"label": "Email", "value": "james.patterson@techflow.io"},
        {"label": "Contact", "value": "James Patterson"},
        {"label": "Timezone", "value": "Pacific Time (No calls before 9 AM)"},
        {"label": "Action", "value": "Email Availability"},
      ],
    },
  },
];
