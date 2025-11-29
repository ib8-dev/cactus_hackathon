String getStableExtractionPrompt(String date, transcript) {
  return """
### INSTRUCTION ###
Extract data. Return a simple list.
Format: TYPE :: LABEL :: VALUE

### ALLOWED TYPES ###
PHONE, EMAIL, MONEY, DATE, LOCATION, NOTE

### EXAMPLES ###
User: Call Mike at 555-0199 about the \$500 rent.
System:
PHONE :: Mike's Number :: 555-0199
MONEY :: Rent Cost :: \$500

User: Flight is tomorrow.
System:
DATE :: Flight Date :: $date (Calculated)

### TRANSCRIPT ###
$transcript
""";
}
