(function () {
  const parts = window.TAO_B64_PARTS;
  if (!parts || parts.length < 3) {
    document.body.innerHTML = '<p class=boot>Missing page chunks.</p>';
    return;
  }
  const b64 = parts.join('');
  const bin = atob(b64);
  const bytes = new Uint8Array(bin.length);
  for (let i = 0; i < bin.length; i++) bytes[i] = bin.charCodeAt(i);
  const text = new TextDecoder('utf-8').decode(bytes);
  document.open();
  document.write(text);
  document.close();
})();
