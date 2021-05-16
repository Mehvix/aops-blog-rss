const input = document.getElementById("input");
const output = document.getElementById("output");
const goto = document.getElementById("goto");
const copy = document.getElementById("copy");

function gotoF(e) {
    window.location = document.getElementById("output").textContent;
}

function copyF(e) {
    var textToCopy = document.getElementById("output");

    var currentRange;
    if (document.getSelection().rangeCount > 0) {
        currentRange = document.getSelection().getRangeAt(0);
        window.getSelection().removeRange(currentRange);
    } else {
        currentRange = false;
    }

    var CopyRange = document.createRange();
    CopyRange.selectNode(textToCopy);
    window.getSelection().addRange(CopyRange);
    document.execCommand("copy");

    window.getSelection().removeRange(CopyRange);

    if (currentRange) {
        window.getSelection().addRange(currentRange);
    }
}

input.addEventListener("input", updateValue);
function updateValue(e) {
    var val = e.target.value;
    if (val == "") {
        output.textContent = " ";
    } else if (
        RegExp("^https://artofproblemsolving.com/community/c\\d{7}$").test(val)
    ) {
        var url = window.location.href.split("/");
        var blog_id = RegExp(
            "(^https://artofproblemsolving.com/community/c)(\\d{7})$"
        ).exec(val)[2];
        var new_url = url[0] + "//" + url[2] + "/" + blog_id;
        output.textContent = new_url;
    } else {
        output.textContent = "Invalid URL";
    }
}
