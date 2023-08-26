document.addEventListener("turbolinks:load", function() {
  document.addEventListener("change", function(event) {
    let image_upload = document.querySelector('.attachment--preview');
    const size_in_megabytes = image_upload.files[0].size/1024/1024;
    if (size_in_megabytes > 5) {
      alert("アップロードサイズ上限は5MBです。ファイルを再選択してください");
      image_upload.value = "";
    }
  });
});
