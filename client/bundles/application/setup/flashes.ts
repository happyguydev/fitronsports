export function removeFlashesAutomatically(): void {
  document.querySelectorAll('.js-flashes').forEach((flashMessage) => {
    setTimeout(() => {
      flashMessage.remove();
    }, 5000);
  });
}
