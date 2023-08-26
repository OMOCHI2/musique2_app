window.addEventListener("trix-file-accept", function(event) {
  // 画像の拡張子
  const acceptedTypes = ['image/jpg', 'image/jpeg', 'image/png', 'audio/mpeg',
                         'audio/x-wav', 'audio/flac', 'audio/ogg', 'video/mp4']
  if (!acceptedTypes.includes(event.file.type)) {
    event.preventDefault()
    alert("添付できる拡張子は、jpg、jpeg、png、mp3, wav, flac, ogg, mp4となっております。")
  }
  // 画像のbyte数
  const maxFileSize = 1024 * 1024 * 100 // 動画ファイルもあるため100MBまで
  if (event.file.size > maxFileSize) {
    event.preventDefault()
    alert("アップできる画像は100MBまでです。")
  }
})
