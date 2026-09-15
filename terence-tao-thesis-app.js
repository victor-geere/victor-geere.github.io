(async function () {
  const parts = window.TAO_GZ;
  if (!parts || parts.length < 3) {
    document.body.innerHTML = '<p class=boot>Missing page chunks.</p>';
    return;
  }
  const b64 = parts.join('');
  const bin = Uint8Array.from(atob(b64), function (c) { return c.charCodeAt(0); });
  const ds = new DecompressionStream('gzip');
  const stream = new Blob([bin]).stream().pipeThrough(ds);
  const text = await new Response(stream).text();
  document.open();
  document.write(text);
  document.close();
})();
