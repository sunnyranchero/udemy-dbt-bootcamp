
Preset.IO Adding Unencrypted Key & Test Connection Quirks (Sharing with the class)
0 upvotes
Christopher · Lecture 67 · A few seconds ago
I wanted to set this up myself instead of using the auto generated field values. It turns out that unencrypted private keys are full usable here but the if you try to test the connection, it will always fail. Despite the this, I think I checked it over about 6 times before just hitting "connect" and it is working just fine. I wanted to share with the class what I found. Hope it helps someone.



Here is some example json for the advanced tab but for the unencrypted value:

The actual private key was removed but it needs to be all on 1 line, if you need a new line, just replace the new line with the actual "\n" character. The password can be left blank but the key/value must be present.



The private key is the .p8 file that was created. Encrypted or not. The private key MUST be all on 1 line.

{
    "auth_method": "keypair",
    "auth_params": {
        "privatekey_body": "-----BEGIN PRIVATE KEY-----\nY=\n-----END PRIVATE KEY-----",
        "privatekey_pass": ""
    }
}


This is an example URI:

Use this Snowflake query to find the needed values:

SELECT 
  CURRENT_ORGANIZATION_NAME() AS org_identifier, 
  CURRENT_ACCOUNT_NAME() AS display_name;   
The <ORG_IDENTIFIER> (appears under the profile popup)

The <DISPLAY_NAME> is for part 2, the account_name

(there are actually 3 identifiers in snowflake... it can get confusing)

snowflake://preset@<ORG_IDENTIFIER>-<DISPLAY_NAME>/AIRBNB?role=REPORTER&warehouse=COMPUTE_WH


____________

I'm on linux using the wl-clipboard program (wayland). Mentioning this because of the linux command below. This just lets me access my clipboard.  You can scrub the raw text file to your clipboard like this:

sed ':a;N;$!ba;s/\n/\\n/g' rsa_key.p8 | wl-copy
