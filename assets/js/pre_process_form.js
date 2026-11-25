// ===== Constants =====

var TEXT_FIELDS = ["fempno", "fuserid", "femail", "fpass", "fdob", "fip4", "fip6"];
var GROUP_FIELDS = ["gender", "actions"];
var PASS_MIN = 6;

// ===== Helpers =====
function fn_form_input_show_error(input_element, message) {
  const inputEl = document.getElementById(input_element);
  const errorEl = document.getElementById(input_element + "_error");
  if (!errorEl) return; // Safely exit if the error element ID isn't found
  errorEl.textContent = message;
  if (message) {
    errorEl.style.display = "block";
    inputEl.classList.add("invalid");
  } else {
    errorEl.style.display = "none"; // Force hide
    inputEl.classList.remove("invalid");
  }
}

function clearErrors() {
    var boxes = document.querySelectorAll(".error");
    var inputs = document.querySelectorAll("input.invalid");
    var i;
 
    for (i = 0; i < boxes.length; i++) {
        boxes[i].style.display = "none";
    }
 
    for (i = 0; i < inputs.length; i++) {
        inputs[i].classList.remove("invalid");
    }
}
 
function setStatus(text, failed) {
    var box = document.getElementById("status");
 
    box.textContent = text;
 
    if (failed) {
        box.classList.add("fail");
    } else {
        box.classList.remove("fail");
    }
}
 
function setButtonsDisabled(disabled) {
    var list = document.querySelectorAll(".buttons button");
 
    for (var i = 0; i < list.length; i++) {
        list[i].disabled = disabled;
    }
}


// ===== Validation =====
function fn_form_input_validate_fempno() {
  const inputEl = document.getElementById("fempno");
  const value = inputEl.value.trim();
  const num = Number(value);
  if (value === "" || isNaN(num) || num <= 10) {
    fn_form_input_show_error("fempno", "Please enter a valid employee number greater than 10.");
    return false;
  }
  fn_form_input_show_error("fempno", ""); // Passing "" clears the text and hides the error div
  return true;
}

function fn_form_input_validate_fpass() {
  const inputEl = document.getElementById("fpass");
  if (inputEl.value.length < PASS_MIN)  {
    fn_form_input_show_error("fpass", `Password must be at least ${PASS_MIN} characters.`);
    return false;
  }
  fn_form_input_show_error("fpass", ""); // Passing "" clears the text and hides the error div
  return true;
}

function fn_form_input_validate_femail() {
  const inputEl = document.getElementById("femail");
  if (!valid_email(inputEl.value)) {
    fn_form_input_show_error("femail", "Email Error !");
    return false;
  }
  fn_form_input_show_error("femail", ""); // Passing "" clears the text and hides the error div
  return true;
}

function fn_form_input_validate_fip4() {
  const inputEl = document.getElementById("fip4");
  if (!valid_ip4(inputEl.value)) {
    fn_form_input_show_error("fip4", "IPv4 Error !");
    return false;
  }
  fn_form_input_show_error("fip4", ""); // Passing "" clears the text and hides the error div
  return true;
}
function fn_form_input_validate_fip6() {
  const inputEl = document.getElementById("fip6");
  if (!valid_ip6(inputEl.value)) {
    fn_form_input_show_error("fip6", "IPv6 Error !");
    return false;
  }
  fn_form_input_show_error("fip6", ""); // Passing "" clears the text and hides the error div
  return true;
}


// The single function for everything about the uploaded file.
// The file is optional; when one is chosen it must have an allowed type and not be too big.
function fn_form_input_validate_fufile() {
  const inputEl = document.getElementById("fufile");
  const maxSizeMB = 2;
  const allowed = ["pdf", "jpg", "jpeg", "png"];

  // No file selected is fine: clear any old error and continue
  if (!inputEl || inputEl.files.length === 0) {
    fn_form_input_show_error("fufile", "");
    return true;
  }

  const file = inputEl.files[0];
  const ext = file.name.split(".").pop().toLowerCase();

  // Check file type (the accept attribute alone can be bypassed)
  if (allowed.indexOf(ext) === -1) {
    fn_form_input_show_error("fufile", `File type must be: ${allowed.join(", ")}.`);
    return false;
  }

  // Check file size (bytes -> MB)
  if (file.size > maxSizeMB * 1024 * 1024) {
    fn_form_input_show_error("fufile", `File size must be under ${maxSizeMB}MB.`);
    return false;
  }

  fn_form_input_show_error("fufile", "");
  return true;
}


