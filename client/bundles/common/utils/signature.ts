import SignaturePad from 'signature_pad';

const refreshIconSvg = `<svg width="24" height="24" viewBox="0 0 24 24" fill="none" xmlns="http://www.w3.org/2000/svg">
<path d="M20.4709 15.5244C20.0866 15.3282 19.6161 15.4806 19.4198 15.8649C18.0129 18.6197 15.1876 20.437 12 20.437C9.09466 20.437 6.47271 18.9241 4.9706 16.5539L6.08455 17.3495C6.43568 17.6002 6.92357 17.5189 7.17435 17.1678C7.42509 16.8167 7.34376 16.3288 6.99267 16.078L3.61474 13.6654C3.12572 13.3161 2.43736 13.6295 2.38267 14.2302L2.00334 18.3916C1.96416 18.8213 2.28076 19.2013 2.71041 19.2405C3.14064 19.2796 3.52021 18.9627 3.55935 18.5334L3.66287 17.3979C5.41904 20.156 8.46763 21.9995 12 21.9995C15.8 21.9995 19.1489 19.8307 20.8113 16.5755C21.0076 16.1913 20.8552 15.7207 20.4709 15.5244Z" fill="#232527" stroke="#232527" stroke-width="0.3"/>
<path d="M21.2896 4.75894C20.8599 4.71976 20.4799 5.03637 20.4407 5.46605L20.3372 6.60156C18.581 3.84351 15.5324 2 12 2C8.19997 2 4.8511 4.16883 3.18868 7.42398C2.99243 7.80824 3.14485 8.27882 3.52911 8.47507C3.91344 8.67132 4.38395 8.51894 4.5802 8.13464C5.98712 5.3798 8.81239 3.5625 12 3.5625C14.9054 3.5625 17.5273 5.07543 19.0294 7.44562L17.9155 6.65004C17.5643 6.39929 17.0764 6.48062 16.8257 6.83172C16.5749 7.18285 16.6562 7.67074 17.0073 7.92152L20.3853 10.3341C20.8803 10.687 21.5632 10.3639 21.6173 9.76925L21.9967 5.60793C22.0359 5.1782 21.7193 4.79812 21.2896 4.75894Z" fill="#232527" stroke="#232527" stroke-width="0.3"/>
</svg>`;

export function configSignaturePad(
  canvas: HTMLCanvasElement,
  signaturePad: SignaturePad,
  hintText: string
): void {
  const ratio = Math.max(window.devicePixelRatio || 1, 1);
  canvas.width = canvas.offsetWidth * ratio;
  canvas.height = canvas.offsetHeight * ratio;
  const ctx = canvas.getContext('2d');
  ctx.scale(ratio, ratio);
  signaturePad.clear();

  // draw hint text
  
  ctx.fillStyle = 'gray';
  ctx.font = `${18 * ratio}px`;
  console.log('Signature context font size:', ctx.font);
  ctx.textAlign = 'left';
  ctx.fillText(hintText, 16, 16);

  // draw refresh icon
  const image64 = 'data:image/svg+xml;base64,' + btoa(refreshIconSvg);
  const imageTag = new Image();
  imageTag.src = image64;
  if(imageTag.complete) {
    ctx.drawImage(imageTag, canvas.width-40, 16);
  } else {
    imageTag.onload = () => {
      ctx.drawImage(imageTag, canvas.width-40, 16);
    }
  }
}

export function dataURItoBlob(dataURI) {
  // convert base64/URLEncoded data component to raw binary data held in a string
  var byteString;
  if (dataURI.split(',')[0].indexOf('base64') >= 0) {
    byteString = atob(dataURI.split(',')[1]);
  } else {
      byteString = unescape(dataURI.split(',')[1]);
  }
  // separate out the mime component
  var mimeString = dataURI.split(',')[0].split(':')[1].split(';')[0];
  // write the bytes of the string to a typed array
  var ia = new Uint8Array(byteString.length);
  for (var i = 0; i < byteString.length; i++) {
      ia[i] = byteString.charCodeAt(i);
  }

  return new Blob([ia], {type: mimeString});
}
