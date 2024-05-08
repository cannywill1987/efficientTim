function preload() {
// 预加载字体文件
//fetch('/assets/fonts/MaterialIcons-Regular.otf');
//fetch('/assets/packages/cupertino_icons/assets/CupertinoIcons.ttf');
fetch('/assets/packages/font_awesome_flutter/lib/fonts/fa-brands-400.ttf');
fetch('/assets/packages/font_awesome_flutter/lib/fonts/fa-regular-400.ttf');
fetch('/assets/packages/font_awesome_flutter/lib/fonts/fa-solid-900.ttf');
fetch('/assets/packages/u_credit_card/fonts/OCR-A-regular.ttf');

// 预加载CSS文件
fetch('/assets/packages/fluttertoast/assets/toastify.css');

// 预加载JavaScript文件
fetch('/assets/packages/fluttertoast/assets/toastify.js');
fetch('/assets/packages/wakelock_web/assets/no_sleep.js');
}


function show(title) {
    document.getElementById('loading').style.display = 'flex';
    document.getElementById('loading-title').textContent = title;
}
  
function dismiss() {
    document.getElementById('loading').style.display = 'none';
}

//setTimeout(function(){
// show(i18n.t("first_time_loading"));
// }, 10);

document.addEventListener("DOMContentLoaded", function(){
    show(i18n.t("first_time_loading"));

});