function fn_form_input_validate_all_inputs() {
    var ok = true;
    clearErrors();
    if (!fn_form_input_validate_fempno()) ok = false;
    if (!fn_form_input_validate_fpass())  ok = false;
    if (!fn_form_input_validate_femail()) ok = false;
    if (!fn_form_input_validate_fip4())   ok = false;
    if (!fn_form_input_validate_fip6())   ok = false;
    if (!fn_form_input_validate_fufile()) ok = false;
    return ok;
}


// ===== Data =====
// Not used while the file is uploaded as a real multipart part; kept for a server that needs base64 text.
function fn_file_to_base64(file) {
  return new Promise(function (resolve, reject) {
    const reader = new FileReader();
    reader.onload  = function () { resolve(reader.result); };   // Returns "data:image/png;base64,..."
    reader.onerror = function (err) { reject(err); };
    reader.readAsDataURL(file);
  });
}


async function fn_form_input_to_json() {
  const file = document.getElementById("fufile")?.files[0] || null;

  return {
    fempno:          document.getElementById("fempno").value,
    fuserid:         document.getElementById("fuserid").value,
    femail:          document.getElementById("femail").value,
    fpass:           document.getElementById("fpass").value,
    fdob:            document.getElementById("fdob").value,
    fip4:            document.getElementById("fip4").value,
    fip6:            document.getElementById("fip6").value,
    fgender:         document.querySelector('input[name="fgender"]:checked')?.value || "no_gender",
    fcity:           document.getElementById("fcity").value,
    factions_gsheet: document.getElementById("factions_gsheet").checked ? "YES" : "NO",
    factions_gdrive: document.getElementById("factions_gdrive").checked ? "YES" : "NO",
    factions_gmail:  document.getElementById("factions_gmail").checked  ? "YES" : "NO",
    factions_cfd1:   document.getElementById("factions_cfd1").checked   ? "YES" : "NO",
    fufile: file ? {
      name: file.name,
      type: file.type,
      size: file.size
    } : null
  };
}


// ===== Set random data =====
function fn_form_input_set_gender() {
  const radios = document.querySelectorAll('input[name="fgender"]');
  if (radios.length === 0) return;

  const randomIndex = Math.floor(Math.random() * radios.length);
  radios[randomIndex].checked = true;
}


function fn_form_input_set_actions() {
  const boxes = [factions_gsheet, factions_gdrive, factions_gmail, factions_cfd1];
  let any = false;

  for (let i = 0; i < boxes.length; i++) {
    boxes[i].checked = Math.random() < 0.5;

    if (boxes[i].checked) any = true;
  }

  // Guarantee at least one is checked
  if (!any) {
    boxes[Math.floor(Math.random() * boxes.length)].checked = true;
  }
}

function fn_form_input_set_all() {
    clearErrors();

    var temp_domain = random_array_element(LOWER,3,9,"") + "." + random_array_element(DOMAINS);
    var temp_year   = random_integer(1960, 2005);
    var temp_month  = String(random_integer(1, 12)).padStart(2, "0");
    var temp_day    = String(random_integer(1, 28)).padStart(2, "0");

    var fempno      = random_integer(400000, 499999);
    var fuserid     = random_array_element(NAMES).toLowerCase(); 
    var femail      = fuserid + "@" + temp_domain ;    
    var fpass       = random_array_element(LOWER,6,8,"");
    var fdob        = temp_year + "-" + temp_month + "-" + temp_day;
    var fip4        = random_ip4(); 
    var fip6        = random_ip6(); 
    
    document.getElementById("fempno").value  = fempno
    document.getElementById("fuserid").value = fuserid
    document.getElementById("femail").value  = femail
    document.getElementById("fpass").value   = fpass
    document.getElementById("fdob").value    = fdob
    document.getElementById("fip4").value    = fip4
    document.getElementById("fip6").value    = fip6
    fn_form_input_set_gender();
    fn_form_input_set_actions(); 

    setStatus("", false);
}


// ===== Buttons =====
function fn_reset() {
    document.getElementById("userform").reset();
    clearErrors();
    setStatus("", false);
}


