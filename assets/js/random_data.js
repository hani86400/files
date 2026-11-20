const BYTE_MAX = 255;
const DOMAINS = ["net", "com", "org", "xyz", "shop", "ai"];
const LOWER = "abcdefghijklmnopqrstuvwxyz";
const UPPER = "ABCDEFGHIJKLMNOPQRSTUVWXYZ";
const NUMBERS = "0123456789";
const SYMBOLS = "!@#$%^&*()_+~|}{[]:;?><,./-=";
const HEX = "0123456789abcdef";
const COLORS = ["Red", "Green", "Blue", "Yellow", "Pink", "Cyan", "Purple", "Orange", "Gray", "Brown", "Mint", "Indigo"];
const NAMES = ["Alice", "Bob", "Charlie", "David", "Eve", "Frank", "Grace", "Hank", "Ivy", "Jack", "Kate", "Leo", "Mia", "Ned", "Oscar", "Paul", "Quin", "Rose", "Sam", "Tom"];

function valid_ip4(ip)  { var IP4_PATTERN = /^((25[0-5]|2[0-4][0-9]|[01]?[0-9][0-9]?)\.){3}(25[0-5]|2[0-4][0-9]|[01]?[0-9][0-9]?)$/; return typeof ip === 'string' && IP4_PATTERN.test(ip);}
function valid_ip6(ip)  { var IP6_PATTERN = /^(([0-9a-fA-F]{1,4}:){7,7}[0-9a-fA-F]{1,4}|([0-9a-fA-F]{1,4}:){1,7}:|([0-9a-fA-F]{1,4}:){1,6}:[0-9a-fA-F]{1,4}|([0-9a-fA-F]{1,4}:){1,5}(:[0-9a-fA-F]{1,4}){1,2}|([0-9a-fA-F]{1,4}:){1,4}(:[0-9a-fA-F]{1,4}){1,3}|([0-9a-fA-F]{1,4}:){1,3}(:[0-9a-fA-F]{1,4}){1,4}|([0-9a-fA-F]{1,4}:){1,2}(:[0-9a-fA-F]{1,4}){1,5}|[0-9a-fA-F]{1,4}:((:[0-9a-fA-F]{1,4}){1,6})|:((:[0-9a-fA-F]{1,4}){1,7}|:)|fe80:(:[0-9a-fA-F]{0,4}){0,4}%[0-9a-zA-Z]{1,}|::(ffff(:0{1,4}){0,1}:){0,1}((25[0-5]|(2[0-4]|1{0,1}[0-9]){0,1}[0-9])\.){3,3}(25[0-5]|(2[0-4]|1{0,1}[0-9]){0,1}[0-9])|([0-9a-fA-F]{1,4}:){1,4}:((25[0-5]|(2[0-4]|1{0,1}[0-9]){0,1}[0-9])\.){3,3}(25[0-5]|(2[0-4]|1{0,1}[0-9]){0,1}[0-9]))$/; return typeof ip === 'string' && IP6_PATTERN.test(ip);}
function valid_email(e) { var EMAIL_PATTERN = /^[^\s@]+@[^\s@]+\.[^\s@]+$/; return typeof e === 'string' && EMAIL_PATTERN.test(e);}


function random_integer(min, max) { return Math.floor(Math.random() * (max - min + 1)) + min; }
function random_array_element1(arr) { return arr[Math.floor(Math.random() * arr.length)]; }
function random_array_element(arr, min, max, join) {
    if (min === undefined) { return  arr[Math.floor(Math.random() * arr.length)]; }
    var size = max === undefined ? min : Math.floor(Math.random() * (max - min + 1)) + min;
    var result = [];
    for (var i = 0; i < size; i++) { result.push(arr[Math.floor(Math.random() * arr.length)]); }
    return join !== undefined ? result.join(join) : result;
}

function random_uuid() {
    // 1. Check if running inside Google Apps Script (GAS)
    if (typeof Utilities !== 'undefined' && typeof Utilities.getUuid === 'function') { return Utilities.getUuid();    }
    // 2. Fallback to Node.js runtime environment safely
    var cryptoModule = require('crypto');
    return cryptoModule.randomUUID();
}


