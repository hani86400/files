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




function fn_format_size(bytes) {
    if (bytes < 1024)    { return bytes + " B";    }
    if (bytes < 1048576) {  return (bytes / 1024).toFixed(1) + " KB";    }
    return (bytes / 1048576).toFixed(1) + " MB";
}

function fn_get_file() {
    var input = get("fufile");

    return (input && input.files && input.files.length > 0) ? input.files[0] : null;
}

function fn_file_info() {
    var file = fn_get_file();

    return file ? file.name + " (" + fn_format_size(file.size) + ")" : "none";
}

function validate_fufile() {
    var file = fn_get_file();
    var ext;

    if (!file) {
        return true;
    }

    ext = file.name.split(".").pop().toLowerCase();

    if (FILE_EXTENSIONS.indexOf(ext) === -1) {
        fn_form_input_show_error("fufile", "Allowed file types: " + FILE_EXTENSIONS.join(", ") + ".");
        return false;
    }

    if (file.size > FILE_MAX_MB * 1024 * 1024) {
        fn_form_input_show_error("fufile", "File is too large (" + fn_format_size(file.size) + "). Maximum is " + FILE_MAX_MB + " MB.");
        return false;
    }

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



function fn_file_to_base64(file) {
  return new Promise((resolve, reject) => {
    const reader = new FileReader();
    reader.onload = () => resolve(reader.result); // Returns "data:image/png;base64,..."
    reader.onerror = (err) => reject(err);
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


function fn_form_input_set_gender() {
  const radios = document.querySelectorAll('input[name="fgender"]');
  if (radios.length === 0) return;

  const randomIndex = Math.floor(Math.random() * radios.length);
  radios[randomIndex].checked = true;
}


function fn_form_input_set_actions() {
factions_gsheet.checked = Math.random() < 0.5;
factions_gdrive.checked = Math.random() < 0.5;
factions_gmail.checked  = Math.random() < 0.5;
factions_cfd1.checked   = Math.random() < 0.5;

// Guarantee at least one is checked
if (![factions_gsheet, factions_gdrive, factions_gmail, factions_cfd1].some(c => c.checked)) {
  [factions_gsheet, factions_gdrive, factions_gmail, factions_cfd1][Math.floor(Math.random() * 4)].checked = true;
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
/*
    var actions = document.querySelectorAll("input[name=actions]");
    for (var j = 0; j < actions.length; j++) {   actions[j].checked = (random_integer(0, 1) === 1);    }
    // Guarantee at least one action so the random data is valid
//    if (!document.querySelector("input[name=actions]:checked")) { actions[random_integer(0, actions.length - 1)].checked = true;    }
*/ 
    setStatus("", false);
}
 
 
 

// Guarantee at least one is checked
if (![factions_gsheet, factions_gdrive, factions_gmail, factions_cfd1].some(c => c.checked)) {
  [factions_gsheet, factions_gdrive, factions_gmail, factions_cfd1][Math.floor(Math.random() * 4)].checked = true;
}