// ===== Sending (shared by index7.html and index7_gas.html) =====
// fn_submit() itself lives in each page, because the two pages send the file differently:
//   index7.html      -> FormData         (raw file, multipart)      for Apache/PHP, Nginx/Node, Cloudflare Worker
//   index7_gas.html  -> URLSearchParams  (file as base64 text)      for Google Apps Script

// Puts the common fields in a FormData or a URLSearchParams (both have .set)
function fn_form_input_fill_body(body, data) {

    for (var key in data) {
        // File details are an object (or null): skipped, each page adds the file itself
        if (Object.prototype.hasOwnProperty.call(data, key) && typeof data[key] !== "object") {
            body.set(key, data[key]);
        }
    }

    // Explicitly set select & checkbox values so none are missed or duplicated
    if (typeof fcity !== "undefined") {
        body.set("fcity", fcity.value);
    }
    body.set("factions_gsheet", factions_gsheet.checked ? "YES" : "NO");
    body.set("factions_gdrive", factions_gdrive.checked ? "YES" : "NO");
    body.set("factions_gmail",  factions_gmail.checked  ? "YES" : "NO");
    body.set("factions_cfd1",   factions_cfd1.checked   ? "YES" : "NO");

    return body;
}



var report_tab = null;   // the report tab, reused by every submit

// Posts the body, shows the status and writes the server reply into the report tab
async function fn_form_input_send(url, body, data) {
    var file = document.getElementById("fufile").files[0];
    var fileInfo = file ? file.name + " (" + (file.size / 1024).toFixed(1) + " KB)" : "none";
    var shown = JSON.stringify(data);

    console.log("Payload:", data);
    console.log("File:", fileInfo);
    setStatus("Sending... " + shown + "\nFile: " + fileInfo, false);
    setButtonsDisabled(true);

    // Same tab name every time: the first submit opens the tab, the next ones reuse it
    const reused = report_tab !== null && !report_tab.closed;
    const newTab = window.open("", "report_tab");
    report_tab = newTab;

    try {
        const response = await fetch(url, { method: "POST", body: body });
        const text = await response.text();

        setButtonsDisabled(false);
        setStatus("Sent: \n" + shown + "\nFile: " + fileInfo + "\nServer: \nReport opened in new tab.", false);

        if (newTab) {
            const baseTag = '<base href="' + url + '">';
            newTab.document.open();
            newTab.document.write(baseTag + text);
            newTab.document.close();
            newTab.focus();   // bring the updated report to the front (some browsers ignore this)
        }
    } catch (err) {
        if (newTab && !reused) newTab.close();   // never close an earlier report that is still open
        setButtonsDisabled(false);
        setStatus("Send failed (" + (err.message || err) + "): " + shown, true);
    }
}

function fn_set_submit() {
    fn_form_input_set_all();
    fn_submit();
}
 
// ===== Setup =====
function fn_on_edit(e) {
    e.target.classList.remove("invalid");
    document.getElementById(e.target.id + "_error").style.display = "none";
}
 
function fn_on_group_change(e) {
    document.getElementById(e.target.name + "_error").style.display = "none";
}
 
function fn_init() {
    var form = document.getElementById("userform");
    var group;
    var i;
    var j;
 
    form.addEventListener("submit", function (e) { e.preventDefault(); fn_submit();  });
 
    // Clear a field's error as soon as the person edits it
    for (i = 0; i < TEXT_FIELDS.length; i++) {
        document.getElementById(TEXT_FIELDS[i]).addEventListener("input", fn_on_edit);
    }
 
    // Same for the radio and checkbox groups
    for (i = 0; i < GROUP_FIELDS.length; i++) {
        group = document.querySelectorAll("input[name=" + GROUP_FIELDS[i] + "]");
 
        for (j = 0; j < group.length; j++) {
            group[j].addEventListener("change", fn_on_group_change);
        }
    }

    // Check the upload as soon as a file is chosen
    document.getElementById("fufile").addEventListener("change", fn_form_input_validate_fufile);
}
 
// This file is loaded with defer, so it runs before DOMContentLoaded fires and this still works.
document.addEventListener("DOMContentLoaded", fn_init);
// Good: runs when the user clicks submit
//document.querySelector("form").addEventListener("submit", function (e) {  if (!fn_form_input_validate_fempno()) {    e.preventDefault();  }});