function random_ip4()  { return Array.from({ length: 4 }, () => Math.floor(Math.random() * 255)).join('.'); }
function random_ip42() {
const B1 = random_integer(0, BYTE_MAX - 1 );
const B2 = random_integer(0, BYTE_MAX - 1 );
const B3 = random_integer(0, BYTE_MAX - 1 );
const B4 = random_integer(0, BYTE_MAX - 1 );
return `${B4}.${B3}.${B2}.${B1}`
}

function random_ip6()  { return Array.from({ length: 8 }, () => Math.floor(Math.random() * 0x10000).toString(16).padStart(4, '0')).join(':'); }
function random_ip62() {
    var parts = [];
    for (var i = 0; i < 8; i++) {
        var randomHex = Math.floor(Math.random() * 0x10000).toString(16);
        parts.push(randomHex.padStart(4, '0'));
    }
    return parts.join(':');
}


function random_chars(minLen, maxLen) {
    const length = random_integer(minLen, maxLen);
    let result = "";
    for (let i = 0; i !== length; i++)
        result += LOWER[random_integer(0, LOWER.length - 1)];
    return result;
}


function formatDateTime(inp_date) { return `${inp_date.getFullYear()}${String(inp_date.getMonth() + 1).padStart(2, '0')}${String(inp_date.getDate()).padStart(2, '0')}_${String(inp_date.getHours()).padStart(2, '0')}${String(inp_date.getMinutes()).padStart(2, '0')}${String(inp_date.getSeconds()).padStart(2, '0')}`;
}

function random_test_all(){
console.log('random_integer(1000,9999) = ' + random_integer(1000,9999));
console.log('random_chars(4,10) = ' + random_chars(4,10));
console.log('random_domain = ' + random_array_element(DOMAINS,1) );
console.log('random_chars= ' + random_array_element(LOWER,3,9,"") );

console.log('random_ip4() = ' + random_ip4() );
console.log('random_ip6() = ' + random_ip6() );
console.log('UUID = ' + random_uuid());


var user = random_chars(4,10);
var user = random_array_element(NAMES).toLowerCase() + "." + random_array_element(COLORS).toLowerCase();
var domain_name = random_chars(4,10);
var domain = random_array_element(DOMAINS)
var user_email = user + "@" + domain_name + "." + domain ;
console.log('user = ( ' + user + ' )     Email = ( ' + user_email + ' )');



/*
* V A L I D A T E
*/
console.log("\n V A L I D A T E");
var ip4_1 = "192.168.1.1" ;
console.log(`valid_ip4(${ip4_1}) ` + valid_ip4(ip4_1) );

var ip4_1 = "19216811" ;
console.log(`valid_ip4(${ip4_1}) ` + valid_ip4(ip4_1) );


var ip6_1 = "2001:0db8::ff00" ;
console.log(`valid_ip6(${ip6_1}) ` + valid_ip6(ip6_1) );

var email_1 = "test@domain.com" ;
console.log(`valid_email(${email_1}) ` + valid_email(email_1) );



/*
* Date & Time
*/
console.log("\nDate & Time");
var year = random_integer(1960, 2005);
var month = String(random_integer(1, 12)).padStart(2, "0");
var day = String(random_integer(1, 28)).padStart(2, "0");
var date1 = year + "-" + month + "-" + day;
console.log('Date1 = ' + date1 );

var now0 = new Date();
var now1 = formatDateTime(now0)
console.log('now0 = ' + now0 );
console.log('now1 = ' + now1 );

var ISOString0 = now0.toISOString();
var ISOString1 = now0.toISOString().split('T')[0];
var ISOString2 = now0.toISOString().slice(0, 23).replace('T', '_');
console.log('ISOString0 = ' + ISOString0 );
console.log('ISOString1 = ' + ISOString1 );
console.log('ISOString2 = ' + ISOString2 );




}

// Safe environment export: Works in Node.js, silently ignored in GAS
if (typeof module !== 'undefined' && typeof module.exports !== 'undefined') {    module.exports = { random_test_all: random_test_all }; }


