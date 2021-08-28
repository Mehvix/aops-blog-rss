// ==UserScript==
// @name        AoPS RSS icon
// @namespace   https://github.com/Mehvix
// @match       https://artofproblemsolving.com/community/c*
// @homepage    https://github.com/Mehvix/aops-blog-rss
// @homepageURL https://github.com/Mehvix/aops-blog-rss
// @supportURL  https://github.com/Mehvix/aops-blog-rss/issues
// @downloadURL https://github.com/Mehvix/aops-blog-rss/raw/master/aops-rss-icon.user.js
// @updateURL   https://github.com/Mehvix/aops-blog-rss/raw/master/aops-rss-icon.user.js
// @grant       none
// @run-at      document-start
// @version     8-28-2021
// @author      Mehvix
// @description Adds RSS icon on AoPS blogs
// @license     GPLv3
// ==/UserScript==

let blog_id = RegExp(
    "(^https://artofproblemsolving.com/community/c)(\\d{3,})(?:\\s+(.*))?"
).exec(window.location.href)[2];
let link = "https://aops-rss.herokuapp.com/" + blog_id;
let icon = `<a href=${link}><svg xmlns="http://www.w3.org/2000/svg" width="14" height="14" style="vertical-align: middle; margin-bottom: 2px" fill="currentColor" class="bi bi-rss-fill" viewBox="0 0 16 16">
<path d="M2 0a2 2 0 0 0-2 2v12a2 2 0 0 0 2 2h12a2 2 0 0 0 2-2V2a2 2 0 0 0-2-2H2zm1.5 2.5c5.523 0 10 4.477 10 10a1 1 0 1 1-2 0 8 8 0 0 0-8-8 1 1 0 0 1 0-2zm0 4a6 6 0 0 1 6 6 1 1 0 1 1-2 0 4 4 0 0 0-4-4 1 1 0 0 1 0-2zm.5 7a1.5 1.5 0 1 1 0-3 1.5 1.5 0 0 1 0 3z"/>
</svg></a>`;

document.getElementsByTagName(
    "head"
)[0].innerHTML += `<link rel="alternate" type="application/rss+xml" title="Blog RSS" href=${link}><\/link>`;

if (AoPS.Community.Views.BlogStats) {
    // if page is a blog

    window.addEventListener(
        "load",
        function () {
            // wait until js loads
            document.getElementsByClassName("user-full")[0].innerHTML += icon;
        },
        false
    );
}
