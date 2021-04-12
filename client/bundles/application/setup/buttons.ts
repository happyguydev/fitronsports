export function setupButtons(): void {
  const buttons = document.querySelectorAll('.js-back-button');
  buttons.forEach((button) => {
    button.addEventListener('click', () => {
      window.history.back();
    });
  });
}
