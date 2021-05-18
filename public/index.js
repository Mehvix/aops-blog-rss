const input = document.getElementById("input");
const output = document.getElementById("output");
const goto = document.getElementById("goto");
const copy = document.getElementById("copy");

var pageURL = window.location.href;

function gotoF(e) {
    var link = document.getElementById("output").textContent;
    RegExp(pageURL + "\\d{7}").test(link)
        ? window.open(link)
        : console.log("Goto clicked, no valid URL to open!");
}

function copyF(e) {
    var textToCopy = document.getElementById("output");

    if (RegExp(pageURL + "\\d{7}").test(textToCopy.textContent)) {
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
}

input.addEventListener("input", updateValue);
function updateValue(e) {
    var val = e.target.value;
    if (val == "") {
        output.textContent = " ";
    } else if (
        RegExp("^https://artofproblemsolving.com/community/c\\d{7}$").test(val)
    ) {
        var blog_id = RegExp(
            "(^https://artofproblemsolving.com/community/c)(\\d{7})$"
        ).exec(val)[2];
        output.textContent = pageURL + blog_id;
    } else {
        output.textContent = "Invalid URL";
    }
}
